-- ============================================================================
-- Voltra Electronics Encyclopedia -- 05_new_quiz_questions.sql
--
-- SCHEMA ANALYSIS (performed before writing any SQL below):
--   public.quiz_topics    (id, slug unique, title, description,
--                           difficulty in ('beginner','intermediate','advanced'))
--   public.quiz_questions (id, topic_id -> quiz_topics, question, options jsonb,
--                           correct_index int, explanation, order_index)
--   Existing data found: 3 topics (ohms-law: 4 questions, digital-logic: 3
--   questions, microcontrollers: 0 questions) = 7 existing questions total.
--   quiz_questions has NO per-question difficulty column and NO component
--   reference column -- both are required by this task's brief, so this
--   script adds two nullable columns before inserting. This is an additive
--   schema change only: it does not alter or delete a single existing row's
--   data. Every data-changing statement below is an INSERT (or an
--   "ON CONFLICT DO NOTHING" topic insert, which is a no-op against existing
--   rows) -- there are no UPDATE or DELETE statements against quiz data.
--
-- Adds ~100 new multiple-choice questions across 57 electronics topics.
-- New topic rows use ON CONFLICT (slug) DO NOTHING so the 3 existing topics
-- (ohms-law, digital-logic, microcontrollers) are left completely untouched;
-- new questions for those same topics are appended with order_index values
-- starting well above their existing rows (100+) to avoid any collision.
-- None of the 100 new questions duplicate the 7 existing ones.
--
-- Run AFTER 01_update_components.sql (component_id references public.components).
-- ============================================================================

-- 1. Additive schema changes (idempotent, no existing rows are modified) -----
alter table public.quiz_questions add column if not exists difficulty text
  check (difficulty in ('easy', 'medium', 'hard'));
alter table public.quiz_questions add column if not exists component_id uuid
  references public.components (id) on delete set null;
create index if not exists quiz_questions_difficulty_idx on public.quiz_questions (difficulty);

-- 2. New quiz topics (existing topics are left untouched via DO NOTHING) -----
insert into public.quiz_topics (slug, title, description, difficulty) values

  ('basic-electronics', 'Basic Electronics', 'Core concepts every electronics student starts with.', 'beginner'),
  ('electrical-fundamentals', 'Electrical Fundamentals', 'Charge, current, voltage, power, and energy.', 'beginner'),
  ('kirchhoffs-laws', 'Kirchhoff''s Laws', 'Current and voltage laws for analyzing circuits.', 'intermediate'),
  ('resistors', 'Resistors', 'Fixed and variable resistors, color codes, and power rating.', 'beginner'),
  ('capacitors', 'Capacitors', 'Capacitance, charging behavior, and capacitor types.', 'beginner'),
  ('inductors', 'Inductors', 'Magnetic energy storage and inductor behavior.', 'intermediate'),
  ('diodes', 'Diodes', 'P-N junction behavior and rectification.', 'beginner'),
  ('leds', 'LEDs', 'Light-emitting diode operation and driving circuits.', 'beginner'),
  ('zener-diodes', 'Zener Diodes', 'Reverse breakdown regulation and voltage references.', 'intermediate'),
  ('bjts', 'BJTs', 'Bipolar junction transistor operation and biasing.', 'intermediate'),
  ('mosfets', 'MOSFETs', 'Field-effect transistor switching and gate drive.', 'intermediate'),
  ('scrs', 'SCRs', 'Silicon-controlled rectifiers and latching behavior.', 'advanced'),
  ('triacs', 'TRIACs', 'Bidirectional AC switching devices.', 'advanced'),
  ('operational-amplifiers', 'Operational Amplifiers', 'Op-amp configurations and ideal behavior.', 'intermediate'),
  ('comparator-circuits', 'Comparator Circuits', 'Voltage comparison and hysteresis.', 'intermediate'),
  ('555-timer', '555 Timer', 'Astable, monostable, and bistable timer configurations.', 'intermediate'),
  ('flip-flops', 'Flip-Flops', 'Bistable memory elements in digital circuits.', 'intermediate'),
  ('counters', 'Counters', 'Sequential logic circuits that count clock pulses.', 'intermediate'),
  ('registers', 'Registers', 'Shift registers and parallel data storage.', 'intermediate'),
  ('adc-dac', 'ADC & DAC', 'Converting between analog and digital signals.', 'intermediate'),
  ('voltage-regulators', 'Voltage Regulators', 'Linear and switching regulation techniques.', 'intermediate'),
  ('power-supplies', 'Power Supplies', 'AC-DC conversion, filtering, and regulation stages.', 'intermediate'),
  ('transformers', 'Transformers', 'Mutual induction and voltage transformation.', 'intermediate'),
  ('oscillators', 'Oscillators', 'Circuits that generate periodic waveforms.', 'intermediate'),
  ('crystals', 'Crystals', 'Piezoelectric frequency references.', 'intermediate'),
  ('pcb-design', 'PCB Design', 'Layout, traces, and manufacturing considerations.', 'intermediate'),
  ('soldering', 'Soldering', 'Hand soldering technique and best practice.', 'beginner'),
  ('arduino', 'Arduino', 'The Arduino platform and its programming model.', 'beginner'),
  ('esp32', 'ESP32', 'Dual-core Wi-Fi/Bluetooth microcontroller SoC.', 'intermediate'),
  ('esp8266', 'ESP8266', 'Low-cost Wi-Fi enabled microcontroller.', 'intermediate'),
  ('raspberry-pi-pico', 'Raspberry Pi Pico', 'RP2040-based low-cost microcontroller board.', 'intermediate'),
  ('stm32', 'STM32', '32-bit ARM Cortex-M microcontroller family.', 'advanced'),
  ('sensors', 'Sensors', 'General sensing principles across sensor types.', 'beginner'),
  ('hc-sr04', 'HC-SR04', 'Ultrasonic distance measurement module.', 'beginner'),
  ('dht11', 'DHT11', 'Basic digital temperature and humidity sensor.', 'beginner'),
  ('mpu6050', 'MPU6050', '6-axis accelerometer and gyroscope IMU.', 'intermediate'),
  ('rfid', 'RFID', 'Radio-frequency identification systems.', 'intermediate'),
  ('gps', 'GPS', 'Satellite-based positioning systems.', 'intermediate'),
  ('gsm', 'GSM', 'Cellular voice/SMS/data connectivity.', 'intermediate'),
  ('bluetooth', 'Bluetooth', 'Short-range wireless communication.', 'beginner'),
  ('wifi', 'Wi-Fi', 'Wireless local area networking.', 'beginner'),
  ('lora', 'LoRa', 'Long-range, low-power wireless communication.', 'advanced'),
  ('oled-displays', 'OLED Displays', 'Self-emissive pixel display technology.', 'intermediate'),
  ('lcd-displays', 'LCD Displays', 'Liquid crystal character and graphic displays.', 'beginner'),
  ('servo-motors', 'Servo Motors', 'PWM-controlled position actuators.', 'beginner'),
  ('stepper-motors', 'Stepper Motors', 'Precise open-loop rotational positioning.', 'intermediate'),
  ('dc-motors', 'DC Motors', 'Continuous rotation electric motors.', 'beginner'),
  ('motor-drivers', 'Motor Drivers', 'H-bridges and current amplification for motors.', 'intermediate'),
  ('relay-modules', 'Relay Modules', 'Electromechanical and solid-state switching.', 'beginner'),
  ('digital-electronics', 'Digital Electronics', 'Binary systems and digital circuit design.', 'intermediate'),
  ('analog-electronics', 'Analog Electronics', 'Continuous signal circuits and amplification.', 'intermediate'),
  ('iot', 'IoT', 'Connected embedded devices and cloud integration.', 'intermediate'),
  ('electronic-measurements', 'Electronic Measurements', 'Multimeters, oscilloscopes, and measurement technique.', 'beginner'),
  ('safety', 'Safety', 'Electrical safety practices in the lab and field.', 'beginner')
on conflict (slug) do nothing;

