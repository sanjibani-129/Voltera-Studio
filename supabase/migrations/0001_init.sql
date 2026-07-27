-- ============================================================================
-- Voltra platform schema
-- Run this in Supabase SQL Editor, or via `supabase db push` if using the CLI.
-- ============================================================================

-- 1. PROFILES ----------------------------------------------------------------
-- Mirrors auth.users, created automatically on signup via trigger below.
create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  email text not null,
  full_name text,
  avatar_url text,
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

create policy "Profiles are viewable by owner" on public.profiles
  for select using (auth.uid() = id);

create policy "Profiles are updatable by owner" on public.profiles
  for update using (auth.uid() = id);

-- Auto-create a profile row whenever a new auth user signs up.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, email, full_name, avatar_url)
  values (
    new.id,
    new.email,
    new.raw_user_meta_data ->> 'full_name',
    new.raw_user_meta_data ->> 'avatar_url'
  );
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- 2. COMPONENTS ---------------------------------------------------------------
create table if not exists public.components (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  name text not null,
  category text not null,               -- e.g. "Microcontroller", "Passive", "Sensor"
  short_description text not null,
  long_description text,
  image_url text,
  model_url text,                       -- .glb/.gltf URL for the 3D viewer, nullable (falls back to a generated placeholder)
  specs jsonb not null default '{}',     -- freeform key/value spec table, e.g. {"Voltage": "3.3V-5V", "Package": "DIP-8"}
  tags text[] not null default '{}',
  difficulty text not null default 'beginner' check (difficulty in ('beginner', 'intermediate', 'advanced')),
  search_vector tsvector generated always as (
    to_tsvector('english', coalesce(name, '') || ' ' || coalesce(category, '') || ' ' || coalesce(short_description, ''))
  ) stored,
  created_at timestamptz not null default now()
);

create index if not exists components_search_idx on public.components using gin (search_vector);
create index if not exists components_category_idx on public.components (category);

alter table public.components enable row level security;

create policy "Components are public read" on public.components
  for select using (true);

-- 3. COMPONENT PINS (for interactive pin diagrams) -----------------------------
create table if not exists public.component_pins (
  id uuid primary key default gen_random_uuid(),
  component_id uuid not null references public.components (id) on delete cascade,
  pin_number int not null,
  label text not null,
  description text,
  x numeric not null,   -- percentage position (0-100) on the diagram image, for overlay placement
  y numeric not null,
  pin_type text not null default 'io' check (pin_type in ('power', 'ground', 'io', 'analog', 'special')),
  unique (component_id, pin_number)
);

alter table public.component_pins enable row level security;

create policy "Pins are public read" on public.component_pins
  for select using (true);

-- 4. QUIZ SYSTEM ---------------------------------------------------------------
create table if not exists public.quiz_topics (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  title text not null,
  description text,
  difficulty text not null default 'beginner' check (difficulty in ('beginner', 'intermediate', 'advanced'))
);

alter table public.quiz_topics enable row level security;
create policy "Quiz topics are public read" on public.quiz_topics for select using (true);

create table if not exists public.quiz_questions (
  id uuid primary key default gen_random_uuid(),
  topic_id uuid not null references public.quiz_topics (id) on delete cascade,
  question text not null,
  options jsonb not null,           -- ["Option A", "Option B", "Option C", "Option D"]
  correct_index int not null,
  explanation text,
  order_index int not null default 0
);

alter table public.quiz_questions enable row level security;
create policy "Quiz questions are public read" on public.quiz_questions for select using (true);

create table if not exists public.quiz_attempts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles (id) on delete cascade,
  topic_id uuid not null references public.quiz_topics (id) on delete cascade,
  score int not null,
  total_questions int not null,
  answers jsonb not null default '[]',
  completed_at timestamptz not null default now()
);

alter table public.quiz_attempts enable row level security;

create policy "Users can view own quiz attempts" on public.quiz_attempts
  for select using (auth.uid() = user_id);

create policy "Users can insert own quiz attempts" on public.quiz_attempts
  for insert with check (auth.uid() = user_id);

-- 5. FAVORITES ------------------------------------------------------------------
create table if not exists public.favorites (
  user_id uuid not null references public.profiles (id) on delete cascade,
  component_id uuid not null references public.components (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, component_id)
);

alter table public.favorites enable row level security;

