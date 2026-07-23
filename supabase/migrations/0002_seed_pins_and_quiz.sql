-- Pin diagram seed data for the ESP32 (positions are % of image width/height,
-- tuned to sit over public/comp-esp32.png - adjust to taste in the dashboard later).
insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, '3V3', 'Output of the onboard 3.3V regulator.', 10, 8, 'power'),
    (2, 'EN', 'Chip enable, active high. Pull low to reset.', 10, 20, 'special'),
    (3, 'GPIO36', 'Input-only ADC pin.', 10, 32, 'analog'),
    (4, 'GPIO39', 'Input-only ADC pin.', 10, 44, 'analog'),
    (5, 'GND', 'Ground reference.', 10, 92, 'ground'),
    (6, 'GPIO23', 'General purpose I/O, supports PWM.', 90, 8, 'io'),
    (7, 'GPIO22', 'General purpose I/O, commonly used for I2C SCL.', 90, 20, 'io'),
    (8, 'GPIO21', 'General purpose I/O, commonly used for I2C SDA.', 90, 32, 'io'),
    (9, 'TX0', 'UART0 transmit.', 90, 44, 'special'),
    (10, 'RX0', 'UART0 receive.', 90, 56, 'special')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'esp32'
on conflict (component_id, pin_number) do nothing;

-- Quiz questions for Ohm's Law
insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index)
select t.id, q.question, q.options::jsonb, q.correct_index, q.explanation, q.order_index
from public.quiz_topics t
cross join lateral (
  values
    ('What does Ohm''s law state?',
      '["V = I x R", "V = I / R", "V = I + R", "V = I - R"]', 0,
      'Ohm''s law: Voltage equals Current multiplied by Resistance.', 1),
    ('If a circuit has 12V and 4 ohms of resistance, what is the current?',
      '["3A", "48A", "8A", "0.33A"]', 0,
      'I = V / R = 12 / 4 = 3A.', 2),
    ('Increasing resistance while voltage stays constant will...',
      '["Decrease current", "Increase current", "Have no effect", "Increase voltage"]', 0,
      'Since I = V / R, a larger R produces a smaller I for the same V.', 3),
    ('What unit is resistance measured in?',
      '["Ohms", "Volts", "Amps", "Watts"]', 0,
      'Resistance is measured in ohms, symbol Ω.', 4)
) as q(question, options, correct_index, explanation, order_index)
where t.slug = 'ohms-law';

-- Quiz questions for Digital Logic
insert into public.quiz_questions (topic_id, question, options, correct_index, explanation, order_index)
select t.id, q.question, q.options::jsonb, q.correct_index, q.explanation, q.order_index
from public.quiz_topics t
cross join lateral (
  values
    ('An AND gate outputs 1 when...',
      '["Both inputs are 1", "Either input is 1", "Both inputs are 0", "Inputs differ"]', 0,
      'AND requires all inputs to be true (1) to output true.', 1),
    ('An XOR gate outputs 1 when...',
      '["Inputs differ", "Inputs are the same", "Both are 0", "Both are 1"]', 0,
      'XOR (exclusive OR) is true only when inputs differ.', 2),
    ('What does a NOT gate do?',
      '["Inverts the input", "Passes the input unchanged", "ANDs two inputs", "Always outputs 1"]', 0,
      'A NOT gate is an inverter: 0 becomes 1, and 1 becomes 0.', 3)
) as q(question, options, correct_index, explanation, order_index)
where t.slug = 'digital-logic';
