# Voltra — AI Electronics Learning Platform

This project started as a v0-generated marketing landing page and has been extended into a full
application: Supabase auth + database, a searchable component library, dynamic component pages with
a 3D model viewer and interactive pin diagrams, an AI tutor, a comparison tool, a quiz system, and a
user dashboard with favorites. The original landing page UI and design system are untouched.

## 1. Install dependencies

```bash
pnpm install
# or npm install / yarn install
```

## 2. Create a Supabase project

1. Go to [supabase.com](https://supabase.com) → **New Project**.
2. Once provisioned, open **Project Settings → API** and copy:
   - Project URL
   - `anon` public key
   - `service_role` key (server-only, keep secret)

## 3. Configure environment variables

Copy `.env.example` to `.env.local` and fill in the values from step 2, plus an Anthropic API key
for the AI tutor:

```bash
cp .env.example .env.local
```

```
NEXT_PUBLIC_SUPABASE_URL=...
NEXT_PUBLIC_SUPABASE_ANON_KEY=...
SUPABASE_SERVICE_ROLE_KEY=...
ANTHROPIC_API_KEY=...
```

## 4. Run the database migrations

In the Supabase dashboard, go to **SQL Editor** and run, in order:

1. `supabase/migrations/0001_init.sql` — tables, RLS policies, and seed components/quiz topics
2. `supabase/migrations/0002_seed_pins_and_quiz.sql` — ESP32 pin diagram + quiz question seed data

(If you use the Supabase CLI instead: `supabase db push`.)

## 5. Enable email auth

In **Authentication → Providers**, make sure Email is enabled. For local development you can turn
off "Confirm email" under **Authentication → Settings** so signup logs you in immediately.

## 6. Run the app

```bash
pnpm dev
```

Visit `http://localhost:3000`. Sign up, browse `/components`, try `/compare` and `/quiz`, and check
`/dashboard` after favoriting something or completing a quiz.

## Architecture notes

- `lib/supabase/{client,server,middleware}.ts` — three separate Supabase client factories for
  Client Components, Server Components/Actions, and middleware (session refresh + route protection).
- `lib/actions/*` — all data access goes through server actions, not client-side fetches, so RLS
  and the service-role key never touch the browser.
- `middleware.ts` — protects `/dashboard` (and `/favorites`) by redirecting unauthenticated users to
  `/login`.
- `components/electronics/component-3d-viewer.tsx` — lazy-loaded via `next/dynamic` since
  three.js/react-three-fiber is a large bundle; it only downloads when the "3D Model" tab is opened.
  Renders a real `.glb` if `components.model_url` is set, otherwise a placeholder mesh.
- `app/api/ai-tutor/route.ts` — calls the Anthropic API server-side; the API key never reaches the
  client. Best-effort persists the conversation to `tutor_messages` when the user is signed in.
- Adding real component images/3D models: upload to Supabase Storage, make the bucket public, and
  set `image_url` / `model_url` on the relevant row in `components`. `next.config.mjs` already
  allowlists `*.supabase.co/storage/v1/object/public/**` for `next/image`.