create policy "Users can view own favorites" on public.favorites
  for select using (auth.uid() = user_id);

create policy "Users can insert own favorites" on public.favorites
  for insert with check (auth.uid() = user_id);

create policy "Users can delete own favorites" on public.favorites
  for delete using (auth.uid() = user_id);

-- 6. AI TUTOR CONVERSATION HISTORY (optional persistence) -----------------------
create table if not exists public.tutor_messages (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles (id) on delete cascade,
  role text not null check (role in ('user', 'assistant')),
  content text not null,
  created_at timestamptz not null default now()
);

alter table public.tutor_messages enable row level security;

create policy "Users can view own tutor messages" on public.tutor_messages
  for select using (auth.uid() = user_id);

create policy "Users can insert own tutor messages" on public.tutor_messages
  for insert with check (auth.uid() = user_id);

-- 7. SEED DATA --------------------------------------------------------------
insert into public.components (slug, name, category, short_description, long_description, image_url, specs, tags, difficulty)
values
  ('esp32', 'ESP32', 'Microcontroller', 'Dual-core Wi-Fi + Bluetooth microcontroller for IoT projects.',
    'The ESP32 is a low-cost, low-power system on a chip with integrated Wi-Fi and dual-mode Bluetooth. Popular for IoT, robotics, and embedded prototyping.',
    '/comp-esp32.png',
    '{"Voltage": "2.2V-3.6V", "CPU": "Dual-core 240MHz", "Flash": "4MB", "Package": "38-pin module"}',
    '{"microcontroller", "wifi", "bluetooth", "iot"}', 'intermediate'),
  ('npn-transistor', 'NPN Transistor (2N2222)', 'Semiconductor', 'General-purpose bipolar junction transistor for switching and amplification.',
    'The 2N2222 is one of the most common NPN transistors, used for switching and amplifying signals in low-power circuits.',
    '/comp-transistor.png',
    '{"Voltage": "40V max", "Current": "800mA max", "Package": "TO-92"}',
    '{"transistor", "switching", "amplifier"}', 'beginner'),
  ('electrolytic-capacitor', 'Electrolytic Capacitor', 'Passive', 'Polarized capacitor for high-capacitance energy storage and filtering.',
    'Electrolytic capacitors offer high capacitance in a small package, commonly used for power supply filtering and decoupling.',
    '/comp-capacitor.png',
    '{"Capacitance": "1uF-10,000uF", "Voltage": "6.3V-450V", "Polarized": "Yes"}',
    '{"capacitor", "passive", "filtering"}', 'beginner'),
  ('led', 'LED', 'Optoelectronic', 'Light-emitting diode for indicators and displays.',
    'LEDs convert electrical current directly into light and are among the most common components in electronics projects.',
    '/comp-led.png',
    '{"Forward Voltage": "1.8V-3.3V", "Current": "20mA typical", "Package": "5mm THT"}',
    '{"led", "indicator", "diode"}', 'beginner'),
  ('relay', 'Relay (SPDT)', 'Electromechanical', 'Electrically operated switch for controlling high-power circuits with low-power signals.',
    'Relays let a microcontroller safely switch mains-voltage or high-current loads via an isolated electromagnetic switch.',
    '/comp-relay.png',
    '{"Coil Voltage": "5V/12V", "Contact Rating": "10A @ 250VAC", "Package": "THT"}',
    '{"relay", "switching", "isolation"}', 'intermediate'),
  ('servo-motor', 'Servo Motor (SG90)', 'Actuator', 'Small PWM-controlled motor with precise angular positioning.',
    'The SG90 micro servo is a lightweight, PWM-controlled actuator commonly used in robotics and RC projects.',
    '/comp-servo.png',
    '{"Voltage": "4.8V-6V", "Torque": "1.8kg-cm", "Rotation": "0-180deg"}',
    '{"servo", "motor", "actuator", "pwm"}', 'beginner')
on conflict (slug) do nothing;

insert into public.quiz_topics (slug, title, description, difficulty)
values
  ('ohms-law', "Ohm's Law", 'Voltage, current, and resistance fundamentals.', 'beginner'),
  ('digital-logic', 'Digital Logic', 'Logic gates, truth tables, and boolean algebra.', 'intermediate'),
  ('microcontrollers', 'Microcontroller Basics', 'GPIO, PWM, interrupts, and communication protocols.', 'intermediate')
on conflict (slug) do nothing;