-- 3. New quiz questions (100 total, INSERT-only) -----------------------------

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'Which of these is a passive electronic component?', '["Transistor", "Resistor", "Operational amplifier", "Microcontroller"]'::jsonb, 1, 'Passive components (resistors, capacitors, inductors) cannot amplify or generate power on their own, they only dissipate, store, or release energy. Transistors, op-amps, and microcontrollers are active components that require an external power supply to operate and can amplify or switch signals.', 1, 'easy', NULL
from public.quiz_topics t where t.slug = 'basic-electronics';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What is the SI unit of electric current?', '["Volt", "Ohm", "Ampere", "Watt"]'::jsonb, 2, 'Electric current is measured in amperes (A), named after Andre-Marie Ampere. One ampere represents one coulomb of charge flowing past a point per second.', 2, 'easy', NULL
from public.quiz_topics t where t.slug = 'basic-electronics';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What quantity does the coulomb measure?', '["Electric charge", "Electric current", "Electric potential", "Electric power"]'::jsonb, 0, 'The coulomb (C) is the SI unit of electric charge, defined as the charge transported by a steady current of one ampere in one second. Current, by contrast, is measured in amperes, and potential in volts.', 1, 'easy', NULL
from public.quiz_topics t where t.slug = 'electrical-fundamentals';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'Electrical power is calculated using which formula?', '["P = V / I", "P = V x I", "P = I / V", "P = V + I"]'::jsonb, 1, 'Power equals voltage multiplied by current (P = VI), derived from combining the definitions of voltage (energy per charge) and current (charge per time). This can also be rewritten as P = I^2R or P = V^2/R using Ohm''s law.', 2, 'easy', NULL
from public.quiz_topics t where t.slug = 'electrical-fundamentals';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What does it mean for a circuit to be in ''series''?', '["Components share the same two nodes", "Components form a single path for current", "Current splits between multiple paths", "Voltage is the same across all components"]'::jsonb, 1, 'In a series circuit, components are connected end to end so that the same current flows through each one in a single loop. In contrast, a parallel circuit provides multiple paths for current and the voltage across each branch is the same.', 3, 'medium', NULL
from public.quiz_topics t where t.slug = 'electrical-fundamentals';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'A resistor has 6V across it and 2A flowing through it. What is its resistance?', '["12 ohm", "3 ohm", "8 ohm", "4 ohm"]'::jsonb, 1, 'Using R = V / I, R = 6V / 2A = 3 ohm. Ohm''s law relates voltage, current, and resistance so that any two values let you solve for the third.', 101, 'easy', NULL
from public.quiz_topics t where t.slug = 'ohms-law';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What happens to current if resistance is doubled while voltage stays the same?', '["Current doubles", "Current is halved", "Current stays the same", "Current quadruples"]'::jsonb, 1, 'Since I = V / R, doubling R while keeping V constant halves the current. This inverse relationship is a direct consequence of Ohm''s law.', 102, 'easy', NULL
from public.quiz_topics t where t.slug = 'ohms-law';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'In Ohm''s law, which quantity is held constant for an ideal resistor across changing voltage?', '["Current", "Power", "Resistance", "Charge"]'::jsonb, 2, 'An ideal (ohmic) resistor has a constant resistance regardless of the applied voltage or current, which is exactly what makes V = IR a straight line on a V-I graph. Real components can deviate from this at extreme conditions, but the ideal model assumes constant R.', 103, 'medium', NULL
from public.quiz_topics t where t.slug = 'ohms-law';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'Kirchhoff''s Current Law (KCL) states that at any node:', '["Voltage around the node is zero", "Current entering equals current leaving", "Power is conserved", "Resistance is additive"]'::jsonb, 1, 'KCL is a statement of charge conservation: the total current flowing into a junction must equal the total current flowing out, since charge cannot accumulate at an ideal node. This lets engineers write equations for circuits with multiple current paths.', 1, 'easy', NULL
from public.quiz_topics t where t.slug = 'kirchhoffs-laws';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'Kirchhoff''s Voltage Law (KVL) states that:', '["The sum of currents at a node is zero", "The sum of voltage drops around a closed loop equals zero", "Voltage is always positive", "Total resistance in a loop must be zero"]'::jsonb, 1, 'KVL follows from conservation of energy: as you traverse any closed loop in a circuit and sum all the voltage rises and drops, the total must equal zero. This lets you solve for unknown voltages in circuits with multiple loops.', 2, 'medium', NULL
from public.quiz_topics t where t.slug = 'kirchhoffs-laws';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'In a loop with a 9V battery and two resistors dropping 4V and 3V, what is the voltage across the third element?', '["9V", "2V", "7V", "12V"]'::jsonb, 1, 'By KVL, the sum of all voltage drops around the loop must equal the source voltage: 9V - 4V - 3V = 2V remaining for the third element. This ensures the total rise equals the total drop around the closed loop.', 3, 'hard', NULL
from public.quiz_topics t where t.slug = 'kirchhoffs-laws';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'A resistor is color-banded yellow-violet-red-gold. What is its approximate value?', '["47 ohm +/-5%", "4700 ohm +/-5%", "470 ohm +/-5%", "47000 ohm +/-5%"]'::jsonb, 1, 'Yellow=4, violet=7, red means multiply by 100, and gold is a +/-5% tolerance band, giving 47 x 100 = 4700 ohm at 5% tolerance. Reading resistor color codes correctly is a core skill for identifying unmarked through-hole resistors.', 1, 'hard', (select id from public.components where slug = 'carbon-film-resistor')
from public.quiz_topics t where t.slug = 'resistors';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What happens when two equal-value resistors are connected in parallel?', '["Total resistance doubles", "Total resistance is halved", "Total resistance stays the same", "Total resistance becomes zero"]'::jsonb, 1, 'For resistors in parallel, 1/Rtotal = 1/R1 + 1/R2; with two equal resistors R, this gives Rtotal = R/2, so the combined resistance is half of a single resistor''s value. Parallel resistance is always less than the smallest individual resistor.', 2, 'medium', (select id from public.components where slug = 'carbon-film-resistor')
from public.quiz_topics t where t.slug = 'resistors';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What happens to a fully discharged capacitor the instant a DC voltage is applied?', '["It behaves like an open circuit", "It behaves like a short circuit", "It blocks all current permanently", "It behaves like a resistor"]'::jsonb, 1, 'A fully discharged capacitor initially offers almost no opposition to current, briefly behaving like a short circuit, because no charge has yet built up on its plates. As charge accumulates, the voltage across it rises and the charging current decreases exponentially toward zero.', 1, 'hard', (select id from public.components where slug = 'ceramic-capacitor')
from public.quiz_topics t where t.slug = 'capacitors';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'Which capacitor type is polarized and must be connected with correct orientation?', '["Ceramic capacitor", "Film capacitor", "Electrolytic capacitor", "Air variable capacitor"]'::jsonb, 2, 'Electrolytic (and tantalum) capacitors use a chemically formed oxide dielectric layer that only works correctly with one polarity; reversing the connection can damage or rupture the capacitor. Ceramic and film capacitors are non-polarized and can be inserted either way.', 2, 'easy', (select id from public.components where slug = 'electrolytic-capacitor')
from public.quiz_topics t where t.slug = 'capacitors';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What property of an inductor opposes a sudden change in current?', '["Capacitance", "Self-inductance", "Resistance", "Conductance"]'::jsonb, 1, 'Self-inductance causes an inductor to generate a back-EMF that opposes any change in the current flowing through it, per Faraday''s and Lenz''s laws. This is why inductors resist sudden current changes but freely pass steady DC current.', 1, 'hard', (select id from public.components where slug = 'toroidal-inductor')
from public.quiz_topics t where t.slug = 'inductors';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What is the unit of inductance?', '["Farad", "Henry", "Ohm", "Tesla"]'::jsonb, 1, 'Inductance is measured in henries (H), named after Joseph Henry. One henry is the inductance that produces one volt of induced EMF when current changes at a rate of one ampere per second.', 2, 'easy', (select id from public.components where slug = 'toroidal-inductor')
from public.quiz_topics t where t.slug = 'inductors';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What is the typical forward voltage drop of a silicon diode?', '["0.2V", "0.7V", "1.5V", "3.3V"]'::jsonb, 1, 'Silicon diodes typically begin conducting significantly around 0.6-0.7V forward bias, a value set by the semiconductor''s bandgap energy. Germanium diodes have a lower drop (~0.3V) while Schottky diodes drop even less (~0.2-0.4V).', 1, 'easy', (select id from public.components where slug = 'rectifier-diode-1n4007')
from public.quiz_topics t where t.slug = 'diodes';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What happens to a diode when reverse voltage exceeds its breakdown rating?', '["It conducts normally", "It permanently blocks all current", "It may be damaged by uncontrolled reverse current", "It becomes an insulator forever"]'::jsonb, 2, 'Exceeding a standard diode''s reverse breakdown voltage causes avalanche or thermal breakdown, letting a large uncontrolled reverse current flow that can permanently damage the device unless current is externally limited. Zener diodes are specifically designed to survive controlled breakdown, unlike standard rectifier diodes.', 2, 'medium', (select id from public.components where slug = 'rectifier-diode-1n4007')
from public.quiz_topics t where t.slug = 'diodes';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'Which diode configuration converts full-wave AC into pulsating DC using four diodes?', '["Half-wave rectifier", "Bridge rectifier", "Voltage doubler", "Clamper circuit"]'::jsonb, 1, 'A bridge rectifier arranges four diodes so each half-cycle of the AC input is routed through a different diagonal pair, producing a continuous unidirectional (though pulsating) output without needing a center-tapped transformer. A half-wave rectifier, by contrast, uses only one diode and passes only half of each AC cycle.', 3, 'medium', (select id from public.components where slug = 'bridge-rectifier')
from public.quiz_topics t where t.slug = 'diodes';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'Why does an LED need a current-limiting resistor in a typical circuit?', '["To increase brightness", "To prevent excessive current from damaging the LED", "To reverse the polarity", "To convert AC to DC"]'::jsonb, 1, 'An LED''s forward voltage stays roughly constant while current rises very steeply for small increases in voltage past the threshold, so without a series resistor to limit current, the LED can draw destructive current and burn out. The resistor value is chosen using Ohm''s law based on the supply voltage minus the LED''s forward voltage.', 1, 'easy', (select id from public.components where slug = 'led-5mm')
from public.quiz_topics t where t.slug = 'leds';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What determines the color of light emitted by an LED?', '["The size of the LED package", "The semiconductor material''s bandgap energy", "The forward current magnitude", "The polarity of connection"]'::jsonb, 1, 'The color of an LED''s emitted light is set by the bandgap energy of its semiconductor material, which determines the energy (and therefore wavelength) of photons released when electrons and holes recombine. Different compound semiconductors (like GaAs, GaN, or InGaN) are used to achieve red, blue, or other colors.', 2, 'medium', (select id from public.components where slug = 'led-5mm')
from public.quiz_topics t where t.slug = 'leds';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'How is a Zener diode typically connected in a voltage reference circuit?', '["Forward biased", "Reverse biased", "Connected in series with no resistor", "Connected without any bias"]'::jsonb, 1, 'Zener diodes are intentionally operated in reverse bias, in their controlled breakdown region, where they hold a nearly constant voltage across a range of currents. A series resistor is required to limit current through the Zener into its safe operating range.', 1, 'hard', (select id from public.components where slug = 'zener-diode')
from public.quiz_topics t where t.slug = 'zener-diodes';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'In an NPN transistor operating in the active region, what is required at the base-emitter junction?', '["Reverse bias", "Forward bias", "Zero bias", "AC bias only"]'::jsonb, 1, 'For active-region operation, the base-emitter junction must be forward biased (enabling base current to flow) while the base-collector junction is reverse biased. This combination lets a small base current control a much larger collector current.', 1, 'medium', (select id from public.components where slug = 'npn-transistor-2n2222')
from public.quiz_topics t where t.slug = 'bjts';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What does hFE (or beta) represent in a BJT?', '["The ratio of collector current to base current", "The forward voltage drop", "The maximum collector voltage", "The switching frequency"]'::jsonb, 0, 'hFE, also called the current gain (beta), is the ratio of collector current to base current in the active region (Ic / Ib). A higher hFE means a smaller base current is needed to control a given collector current.', 2, 'easy', (select id from public.components where slug = 'npn-transistor-2n2222')
from public.quiz_topics t where t.slug = 'bjts';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'Which BJT configuration is most commonly used for high-current switching applications like driving a relay?', '["Common base", "Common collector as a switch driven into saturation", "Differential pair", "Cascode"]'::jsonb, 1, 'For switching applications, a BJT is typically driven fully into saturation (fully on) or cutoff (fully off) rather than operated in its linear active region, minimizing power dissipation. A Darlington pair configuration is often used when the load current exceeds what a single BJT''s gain can handle from an available base drive.', 3, 'hard', (select id from public.components where slug = 'darlington-transistor-tip120')
from public.quiz_topics t where t.slug = 'bjts';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What is the key advantage of a MOSFET gate compared to a BJT base for driving from a microcontroller?', '["The gate requires continuous current to stay on", "The gate draws virtually no continuous current", "The gate must be reverse biased", "The gate has a fixed threshold of 0V"]'::jsonb, 1, 'A MOSFET gate is electrically insulated from the channel, so once charged it draws essentially no continuous DC current to stay in its on or off state, unlike a BJT base which needs continuous base current to sustain conduction. This makes MOSFETs efficient for PWM switching applications.', 1, 'medium', (select id from public.components where slug = 'mosfet-irlz44n')
from public.quiz_topics t where t.slug = 'mosfets';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What does ''logic-level'' mean when describing a MOSFET like the IRLZ44N?', '["It only works with digital signals, not analog", "It fully turns on with a low gate voltage like 3.3V or 5V", "It cannot handle high current", "It has no threshold voltage"]'::jsonb, 1, 'A logic-level MOSFET is manufactured with a low enough gate threshold voltage that it reaches full (or near-full) conduction when driven directly from typical 3.3V or 5V microcontroller logic outputs, unlike standard power MOSFETs that need 10V or more for full enhancement. This avoids the need for a separate gate driver circuit in many hobbyist designs.', 2, 'hard', (select id from public.components where slug = 'mosfet-irlz44n')
from public.quiz_topics t where t.slug = 'mosfets';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What is RDS(on) in a power MOSFET datasheet?', '["The gate threshold voltage", "The drain-source on-state resistance", "The maximum drain current", "The reverse breakdown voltage"]'::jsonb, 1, 'RDS(on) is the resistance between drain and source when the MOSFET is fully turned on, and it directly determines how much power the MOSFET dissipates as heat (P = I^2 x RDS(on)) while conducting current. Lower RDS(on) values mean less heat generation for a given current.', 3, 'hard', (select id from public.components where slug = 'mosfet-irf540n')
from public.quiz_topics t where t.slug = 'mosfets';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'Once an SCR is triggered into conduction, how can it be turned off?', '["By removing the gate signal", "By reducing the anode current below the holding current", "By reversing gate polarity", "By increasing anode voltage"]'::jsonb, 1, 'An SCR latches into conduction once triggered and continues conducting regardless of further gate signals; it only turns off once the main anode-to-cathode current falls below the device''s holding current, typically as the AC waveform crosses zero. This latching behavior is fundamentally different from a MOSFET or BJT, which turn off as soon as their control signal is removed.', 1, 'hard', (select id from public.components where slug = 'thyristor-scr')
from public.quiz_topics t where t.slug = 'scrs';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What makes a TRIAC different from an SCR?', '["A TRIAC can conduct current in both directions", "A TRIAC has no gate terminal", "A TRIAC only works with DC", "A TRIAC cannot be triggered"]'::jsonb, 0, 'Unlike an SCR, which only conducts in one direction, a TRIAC is a bidirectional device that can conduct current in either direction once triggered, making it well suited to controlling AC power directly. This bidirectionality is why TRIACs are the standard component in household light dimmers.', 1, 'medium', (select id from public.components where slug = 'bt136-triac')
from public.quiz_topics t where t.slug = 'triacs';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'For an ideal op-amp in negative feedback, what is true about its two input terminals?', '["They draw large input current", "They are at the same voltage (virtual short)", "They must always be grounded", "One input must be higher voltage by design"]'::jsonb, 1, 'An ideal op-amp with negative feedback drives its output so that the voltage difference between its inverting and non-inverting inputs approaches zero, a condition called a virtual short. This assumption, along with near-infinite input impedance, is the basis for analyzing standard op-amp circuits like inverting and non-inverting amplifiers.', 1, 'medium', (select id from public.components where slug = 'lm358-opamp')
from public.quiz_topics t where t.slug = 'operational-amplifiers';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'In an inverting op-amp amplifier, what sets the gain?', '["The supply voltage", "The ratio of feedback resistor to input resistor", "The op-amp''s internal gain alone", "The input capacitance"]'::jsonb, 1, 'The closed-loop gain of an inverting amplifier is set by -Rf/Rin, the ratio of the feedback resistor to the input resistor, largely independent of the op-amp''s own very high open-loop gain. This predictable, resistor-set gain is one of the main reasons op-amps are so widely used.', 2, 'hard', (select id from public.components where slug = 'lm741-opamp')
from public.quiz_topics t where t.slug = 'operational-amplifiers';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What is the main functional difference between a comparator and a standard op-amp used with feedback?', '["A comparator has no output", "A comparator''s output swings fully high or low based on which input is larger", "A comparator only works with AC", "A comparator cannot be built from an op-amp"]'::jsonb, 1, 'A comparator circuit uses an op-amp (or dedicated comparator IC) without negative feedback, so the output saturates fully high or low depending on which input voltage is greater, functioning as a simple analog-to-digital decision element. Adding hysteresis (positive feedback) creates a Schmitt trigger, which resists false triggering from noise near the switching point.', 1, 'hard', NULL
from public.quiz_topics t where t.slug = 'comparator-circuits';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'In astable mode, what does a 555 timer produce?', '["A single output pulse", "A continuous square wave output", "A fixed DC voltage", "A sine wave"]'::jsonb, 1, 'In astable mode, the 555 timer has no stable output state and continuously oscillates between high and low, producing a repeating square wave whose frequency and duty cycle are set by external resistors and a capacitor. This makes it a simple, popular way to generate clock signals, tones, and blinking LED patterns.', 1, 'easy', (select id from public.components where slug = 'ne555-timer')
from public.quiz_topics t where t.slug = '555-timer';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'In monostable mode, how many stable output states does a 555 timer have?', '["Zero", "One", "Two", "Continuously variable"]'::jsonb, 1, 'Monostable mode has exactly one stable state (the default idle output); a trigger pulse causes it to temporarily flip to its other state for a duration set by an external RC network, then automatically return to the stable state. This makes monostable mode useful for generating precisely timed single pulses, such as debouncing a switch.', 2, 'medium', (select id from public.components where slug = 'ne555-timer')
from public.quiz_topics t where t.slug = '555-timer';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What is the output of a NOR gate when both inputs are 0?', '["0", "1", "Undefined", "Depends on supply voltage"]'::jsonb, 1, 'A NOR gate is the inverse of an OR gate: it outputs 1 only when all inputs are 0, and 0 if any input is 1. NOR gates are functionally complete, meaning any logic function can be built using only NOR gates.', 101, 'easy', NULL
from public.quiz_topics t where t.slug = 'digital-logic';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'How many unique input combinations exist for a 3-input logic gate?', '["3", "6", "8", "9"]'::jsonb, 2, 'With 3 binary inputs, the number of unique combinations is 2^3 = 8, since each input can independently be 0 or 1. This is why a 3-input truth table always has exactly 8 rows.', 102, 'medium', NULL
from public.quiz_topics t where t.slug = 'digital-logic';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What is the primary difference between a latch and a flip-flop?', '["A latch is level-triggered while a flip-flop is edge-triggered", "A latch can only store 0 while a flip-flop can store 1", "A flip-flop has no clock input", "A latch requires more transistors than a flip-flop"]'::jsonb, 0, 'A latch changes its output continuously in response to its input whenever its enable signal is active (level-triggered), while a flip-flop only updates its output at a clock edge (edge-triggered), making its timing behavior far more predictable in synchronous digital systems. This distinction is central to reliable clocked digital design.', 1, 'hard', NULL
from public.quiz_topics t where t.slug = 'flip-flops';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What does a D flip-flop do on each active clock edge?', '["Toggles its output regardless of input", "Copies the D input to its Q output", "Resets to zero", "Divides the clock frequency by two"]'::jsonb, 1, 'A D (data) flip-flop simply transfers whatever value is present on its D input to its Q output at the moment of the active clock edge, then holds that value until the next active edge. This makes it the fundamental building block for registers and synchronous memory elements.', 2, 'medium', NULL
from public.quiz_topics t where t.slug = 'flip-flops';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What does a decade counter like the CD4017 count up to before resetting?', '["2", "8", "10", "16"]'::jsonb, 2, 'A decade counter cycles through 10 distinct states (0 through 9) before wrapping back to the start, matching our base-10 number system. The CD4017 implements this as a Johnson counter with 10 decoded sequential outputs.', 1, 'easy', (select id from public.components where slug = 'cd4017-decade-counter')
from public.quiz_topics t where t.slug = 'counters';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What is the difference between a synchronous and an asynchronous (ripple) counter?', '["Synchronous counters have no clock", "All flip-flops in a synchronous counter share the same clock edge", "Asynchronous counters are always faster", "Synchronous counters cannot count past 10"]'::jsonb, 1, 'In a synchronous counter, every flip-flop is clocked simultaneously by the same clock signal, so all outputs change together with minimal propagation delay. In an asynchronous (ripple) counter, each flip-flop''s clock is driven by the previous stage''s output, causing cumulative propagation delay as the count value ripples through the chain.', 2, 'hard', NULL
from public.quiz_topics t where t.slug = 'counters';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What is the main purpose of a shift register like the 74HC595?', '["To store and shift data bit by bit, converting serial data to parallel outputs", "To amplify analog voltages", "To rectify AC to DC", "To generate a clock signal from a crystal"]'::jsonb, 0, 'A shift register such as the 74HC595 receives data serially, one bit per clock pulse, and shifts it through internal flip-flops; a serial-in-parallel-out register can then present all stored bits simultaneously on parallel output pins. This lets a microcontroller expand its limited number of output pins using just a few serial control lines.', 1, 'hard', (select id from public.components where slug = '74hc595-shift-register')
from public.quiz_topics t where t.slug = 'registers';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What does the resolution of an ADC (e.g. 10-bit) determine?', '["The maximum voltage it can measure", "The number of discrete output levels it can represent", "The sampling frequency", "The power consumption only"]'::jsonb, 1, 'An N-bit ADC divides its input voltage range into 2^N discrete levels; a 10-bit ADC therefore has 1024 possible output codes, determining how finely it can distinguish between different input voltages. Higher resolution allows finer measurement precision but does not by itself change the voltage range being measured.', 1, 'medium', NULL
from public.quiz_topics t where t.slug = 'adc-dac';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What is the basic function of a DAC?', '["Converts a digital code into a corresponding analog voltage or current", "Converts analog signals into digital codes", "Amplifies digital signals only", "Filters noise from a digital signal"]'::jsonb, 0, 'A digital-to-analog converter (DAC) takes a digital numeric input and produces a proportional continuous analog voltage or current output, the reverse operation of an ADC. DACs are used anywhere a microcontroller needs to output an analog waveform, such as audio playback or generating control voltages.', 2, 'easy', NULL
from public.quiz_topics t where t.slug = 'adc-dac';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What is ''quantization error'' in an ADC?', '["Noise from the power supply", "The rounding difference between the actual analog value and the nearest representable digital code", "A software bug in the conversion routine", "The delay before conversion starts"]'::jsonb, 2, 'Because an ADC can only represent a continuous analog signal using a finite number of discrete digital codes, there is always a small difference between the true analog value and its nearest digital representation, known as quantization error. This error decreases as resolution (bit depth) increases, since the voltage steps between codes become smaller.', 3, 'hard', NULL
from public.quiz_topics t where t.slug = 'adc-dac';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'Why does a linear voltage regulator like the 7805 become hot under heavy load with a large input-output voltage difference?', '["It short-circuits internally", "It dissipates the excess voltage as heat across its internal pass transistor", "It converts excess voltage into stored energy", "It reduces frequency to compensate"]'::jsonb, 1, 'A linear regulator maintains its fixed output voltage by dropping any excess input voltage across an internal series pass transistor, and that dropped voltage multiplied by the load current is dissipated directly as heat. This is why linear regulators become inefficient (and hot) when there is a large voltage difference between input and output at high current.', 1, 'hard', (select id from public.components where slug = 'lm7805-regulator')
from public.quiz_topics t where t.slug = 'voltage-regulators';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'How does a switching (buck) regulator achieve higher efficiency than a linear regulator?', '["By using a larger heatsink", "By rapidly switching a transistor on and off and storing energy in an inductor", "By converting AC directly without rectification", "By operating only at very low currents"]'::jsonb, 1, 'A switching regulator rapidly turns a transistor on and off, storing energy in an inductor during the on phase and releasing it to the output during the off phase, so the switching element itself dissipates little power compared to the continuously conducting pass transistor in a linear regulator. This switching approach can achieve well over 85-90% efficiency versus a linear regulator''s efficiency, which drops as the input-output voltage gap grows.', 2, 'hard', (select id from public.components where slug = 'lm2596-buck-module')
from public.quiz_topics t where t.slug = 'voltage-regulators';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What is the correct order of stages in a typical linear AC-to-DC power supply?', '["Filter, transformer, rectifier, regulator", "Transformer, rectifier, filter, regulator", "Regulator, rectifier, filter, transformer", "Rectifier, transformer, regulator, filter"]'::jsonb, 1, 'A typical linear supply first uses a transformer to step the AC mains voltage down to a safer level, then a rectifier (often a bridge rectifier) converts it to pulsating DC, a filter capacitor smooths the ripple, and finally a regulator holds the output at a stable fixed voltage. Each stage builds on the previous one to progressively clean up and stabilize the output.', 1, 'hard', NULL
from public.quiz_topics t where t.slug = 'power-supplies';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What is the purpose of the filter capacitor after a rectifier?', '["To block DC entirely", "To smooth the pulsating DC into a steadier voltage by charging and discharging", "To convert DC back to AC", "To increase the output frequency"]'::jsonb, 1, 'The filter (or reservoir) capacitor charges up near the peak of each rectified pulse and then discharges slowly into the load as the rectified waveform dips, smoothing out the ripple and producing a much steadier DC voltage. Larger capacitance and higher load current both affect how much ripple remains after filtering.', 2, 'easy', (select id from public.components where slug = 'electrolytic-capacitor')
from public.quiz_topics t where t.slug = 'power-supplies';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'A step-down transformer with a turns ratio of 10:1 receives 230V AC on its primary. What is the approximate secondary voltage?', '["2300V", "23V", "230V", "2.3V"]'::jsonb, 1, 'The voltage ratio between primary and secondary matches the turns ratio: Vsecondary = Vprimary / (turns ratio) = 230V / 10 = 23V. This relationship (Vp/Vs = Np/Ns) is the fundamental transformer equation based on mutual induction.', 1, 'hard', NULL
from public.quiz_topics t where t.slug = 'transformers';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'Why do transformers only work with AC, not DC?', '["DC damages the copper windings", "A changing magnetic flux is required to induce voltage in the secondary winding", "DC voltage is always too low", "Transformers contain semiconductors that block DC"]'::jsonb, 1, 'Transformers operate through electromagnetic induction, where a changing current in the primary winding creates a changing magnetic flux that induces a voltage in the secondary winding; a steady DC current produces a constant, non-changing flux, so no voltage is induced in the secondary. This is why transformers require alternating (or otherwise time-varying) current to function.', 2, 'hard', NULL
from public.quiz_topics t where t.slug = 'transformers';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What two conditions must be satisfied for a feedback circuit to sustain oscillation (Barkhausen criteria)?', '["Loop gain of exactly zero and any phase shift", "Loop gain of at least 1 and total phase shift of 0 or 360 degrees", "Infinite gain and 90 degree phase shift", "Negative gain and no feedback"]'::jsonb, 1, 'The Barkhausen stability criteria require that the loop gain around the feedback path be at least unity (1) and that the total phase shift around the loop be 0 degrees (or a multiple of 360 degrees) at the oscillation frequency, so that the fed-back signal reinforces rather than cancels itself. If either condition fails, the oscillation will die out or fail to start.', 1, 'hard', NULL
from public.quiz_topics t where t.slug = 'oscillators';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'Which component provides much better frequency stability in an oscillator than a simple RC network?', '["A carbon resistor", "A quartz crystal", "An electrolytic capacitor", "A silicon diode"]'::jsonb, 1, 'A quartz crystal''s mechanical resonance is extremely stable and far less sensitive to temperature and component tolerance variation than a simple resistor-capacitor timing network, making crystal oscillators the standard choice whenever accurate, stable timing is required. RC oscillators are cheaper and simpler but drift more with temperature and voltage.', 2, 'medium', (select id from public.components where slug = '16mhz-quartz-crystal')
from public.quiz_topics t where t.slug = 'oscillators';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What physical effect allows a quartz crystal to be used as a frequency reference?', '["Photoelectric effect", "Piezoelectric effect", "Thermoelectric effect", "Hall effect"]'::jsonb, 1, 'Quartz exhibits the piezoelectric effect, mechanically deforming when an electric field is applied and generating a voltage when mechanically stressed; this property lets an external amplifier circuit sustain a highly stable oscillation at the crystal''s natural mechanical resonant frequency. The same effect is used in reverse in piezoelectric sensors and buzzers.', 1, 'medium', (select id from public.components where slug = '16mhz-quartz-crystal')
from public.quiz_topics t where t.slug = 'crystals';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What is the purpose of a ground plane on a PCB?', '["To decorate the board", "To provide a low-impedance return path and reduce noise", "To increase board weight", "To block all signals"]'::jsonb, 1, 'A ground plane is a large continuous copper area dedicated to the ground (return) connection, giving current a low-impedance, low-inductance path back to its source, which reduces noise, EMI, and voltage drops compared to routing ground as a thin trace. It also helps shield signal layers from interference in multilayer boards.', 1, 'medium', NULL
from public.quiz_topics t where t.slug = 'pcb-design';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'Why are wider copper traces used for high-current paths on a PCB?', '["Wider traces look more professional", "Wider traces have lower resistance and can carry more current without excessive heating", "Wider traces reduce component cost", "Wider traces increase signal speed"]'::jsonb, 1, 'Trace resistance is inversely related to its cross-sectional area, so a wider (or thicker copper) trace has lower resistance and can carry more current for a given temperature rise. PCB designers use trace-width calculators based on IPC-2152 or similar standards to size traces appropriately for expected current.', 2, 'medium', NULL
from public.quiz_topics t where t.slug = 'pcb-design';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What is a common sign of a ''cold'' solder joint?', '["A shiny, smooth, cone-shaped joint", "A dull, grainy, or cracked appearance with poor mechanical bond", "A joint that conducts electricity better than normal", "A joint that is too shiny"]'::jsonb, 1, 'A cold solder joint forms when the solder does not reach proper temperature or the joint moves before solidifying, resulting in a dull, grainy, or cracked surface with weak mechanical and electrical connection. A good joint should look smooth, shiny, and properly wetted to both the component lead and the pad.', 1, 'easy', NULL
from public.quiz_topics t where t.slug = 'soldering';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What does GPIO stand for on a microcontroller?', '["General Power Input Output", "General Purpose Input/Output", "Gated Pulse Interrupt Operation", "Ground Pin Input Output"]'::jsonb, 1, 'GPIO stands for General Purpose Input/Output, referring to microcontroller pins whose function (digital input, digital output, or sometimes analog/special function) can be configured in software rather than being fixed at manufacture. This flexibility is what lets the same microcontroller pin drive an LED in one project and read a button in another.', 101, 'easy', NULL
from public.quiz_topics t where t.slug = 'microcontrollers';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What is the purpose of an interrupt in embedded systems?', '["To permanently stop the microcontroller", "To let an event immediately pause the main program and run a dedicated handler routine", "To slow down the clock speed", "To reset all peripherals"]'::jsonb, 1, 'An interrupt lets a hardware or software event (like a pin changing state or a timer expiring) immediately suspend the currently running code so a dedicated interrupt service routine can respond, after which execution resumes where it left off. This allows a microcontroller to respond quickly to time-critical events without constantly polling every possible input in the main loop.', 102, 'medium', NULL
from public.quiz_topics t where t.slug = 'microcontrollers';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What two functions must every Arduino sketch contain?', '["main() and loop()", "setup() and loop()", "start() and run()", "init() and execute()"]'::jsonb, 1, 'Every Arduino sketch requires a setup() function, which runs once at startup for initialization, and a loop() function, which runs repeatedly afterward to carry out the program''s ongoing behavior. This structure is handled automatically by the Arduino core, which calls both functions from a hidden main() behind the scenes.', 1, 'easy', (select id from public.components where slug = 'arduino-uno-r3')
from public.quiz_topics t where t.slug = 'arduino';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What does the Arduino function analogWrite() actually output on most Uno-compatible pins?', '["A true analog voltage", "A PWM (pulse-width modulated) square wave", "A fixed 5V signal", "A digital-only 0V or 5V with no variation"]'::jsonb, 1, 'On classic AVR-based Arduino boards, analogWrite() does not produce a true variable analog voltage; instead it generates a PWM square wave whose duty cycle approximates the requested analog level, which external filtering or the natural averaging behavior of an LED or motor can interpret as a proportional analog effect. True analog output requires a DAC-equipped board or an external DAC IC.', 2, 'hard', (select id from public.components where slug = 'arduino-uno-r3')
from public.quiz_topics t where t.slug = 'arduino';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What two wireless technologies does the ESP32 integrate on-chip?', '["Wi-Fi and Bluetooth", "LoRa and Zigbee", "GSM and GPS", "Only Wi-Fi"]'::jsonb, 0, 'The ESP32 integrates both Wi-Fi (802.11 b/g/n) and Bluetooth (Classic and BLE) radios on a single chip, letting it connect to wireless networks and Bluetooth devices without requiring a separate radio module. This dual-radio integration is a major reason for its popularity in IoT projects.', 1, 'easy', (select id from public.components where slug = 'esp32-wroom32')
from public.quiz_topics t where t.slug = 'esp32';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'Why is the ESP32 considered more powerful than the ESP8266 for real-time tasks?', '["It runs at a lower clock speed", "It has two CPU cores that can run tasks independently", "It has no wireless radio, freeing up CPU time", "It uses less flash memory"]'::jsonb, 1, 'The ESP32 has two Xtensa CPU cores, so one core can be dedicated to time-sensitive application tasks while the other handles Wi-Fi/Bluetooth networking overhead, reducing the chance that wireless activity disrupts real-time code execution. The single-core ESP8266 must share all tasks, including networking, on one core.', 2, 'medium', (select id from public.components where slug = 'esp32-wroom32')
from public.quiz_topics t where t.slug = 'esp32';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'How many true analog input pins does a typical bare ESP8266 chip provide?', '["Eight", "Six", "One", "Zero"]'::jsonb, 2, 'The ESP8266 has only a single analog input pin (ADC), unlike many other microcontrollers that offer several. Boards like the NodeMCU further limit this through an onboard voltage divider, restricting the usable analog input range to roughly 0-3.3V or sometimes 0-1V depending on the board revision.', 1, 'medium', (select id from public.components where slug = 'esp8266-esp12f')
from public.quiz_topics t where t.slug = 'esp8266';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What is unique about the RP2040 chip used in the Raspberry Pi Pico?', '["It has no CPU cores", "It includes Programmable I/O (PIO) blocks that can generate custom digital protocols independent of the CPU", "It only supports analog signals", "It cannot be programmed in C or MicroPython"]'::jsonb, 1, 'The RP2040''s Programmable I/O (PIO) subsystem consists of small, independent state machines that can be programmed to generate or receive precisely timed digital signals, offloading tasks like bit-banging custom protocols from the main CPU cores entirely. This is a distinctive feature not found in most competing microcontrollers.', 1, 'hard', (select id from public.components where slug = 'raspberry-pi-pico')
from public.quiz_topics t where t.slug = 'raspberry-pi-pico';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What CPU architecture do STM32 microcontrollers like the STM32F103 use?', '["8-bit AVR", "32-bit ARM Cortex-M", "16-bit PIC", "64-bit x86"]'::jsonb, 1, 'STM32 microcontrollers are built around ARM''s Cortex-M series of 32-bit processor cores (such as the Cortex-M3 in the STM32F103), which provide significantly more processing power and peripheral capability than typical 8-bit microcontrollers like the AVR family. This makes STM32 chips popular for more demanding embedded applications.', 1, 'medium', (select id from public.components where slug = 'stm32f103c8t6')
from public.quiz_topics t where t.slug = 'stm32';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What is the difference between an analog and a digital sensor output?', '["Analog output varies continuously, digital output represents discrete states or values", "Digital sensors do not require power", "Analog sensors cannot be read by a microcontroller", "There is no functional difference"]'::jsonb, 0, 'An analog sensor produces a continuously varying voltage or current proportional to the measured quantity, requiring an ADC to interpret, while a digital sensor outputs discrete logic levels or a coded data stream that a microcontroller can read directly. The choice affects both wiring complexity and the interface code needed.', 1, 'medium', NULL
from public.quiz_topics t where t.slug = 'sensors';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What does ''sensor calibration'' generally involve?', '["Replacing the sensor entirely", "Comparing sensor output against a known reference and adjusting for accuracy", "Increasing the sensor''s supply voltage", "Disconnecting the sensor from the circuit"]'::jsonb, 1, 'Calibration involves comparing a sensor''s output readings against a known, trusted reference measurement and then applying correction factors (offset, scale, or a lookup table) so the sensor''s reported values match reality as closely as possible. Without calibration, manufacturing variation between individual sensor units can lead to systematic measurement errors.', 2, 'medium', NULL
from public.quiz_topics t where t.slug = 'sensors';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'How does the HC-SR04 ultrasonic sensor measure distance?', '["By measuring the current drawn by a reflected object", "By timing how long it takes an emitted ultrasonic pulse to echo back", "By measuring light reflectance", "By measuring magnetic field changes"]'::jsonb, 1, 'The HC-SR04 emits a burst of 40kHz ultrasonic sound and measures the time delay before the echo returns; combined with the known speed of sound, this time-of-flight measurement is converted into a distance value. The TRIG pin starts a measurement and the ECHO pin outputs a pulse whose width represents that travel time.', 1, 'medium', (select id from public.components where slug = 'hc-sr04-sensor')
from public.quiz_topics t where t.slug = 'hc-sr04';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What two environmental quantities does a DHT11 sensor measure?', '["Pressure and altitude", "Temperature and humidity", "Light and sound", "Voltage and current"]'::jsonb, 1, 'The DHT11 combines a resistive humidity sensing element and a basic thermistor to report both relative humidity and temperature over a simple single-wire digital protocol. It is a lower-cost, lower-precision alternative to sensors like the DHT22, with a narrower measurement range and update rate.', 1, 'easy', NULL
from public.quiz_topics t where t.slug = 'dht11';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'Why does the DHT11 use only a single digital data pin rather than an analog output?', '["It has no internal processing capability", "An internal chip digitizes and transmits both readings as timed digital pulses", "It cannot measure temperature accurately otherwise", "It requires no power to operate"]'::jsonb, 1, 'Like the DHT22, the DHT11 includes a small internal controller that samples its sensing elements and encodes both the temperature and humidity readings into a single timed serial digital protocol, avoiding the need for a separate ADC channel per measurement. This simplifies wiring to just one data line plus power and ground.', 2, 'medium', NULL
from public.quiz_topics t where t.slug = 'dht11';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What two types of motion sensing does the MPU6050 combine?', '["Accelerometer and gyroscope", "Accelerometer and magnetometer only", "Barometer and thermometer", "GPS and compass"]'::jsonb, 0, 'The MPU6050 integrates a 3-axis MEMS accelerometer (sensing linear acceleration) and a 3-axis MEMS gyroscope (sensing rotational rate) on one chip, giving six degrees of motion data over a simple I2C interface. Some other IMUs add a magnetometer for a ninth axis, but the base MPU6050 does not include one.', 1, 'medium', (select id from public.components where slug = 'mpu6050-sensor')
from public.quiz_topics t where t.slug = 'mpu6050';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'How does a passive RFID tag receive the power it needs to respond to a reader?', '["From an internal battery", "By harvesting energy from the reader''s electromagnetic field", "From a USB cable", "From solar cells built into the tag"]'::jsonb, 1, 'A passive RFID tag has no battery; instead, it draws its operating power by harvesting energy from the electromagnetic field generated by the RFID reader, then uses that power to modulate the field and transmit its stored data back. This is why passive tags only work within a short range of an active reader.', 1, 'medium', (select id from public.components where slug = 'rc522-rfid-module')
from public.quiz_topics t where t.slug = 'rfid';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'How does a GPS receiver determine its position?', '["By measuring signal strength from a single satellite", "By calculating its distance from multiple satellites using precise timing signals (trilateration)", "By connecting to a cellular tower", "By measuring local magnetic field variations"]'::jsonb, 1, 'A GPS receiver calculates its distance to each visible satellite by measuring how long the satellite''s radio signal took to arrive, then uses trilateration across signals from at least four satellites to compute a precise 3D position and time. More visible satellites generally improve positional accuracy.', 1, 'hard', NULL
from public.quiz_topics t where t.slug = 'gps';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What does a module like the SIM800L primarily add to an embedded project?', '["Local Wi-Fi networking only", "Cellular connectivity for SMS, voice calls, and mobile data", "Bluetooth pairing", "GPS positioning only"]'::jsonb, 1, 'GSM modules like the SIM800L provide access to the cellular network, letting an embedded project send and receive SMS messages, place voice calls, and access mobile data (GPRS), all controlled by the host microcontroller via simple AT commands over UART. This is especially valuable in remote locations without Wi-Fi coverage.', 1, 'medium', (select id from public.components where slug = 'sim800l-module')
from public.quiz_topics t where t.slug = 'gsm';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What Bluetooth profile does the HC-05 module use to act as a transparent wireless serial link?', '["Serial Port Profile (SPP)", "Hands-Free Profile (HFP)", "Audio/Video Remote Control Profile (AVRCP)", "Object Push Profile (OPP)"]'::jsonb, 0, 'The HC-05 implements the Serial Port Profile (SPP), which emulates a standard wired serial connection over Bluetooth so any UART-based application can send and receive data wirelessly with no protocol changes needed on the microcontroller side. This is what lets it work seamlessly with existing serial terminal software on phones and PCs.', 1, 'medium', (select id from public.components where slug = 'hc-05-bluetooth')
from public.quiz_topics t where t.slug = 'bluetooth';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What IEEE standard family defines Wi-Fi wireless networking?', '["802.3", "802.11", "802.15.4", "802.1Q"]'::jsonb, 1, 'Wi-Fi is defined by the IEEE 802.11 family of standards (802.11b, g, n, ac, ax, etc.), which specify how devices communicate wirelessly on the 2.4GHz and 5GHz bands. In contrast, 802.3 defines wired Ethernet, and 802.15.4 underlies low-power wireless standards like Zigbee.', 1, 'easy', NULL
from public.quiz_topics t where t.slug = 'wifi';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What technique gives LoRa its exceptionally long communication range compared to Wi-Fi or Bluetooth?', '["Extremely high transmit power only", "Chirp spread-spectrum modulation that trades data rate for receiver sensitivity", "Using visible light instead of radio waves", "A direct satellite uplink"]'::jsonb, 1, 'LoRa uses chirp spread-spectrum modulation, spreading a signal''s energy across a wide bandwidth so it can be recovered by a receiver even when far below the noise floor, at the cost of a much lower data rate than conventional narrowband radios. This tradeoff is what allows LoRa links to reach kilometers on very low transmit power.', 1, 'hard', (select id from public.components where slug = 'sx1278-lora-module')
from public.quiz_topics t where t.slug = 'lora';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'Why do OLED displays achieve much higher contrast than backlit LCDs?', '["OLED pixels always stay fully lit", "Each OLED pixel emits its own light and can turn fully off, producing true black", "OLED displays use a brighter backlight", "OLED pixels are larger than LCD pixels"]'::jsonb, 1, 'Because each pixel in an OLED display is an individually addressable organic LED that emits its own light, a pixel that is turned off emits no light at all, producing a true black rather than a backlight leaking through a closed liquid crystal shutter as in an LCD. This gives OLEDs their characteristically high contrast ratio.', 1, 'medium', (select id from public.components where slug = 'ssd1306-oled')
from public.quiz_topics t where t.slug = 'oled-displays';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What interface does the common SSD1306 OLED module typically use to communicate with a microcontroller?', '["Only USB", "I2C or SPI", "Bluetooth", "Analog PWM only"]'::jsonb, 1, 'The SSD1306 driver IC supports either I2C (using just two data lines, SDA and SCL) or SPI (faster but using more pins), giving designers flexibility to trade off wiring simplicity against update speed. I2C is more common in hobbyist projects because of its minimal pin count.', 2, 'easy', (select id from public.components where slug = 'ssd1306-oled')
from public.quiz_topics t where t.slug = 'oled-displays';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What controller chip is most commonly associated with basic 16x2 character LCDs?', '["SSD1306", "HD44780", "ILI9341", "PCD8544"]'::jsonb, 1, 'The HD44780 (or a pin-compatible clone) has become the near-universal controller for simple character LCDs like the 16x2 display, standardizing the command set and interface that countless libraries and tutorials are built around. The SSD1306, ILI9341, and PCD8544 are controllers used for different display technologies (OLED, color TFT, and Nokia-style graphic LCD respectively).', 1, 'easy', (select id from public.components where slug = 'lcd-16x2-hd44780')
from public.quiz_topics t where t.slug = 'lcd-displays';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What determines the commanded angle of a standard hobby servo like the SG90?', '["The supply voltage level", "The width of a periodic PWM pulse, typically 1-2ms within a 20ms period", "The servo''s internal temperature", "The direction current flows through two wires"]'::jsonb, 1, 'A standard hobby servo interprets the width of a repeating pulse (commonly 1ms to 2ms within a 20ms/50Hz period) as a target shaft angle, using an internal potentiometer and control loop to drive the motor until the actual position matches that commanded angle. This differs fundamentally from a simple DC motor, which just spins continuously based on applied voltage polarity and magnitude.', 1, 'medium', (select id from public.components where slug = 'sg90-servo')
from public.quiz_topics t where t.slug = 'servo-motors';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'Why can a standard hobby servo hold a fixed position under load, unlike a plain DC motor?', '["It uses a much larger battery", "It contains an internal closed-loop feedback system that continuously corrects position", "It has no gears", "It spins freely at all times"]'::jsonb, 1, 'Inside a hobby servo, a potentiometer continuously reports the actual shaft position back to an internal control circuit, which compares it against the commanded position and drives the motor to correct any error, creating closed-loop position holding. A plain DC motor has no such internal feedback and will simply keep spinning or coast to a stop rather than holding a specific angle.', 2, 'hard', (select id from public.components where slug = 'sg90-servo')
from public.quiz_topics t where t.slug = 'servo-motors';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What is the main advantage of a stepper motor over a standard DC motor for CNC or 3D printer axes?', '["Steppers are always faster", "Steppers can achieve precise, repeatable open-loop position control without an encoder", "Steppers require no driver circuitry", "Steppers consume no power when moving"]'::jsonb, 1, 'A stepper motor moves in discrete, known angular steps for each control pulse, so a controller can track position simply by counting pulses sent, without needing an external position sensor (open-loop control). This precise, predictable positioning is exactly what makes steppers so popular in 3D printers and CNC machines.', 1, 'medium', (select id from public.components where slug = '28byj48-stepper')
from public.quiz_topics t where t.slug = 'stepper-motors';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What can happen if a stepper motor is driven beyond its available torque (e.g. by excessive load or acceleration)?', '["It automatically speeds up to compensate", "It can lose steps, causing the tracked position to no longer match the actual position", "It reverses direction automatically", "It converts to a DC motor"]'::jsonb, 1, 'If the load torque or required acceleration exceeds what the stepper motor can physically provide, the rotor can fail to keep up with the commanded step sequence and ''lose steps'', silently causing a permanent mismatch between the controller''s assumed position and the real physical position. This is a key limitation of open-loop stepper control compared to closed-loop servo systems.', 2, 'hard', (select id from public.components where slug = '28byj48-stepper')
from public.quiz_topics t where t.slug = 'stepper-motors';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What determines the rotation direction of a brushed DC motor?', '["The motor''s temperature", "The polarity of the applied voltage", "The motor''s physical size", "The ambient light level"]'::jsonb, 1, 'Reversing the polarity of the voltage applied across a brushed DC motor''s two terminals reverses the direction of current through its windings, which reverses the resulting torque direction and therefore the motor''s rotation. This is why H-bridge driver circuits are used to control direction by switching polarity electronically.', 1, 'easy', (select id from public.components where slug = 'dc-motor')
from public.quiz_topics t where t.slug = 'dc-motors';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What is the basic function of an H-bridge circuit like the one inside an L298N?', '["To convert AC to DC", "To allow a DC motor''s direction and speed to be controlled electronically", "To measure motor current only", "To generate a clock signal"]'::jsonb, 1, 'An H-bridge arranges four switching elements so that reversing which diagonal pair conducts reverses the current direction through the motor, enabling forward, reverse, and often braking control from simple logic-level inputs. Combined with a PWM signal on the enable line, it also allows variable speed control by adjusting the average voltage delivered to the motor.', 1, 'medium', (select id from public.components where slug = 'l298n-driver')
from public.quiz_topics t where t.slug = 'motor-drivers';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'Why can''t a microcontroller GPIO pin typically drive a DC motor directly?', '["GPIO pins cannot output any current at all", "GPIO pins can only source a few tens of milliamps, far less than most motors require", "Motors only work with AC", "GPIO pins are always at 0V"]'::jsonb, 1, 'Microcontroller GPIO pins are designed for low-current logic signaling, typically only able to source or sink a few tens of milliamps, while even small DC motors often draw hundreds of milliamps to several amps under load, well beyond what the pin (or the chip) can safely handle. A driver circuit like a transistor, MOSFET, or dedicated motor driver IC is needed to supply the higher current from a separate power source while being controlled by the low-current GPIO signal.', 2, 'medium', (select id from public.components where slug = 'l298n-driver')
from public.quiz_topics t where t.slug = 'motor-drivers';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What provides electrical isolation between the control side and the switched side of an electromechanical relay?', '["A shared ground wire", "The physical air gap between the coil-driven contacts and the control circuit", "A capacitor", "A voltage regulator"]'::jsonb, 1, 'An electromechanical relay uses a coil to magnetically pull a mechanical armature that opens or closes a physically separate set of contacts, so the control circuit (coil) and the switched circuit (contacts) have no direct electrical connection between them. This isolation is what allows a low-voltage microcontroller signal to safely control a completely separate high-voltage or high-current circuit.', 1, 'medium', (select id from public.components where slug = '5v-relay-module')
from public.quiz_topics t where t.slug = 'relay-modules';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What are the only two values a signal can take in an ideal digital logic system?', '["0 and 5", "High (1) and Low (0)", "Positive and negative infinity", "Any value between 0V and the supply voltage"]'::jsonb, 1, 'Digital logic systems represent information using only two discrete states, conventionally labeled High (logic 1) and Low (logic 0), regardless of the exact voltage thresholds a specific logic family uses to distinguish them. This binary nature is what makes digital circuits far more noise-tolerant than analog circuits, since small voltage variations do not change the interpreted logic value.', 1, 'easy', NULL
from public.quiz_topics t where t.slug = 'digital-electronics';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What does ''noise margin'' refer to in digital logic circuits?', '["The audible noise a chip produces", "The amount a signal can deviate from ideal voltage levels while still being reliably interpreted as the correct logic state", "The maximum clock frequency", "The number of gates on a chip"]'::jsonb, 2, 'Noise margin is the voltage range by which a digital signal can be corrupted by noise or interference while still being correctly interpreted by the receiving logic gate as the intended high or low state. Larger noise margins make a digital system more robust against electrical interference in real-world environments.', 2, 'hard', NULL
from public.quiz_topics t where t.slug = 'digital-electronics';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What fundamentally distinguishes an analog signal from a digital one?', '["Analog signals can only be 0 or 1", "An analog signal can take any continuous value within a range, representing information directly in its amplitude or timing", "Analog signals are always AC", "Analog signals cannot be amplified"]'::jsonb, 1, 'An analog signal varies continuously and can take on any value within its range, with information encoded directly in that continuously varying amplitude, frequency, or phase, unlike a digital signal which is quantized into a fixed set of discrete states. This continuous nature makes analog circuits more susceptible to noise but also allows them to represent real-world physical quantities, like sound or temperature, without quantization error.', 1, 'medium', NULL
from public.quiz_topics t where t.slug = 'analog-electronics';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What does ''IoT'' (Internet of Things) generally describe?', '["A single specific microcontroller model", "Everyday physical devices connected to a network so they can collect and exchange data", "A programming language", "A type of battery chemistry"]'::jsonb, 1, 'IoT describes the broad concept of embedding network connectivity, sensors, and often cloud integration into everyday physical devices and objects, letting them collect, transmit, and sometimes act on data over the internet or local networks. Common IoT building blocks include Wi-Fi/Bluetooth-capable microcontrollers like the ESP32, sensors, and cloud dashboards or MQTT brokers.', 1, 'easy', NULL
from public.quiz_topics t where t.slug = 'iot';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'Why is MQTT a popular protocol choice for many IoT devices?', '["It requires no network connection at all", "It is a lightweight publish-subscribe protocol well suited to devices with limited bandwidth and power", "It only works over Bluetooth", "It replaces the need for any microcontroller"]'::jsonb, 1, 'MQTT is a lightweight publish-subscribe messaging protocol designed for constrained devices and unreliable or low-bandwidth networks, letting many small IoT devices efficiently send updates to (and receive commands from) a central broker without maintaining constant heavyweight connections. Its small message overhead makes it far more efficient for battery-powered sensor nodes than protocols like plain HTTP polling.', 2, 'hard', NULL
from public.quiz_topics t where t.slug = 'iot';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What must a multimeter be configured to do before measuring current in a live circuit?', '["Set to voltage mode and touch the probes anywhere", "Set to current mode and connect in series with the circuit, breaking the path to insert the meter", "Set to resistance mode with the circuit powered on", "No configuration is needed, current can always be measured in parallel"]'::jsonb, 1, 'To measure current, a multimeter must be set to its current (ammeter) mode and connected in series with the circuit, meaning the circuit path is physically broken and routed through the meter, since current measurement requires the same current that flows through the circuit to also flow through the meter. This is different from voltage measurement, where the meter is connected in parallel across the two points being measured.', 1, 'medium', NULL
from public.quiz_topics t where t.slug = 'electronic-measurements';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'What does an oscilloscope primarily display?', '["A single numeric voltage reading", "A graph of voltage versus time, revealing waveform shape and timing", "Only resistance values", "Only current in amperes"]'::jsonb, 1, 'An oscilloscope plots a signal''s voltage on the vertical axis against time on the horizontal axis, letting engineers visualize waveform shape, frequency, amplitude, timing relationships, and transient events that a simple multimeter''s single numeric reading cannot reveal. This makes it essential for debugging timing-sensitive digital and analog circuits.', 2, 'easy', NULL
from public.quiz_topics t where t.slug = 'electronic-measurements';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'Why should you avoid working on a live (powered) circuit whenever possible?', '["Live circuits work faster", "It eliminates the risk of electric shock and accidental short circuits that could damage equipment or cause injury", "Powered circuits produce louder noise", "It has no real benefit"]'::jsonb, 1, 'Working on a de-energized circuit removes the risk of electric shock, and it also prevents accidental short circuits from a dropped tool or misplaced probe that could damage components, start a fire, or injure the person working on it. When testing must be done live, appropriate precautions like insulated tools and careful probe placement are essential.', 1, 'easy', NULL
from public.quiz_topics t where t.slug = 'safety';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'Why should electrolytic capacitors in a power supply be discharged before servicing the circuit, even after power is switched off?', '["They automatically discharge instantly", "They can retain a dangerous stored charge for some time after power is removed", "They generate their own new charge continuously", "There is no risk, capacitors are always safe"]'::jsonb, 1, 'Electrolytic capacitors, especially large ones in power supply filter stages, can retain a significant stored charge well after the circuit is powered down, and touching their terminals (or a connected node) can deliver an unexpected and potentially dangerous shock. Technicians typically use a bleeder resistor or a proper discharge tool to safely drain stored charge before servicing such circuits.', 2, 'medium', (select id from public.components where slug = 'electrolytic-capacitor')
from public.quiz_topics t where t.slug = 'safety';

insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index, difficulty, component_id)
select t.id, 'According to the Nyquist-Shannon sampling theorem, at what minimum rate must a signal be sampled to be accurately reconstructed?', '["Exactly equal to the signal''s highest frequency component", "At least twice the signal''s highest frequency component", "Half the signal''s highest frequency component", "At any rate, frequency does not matter"]'::jsonb, 1, 'The Nyquist-Shannon sampling theorem states that a continuous signal must be sampled at a rate of at least twice its highest frequency component (the Nyquist rate) to be accurately reconstructed without aliasing. Sampling below this rate causes higher frequencies to be misrepresented as lower ones, an artifact known as aliasing.', 4, 'hard', NULL
from public.quiz_topics t where t.slug = 'adc-dac';
