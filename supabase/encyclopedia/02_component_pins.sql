-- ============================================================================
-- Voltra Electronics Encyclopedia -- 02_component_pins.sql
-- Realistic pin mappings for ICs, modules, and microcontroller / dev boards.
-- x/y are approximate percentage overlay positions (0-100) split evenly down
-- the left and right edges of the component's pin-diagram image; re-tune in
-- the dashboard once real pinout photos/diagrams are uploaded per component.
-- Run AFTER 01_update_components.sql.
-- ============================================================================

delete from public.component_pins
where component_id in (select id from public.components where slug in (

  'ws2812b-led',
  'darlington-transistor-tip120',
  'mosfet-irf540n',
  'mosfet-irf9540',
  'mosfet-irlz44n',
  'lm7805-regulator',
  'lm317-regulator',
  'ams1117-regulator',
  'lm2596-buck-module',
  'lm358-opamp',
  'lm741-opamp',
  '74hc595-shift-register',
  '74hc00-nand-gate',
  'cd4017-decade-counter',
  'cd4051-multiplexer',
  'ne555-timer',
  'ne556-dual-timer',
  'atmega328p',
  'esp32-wroom32',
  'esp8266-esp12f',
  'stm32f103c8t6',
  'pic16f877a',
  'arduino-uno-r3',
  'raspberry-pi-4',
  'raspberry-pi-pico',
  'dht22-sensor',
  'hc-sr04-sensor',
  'pir-hcsr501-sensor',
  'mpu6050-sensor',
  'bmp280-sensor',
  'soil-moisture-sensor',
  'mq2-gas-sensor',
  'hc-05-bluetooth',
  'nrf24l01-module',
  'sim800l-module',
  'rc522-rfid-module',
  'sx1278-lora-module',
  'lcd-16x2-hd44780',
  'ssd1306-oled',
  '7-segment-display',
  'ili9341-tft',
  'nokia5110-lcd',
  '5v-relay-module',
  'solid-state-relay',
  '28byj48-stepper',
  'sg90-servo',
  'l298n-driver',
  'a4988-stepper-driver',
  'drv8825-stepper-driver',
  'bridge-rectifier',
  'bt136-triac',
  'thyristor-scr',
  'igbt',
  'crystal-oscillator-can',
  '16mhz-quartz-crystal',
  '32768hz-watch-crystal'
));

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'DIN', 'Data input from controller or previous LED', 10, 8, 'special'),
    (2, 'DOUT', 'Data output to next LED in chain', 10, 92, 'special'),
    (3, 'VDD', 'Power supply, 3.5-5.3V', 90, 8, 'power'),
    (4, 'VSS', 'Ground', 90, 92, 'ground')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'ws2812b-led'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'Base', 'Control input, small current turns transistor on', 10, 8, 'io'),
    (2, 'Collector', 'Connects to the load / positive supply side', 10, 92, 'power'),
    (3, 'Emitter', 'Connects to ground / return path', 90, 50, 'ground')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'darlington-transistor-tip120'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'Gate', 'Control input, voltage here switches channel on/off', 10, 8, 'io'),
    (2, 'Drain', 'Current flows in from the load side', 10, 92, 'power'),
    (3, 'Source', 'Current flows out, typically to ground', 90, 50, 'ground')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'mosfet-irf540n'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'Gate', 'Control input, pulled low relative to source to turn on', 10, 8, 'io'),
    (2, 'Drain', 'Current flows out toward the load', 10, 92, 'power'),
    (3, 'Source', 'Connected to the positive supply rail', 90, 50, 'power')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'mosfet-irf9540'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'Gate', 'Logic-level control input from microcontroller', 10, 8, 'io'),
    (2, 'Drain', 'Connects to the load', 10, 92, 'power'),
    (3, 'Source', 'Typically connected to ground', 90, 50, 'ground')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'mosfet-irlz44n'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'IN', 'Unregulated input voltage, 7V-25V', 10, 8, 'power'),
    (2, 'GND', 'Common ground reference', 10, 92, 'ground'),
    (3, 'OUT', 'Regulated 5V output', 90, 50, 'power')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'lm7805-regulator'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'ADJ', 'Adjust pin, sets output via resistor divider', 10, 8, 'special'),
    (2, 'VOUT', 'Regulated adjustable output', 10, 92, 'power'),
    (3, 'VIN', 'Unregulated input voltage', 90, 50, 'power')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'lm317-regulator'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'VIN', 'Unregulated input, typically 5V', 10, 8, 'power'),
    (2, 'GND', 'Ground reference', 10, 92, 'ground'),
    (3, 'VOUT', 'Regulated 3.3V output', 90, 50, 'power')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'ams1117-regulator'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'VIN+', 'Positive input voltage', 10, 8, 'power'),
    (2, 'VIN-', 'Input ground', 10, 92, 'ground'),
    (3, 'VOUT+', 'Regulated positive output', 90, 8, 'power'),
    (4, 'VOUT-', 'Output ground', 90, 92, 'ground')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'lm2596-buck-module'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'OUT1', 'Output of amplifier 1', 10, 8, 'io'),
    (2, 'IN1-', 'Inverting input 1', 10, 36, 'io'),
    (3, 'IN1+', 'Non-inverting input 1', 10, 64, 'io'),
    (4, 'V-', 'Negative supply / ground', 10, 92, 'ground'),
    (5, 'IN2+', 'Non-inverting input 2', 90, 8, 'io'),
    (6, 'IN2-', 'Inverting input 2', 90, 36, 'io'),
    (7, 'OUT2', 'Output of amplifier 2', 90, 64, 'io'),
    (8, 'V+', 'Positive supply', 90, 92, 'power')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'lm358-opamp'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'OFFSET N1', 'Offset null trim', 10, 8, 'special'),
    (2, 'IN-', 'Inverting input', 10, 36, 'io'),
    (3, 'IN+', 'Non-inverting input', 10, 64, 'io'),
    (4, 'V-', 'Negative supply', 10, 92, 'power'),
    (5, 'OFFSET N2', 'Offset null trim', 90, 8, 'special'),
    (6, 'OUT', 'Amplifier output', 90, 50, 'io'),
    (7, 'V+', 'Positive supply', 90, 92, 'power')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'lm741-opamp'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'Q0-Q7', 'Parallel data outputs', 10, 8, 'io'),
    (2, 'GND', 'Ground', 10, 29, 'ground'),
    (3, 'Q7S', 'Serial data output to next chip', 10, 50, 'special'),
    (4, 'MR', 'Master reset, active low', 10, 71, 'special'),
    (5, 'SHCP', 'Shift register clock', 10, 92, 'special'),
    (6, 'STCP', 'Storage register clock / latch', 90, 8, 'special'),
    (7, 'OE', 'Output enable, active low', 90, 36, 'special'),
    (8, 'DS', 'Serial data input', 90, 64, 'special'),
    (9, 'VCC', 'Supply voltage', 90, 92, 'power')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = '74hc595-shift-register'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, '1A', 'Gate 1 input A', 10, 8, 'io'),
    (2, '1B', 'Gate 1 input B', 10, 36, 'io'),
    (3, '1Y', 'Gate 1 output', 10, 64, 'io'),
    (4, '2A', 'Gate 2 input A', 10, 92, 'io'),
    (5, '2B', 'Gate 2 input B', 90, 8, 'io'),
    (6, '2Y', 'Gate 2 output', 90, 36, 'io'),
    (7, 'GND', 'Ground', 90, 64, 'ground'),
    (8, 'VCC', 'Supply voltage', 90, 92, 'power')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = '74hc00-nand-gate'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'CLK', 'Clock input, advances counter on rising edge', 10, 8, 'io'),
    (2, 'RESET', 'Resets counter to output 0', 10, 50, 'special'),
    (3, 'Q0-Q9', 'Decoded sequential outputs', 10, 92, 'io'),
    (4, 'CARRY OUT', 'Pulses once per full 10-count cycle', 90, 8, 'special'),
    (5, 'VDD', 'Supply voltage', 90, 50, 'power'),
    (6, 'VSS', 'Ground', 90, 92, 'ground')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'cd4017-decade-counter'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'Y0-Y7', 'Eight multiplexed I/O channels', 10, 8, 'io'),
    (2, 'Z', 'Common input/output pin', 10, 50, 'io'),
    (3, 'A,B,C', '3-bit channel select address', 10, 92, 'special'),
    (4, 'INH', 'Inhibit, disables all channels when high', 90, 8, 'special'),
    (5, 'VDD', 'Positive supply', 90, 50, 'power'),
    (6, 'VSS', 'Ground / negative supply', 90, 92, 'ground')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'cd4051-multiplexer'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'GND', 'Ground', 10, 8, 'ground'),
    (2, 'TRIG', 'Trigger input, starts timing cycle', 10, 36, 'special'),
    (3, 'OUT', 'Timer output', 10, 64, 'io'),
    (4, 'RESET', 'Active-low reset', 10, 92, 'special'),
    (5, 'CTRL', 'Control voltage, sets threshold levels', 90, 8, 'special'),
    (6, 'THR', 'Threshold, senses capacitor voltage', 90, 36, 'analog'),
    (7, 'DIS', 'Discharge, drains timing capacitor', 90, 64, 'special'),
    (8, 'VCC', 'Supply voltage', 90, 92, 'power')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'ne555-timer'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, '1 DIS', 'Timer 1 discharge', 10, 8, 'special'),
    (2, '1 THR', 'Timer 1 threshold', 10, 36, 'analog'),
    (3, '1 CTRL', 'Timer 1 control voltage', 10, 64, 'special'),
    (4, '1 RESET', 'Timer 1 reset', 10, 92, 'special'),
    (5, '1 OUT', 'Timer 1 output', 90, 8, 'io'),
    (6, '1 TRIG', 'Timer 1 trigger', 90, 36, 'special'),
    (7, 'GND', 'Ground', 90, 64, 'ground'),
    (8, 'VCC', 'Supply voltage', 90, 92, 'power')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'ne556-dual-timer'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'VCC', 'Supply voltage, 1.8-5.5V', 10, 8, 'power'),
    (2, 'GND', 'Ground', 10, 36, 'ground'),
    (3, 'RESET', 'Active-low reset', 10, 64, 'special'),
    (4, 'PB0-PB7', 'Port B digital I/O, includes SPI and oscillator', 10, 92, 'io'),
    (5, 'PC0-PC6', 'Port C, includes ADC0-5 analog inputs', 90, 8, 'analog'),
    (6, 'PD0-PD7', 'Port D digital I/O, includes UART', 90, 36, 'io'),
    (7, 'AVCC', 'Analog supply for ADC', 90, 64, 'power'),
    (8, 'AREF', 'ADC reference voltage', 90, 92, 'analog')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'atmega328p'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, '3V3', '3.3V regulated supply', 10, 8, 'power'),
    (2, 'EN', 'Chip enable, active high', 10, 29, 'special'),
    (3, 'GPIO36', 'Input-only ADC pin', 10, 50, 'analog'),
    (4, 'GPIO39', 'Input-only ADC pin', 10, 71, 'analog'),
    (5, 'GND', 'Ground', 10, 92, 'ground'),
    (6, 'GPIO23', 'General I/O, PWM capable', 90, 8, 'io'),
    (7, 'GPIO22', 'General I/O, common I2C SCL', 90, 29, 'io'),
    (8, 'GPIO21', 'General I/O, common I2C SDA', 90, 50, 'io'),
    (9, 'TX0', 'UART0 transmit', 90, 71, 'special'),
    (10, 'RX0', 'UART0 receive', 90, 92, 'special')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'esp32-wroom32'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'VCC', '3.3V supply', 10, 8, 'power'),
    (2, 'GND', 'Ground', 10, 36, 'ground'),
    (3, 'GPIO0', 'Boot mode select / general I/O', 10, 64, 'io'),
    (4, 'GPIO2', 'General I/O', 10, 92, 'io'),
    (5, 'CH_PD', 'Chip power-down / enable', 90, 8, 'special'),
    (6, 'RST', 'Reset, active low', 90, 36, 'special'),
    (7, 'TX', 'UART transmit', 90, 64, 'special'),
    (8, 'RX', 'UART receive', 90, 92, 'special')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'esp8266-esp12f'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'VDD', 'Power supply, 2.0-3.6V', 10, 8, 'power'),
    (2, 'VSS', 'Ground', 10, 50, 'ground'),
    (3, 'PA0-PA15', 'Port A GPIO, includes ADC and timers', 10, 92, 'io'),
    (4, 'PB0-PB15', 'Port B GPIO, includes I2C and SPI', 90, 8, 'io'),
    (5, 'NRST', 'Reset, active low', 90, 50, 'special'),
    (6, 'BOOT0', 'Boot mode select', 90, 92, 'special')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'stm32f103c8t6'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'MCLR', 'Master clear reset, active low', 10, 8, 'special'),
    (2, 'RA0-RA5', 'Port A, includes analog inputs', 10, 36, 'analog'),
    (3, 'RB0-RB7', 'Port B, general I/O', 10, 64, 'io'),
    (4, 'RC0-RC7', 'Port C, includes I2C/SPI/UART', 10, 92, 'io'),
    (5, 'RD0-RD7', 'Port D, general I/O parallel port', 90, 8, 'io'),
    (6, 'VDD', 'Supply voltage', 90, 50, 'power'),
    (7, 'VSS', 'Ground', 90, 92, 'ground')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'pic16f877a'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, '5V', 'Regulated 5V output', 10, 8, 'power'),
    (2, '3V3', 'Regulated 3.3V output', 10, 36, 'power'),
    (3, 'GND', 'Ground', 10, 64, 'ground'),
    (4, 'VIN', 'Unregulated input voltage', 10, 92, 'power'),
    (5, 'A0-A5', 'Analog input pins', 90, 8, 'analog'),
    (6, 'D0/RX-D13', 'Digital I/O pins, D0/D1 shared with UART', 90, 36, 'io'),
    (7, 'AREF', 'ADC reference voltage', 90, 64, 'analog'),
    (8, 'RESET', 'Board reset', 90, 92, 'special')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'arduino-uno-r3'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, '3V3 Power', '3.3V supply rail', 10, 8, 'power'),
    (2, '5V Power', '5V supply rail', 10, 36, 'power'),
    (3, 'GND', 'Ground', 10, 64, 'ground'),
    (4, 'GPIO2/SDA', 'I2C data / general I/O', 10, 92, 'io'),
    (5, 'GPIO3/SCL', 'I2C clock / general I/O', 90, 8, 'io'),
    (6, 'GPIO14/TXD', 'UART transmit / general I/O', 90, 50, 'special'),
    (7, 'GPIO15/RXD', 'UART receive / general I/O', 90, 92, 'special')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'raspberry-pi-4'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'VBUS', 'USB 5V input', 10, 8, 'power'),
    (2, 'VSYS', 'System input voltage', 10, 36, 'power'),
    (3, '3V3(OUT)', 'Regulated 3.3V output', 10, 64, 'power'),
    (4, 'GND', 'Ground', 10, 92, 'ground'),
    (5, 'GP0-GP28', 'General purpose digital I/O', 90, 8, 'io'),
    (6, 'ADC0-ADC2', 'Analog input pins', 90, 50, 'analog'),
    (7, 'RUN', 'Enable / reset pin', 90, 92, 'special')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'raspberry-pi-pico'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'VCC', 'Supply voltage, 3.3-6V', 10, 8, 'power'),
    (2, 'DATA', 'Single-wire digital data output', 10, 92, 'special'),
    (3, 'NC', 'Not connected', 90, 8, 'special'),
    (4, 'GND', 'Ground', 90, 92, 'ground')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'dht22-sensor'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'VCC', '5V supply', 10, 8, 'power'),
    (2, 'TRIG', 'Trigger pulse input, starts a measurement', 10, 92, 'special'),
    (3, 'ECHO', 'Echo pulse output, width represents distance', 90, 8, 'special'),
    (4, 'GND', 'Ground', 90, 92, 'ground')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'hc-sr04-sensor'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'VCC', 'Supply voltage', 10, 8, 'power'),
    (2, 'OUT', 'Digital motion detection output', 10, 92, 'io'),
    (3, 'GND', 'Ground', 90, 50, 'ground')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'pir-hcsr501-sensor'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'VCC', 'Supply voltage, 3-5V', 10, 8, 'power'),
    (2, 'GND', 'Ground', 10, 36, 'ground'),
    (3, 'SCL', 'I2C clock line', 10, 64, 'special'),
    (4, 'SDA', 'I2C data line', 10, 92, 'special'),
    (5, 'XDA', 'Auxiliary I2C data (for external sensors)', 90, 8, 'special'),
    (6, 'XCL', 'Auxiliary I2C clock', 90, 36, 'special'),
    (7, 'AD0', 'I2C address select', 90, 64, 'special'),
    (8, 'INT', 'Interrupt output', 90, 92, 'io')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'mpu6050-sensor'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'VCC', 'Supply voltage', 10, 8, 'power'),
    (2, 'GND', 'Ground', 10, 50, 'ground'),
    (3, 'SCL', 'I2C clock / SPI clock', 10, 92, 'special'),
    (4, 'SDA', 'I2C data / SPI MOSI', 90, 8, 'special'),
    (5, 'CSB', 'Chip select (SPI mode)', 90, 50, 'special'),
    (6, 'SDO', 'SPI MISO / I2C address select', 90, 92, 'special')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'bmp280-sensor'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'VCC', 'Supply voltage', 10, 8, 'power'),
    (2, 'GND', 'Ground', 10, 92, 'ground'),
    (3, 'AO', 'Analog moisture output', 90, 8, 'analog'),
    (4, 'DO', 'Digital threshold output', 90, 92, 'io')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'soil-moisture-sensor'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'VCC', '5V supply (also powers heater)', 10, 8, 'power'),
    (2, 'GND', 'Ground', 10, 92, 'ground'),
    (3, 'AO', 'Analog gas concentration output', 90, 8, 'analog'),
    (4, 'DO', 'Digital threshold output', 90, 92, 'io')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'mq2-gas-sensor'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'VCC', 'Supply voltage', 10, 8, 'power'),
    (2, 'GND', 'Ground', 10, 50, 'ground'),
    (3, 'TXD', 'UART transmit (3.3V logic)', 10, 92, 'special'),
    (4, 'RXD', 'UART receive, needs level shifting from 5V', 90, 8, 'special'),
    (5, 'STATE', 'Connection status output', 90, 50, 'special'),
    (6, 'EN', 'Enable / AT command mode select', 90, 92, 'special')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'hc-05-bluetooth'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'VCC', '3.3V supply', 10, 8, 'power'),
    (2, 'GND', 'Ground', 10, 36, 'ground'),
    (3, 'CE', 'Chip enable, activates TX/RX mode', 10, 64, 'special'),
    (4, 'CSN', 'SPI chip select', 10, 92, 'special'),
    (5, 'SCK', 'SPI clock', 90, 8, 'special'),
    (6, 'MOSI', 'SPI data in', 90, 36, 'special'),
    (7, 'MISO', 'SPI data out', 90, 64, 'special'),
    (8, 'IRQ', 'Interrupt output', 90, 92, 'io')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'nrf24l01-module'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'VCC', 'Power input, 3.4-4.4V', 10, 8, 'power'),
    (2, 'GND', 'Ground', 10, 50, 'ground'),
    (3, 'TXD', 'UART transmit', 10, 92, 'special'),
    (4, 'RXD', 'UART receive', 90, 8, 'special'),
    (5, 'RST', 'Module reset', 90, 50, 'special'),
    (6, 'RING', 'Incoming call/SMS indicator', 90, 92, 'special')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'sim800l-module'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'VCC', '3.3V supply', 10, 8, 'power'),
    (2, 'GND', 'Ground', 10, 36, 'ground'),
    (3, 'RST', 'Reset input', 10, 64, 'special'),
    (4, 'SCK', 'SPI clock', 10, 92, 'special'),
    (5, 'MOSI', 'SPI data in', 90, 8, 'special'),
    (6, 'MISO', 'SPI data out', 90, 50, 'special'),
    (7, 'SDA/SS', 'SPI chip select', 90, 92, 'special')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'rc522-rfid-module'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'VCC', '3.3V supply', 10, 8, 'power'),
    (2, 'GND', 'Ground', 10, 36, 'ground'),
    (3, 'SCK', 'SPI clock', 10, 64, 'special'),
    (4, 'MISO', 'SPI data out', 10, 92, 'special'),
    (5, 'MOSI', 'SPI data in', 90, 8, 'special'),
    (6, 'NSS', 'SPI chip select', 90, 36, 'special'),
    (7, 'RST', 'Module reset', 90, 64, 'special'),
    (8, 'DIO0', 'Interrupt / packet ready output', 90, 92, 'io')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'sx1278-lora-module'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'VSS', 'Ground', 10, 8, 'ground'),
    (2, 'VDD', 'Supply voltage, 5V', 10, 36, 'power'),
    (3, 'V0', 'Contrast adjustment', 10, 64, 'special'),
    (4, 'RS', 'Register select, command vs data', 10, 92, 'special'),
    (5, 'RW', 'Read/write select', 90, 8, 'special'),
    (6, 'E', 'Enable, latches data on falling edge', 90, 36, 'special'),
    (7, 'D0-D7', '8-bit data bus (4-bit mode uses D4-D7)', 90, 64, 'io'),
    (8, 'A/K', 'Backlight anode/cathode', 90, 92, 'power')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'lcd-16x2-hd44780'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'GND', 'Ground', 10, 8, 'ground'),
    (2, 'VCC', 'Supply voltage', 10, 92, 'power'),
    (3, 'SCL', 'I2C clock / SPI clock', 90, 8, 'special'),
    (4, 'SDA', 'I2C data / SPI data', 90, 92, 'special')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'ssd1306-oled'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'a-g', 'Seven segment cathode/anode pins', 10, 8, 'io'),
    (2, 'dp', 'Decimal point pin', 10, 92, 'io'),
    (3, 'COM', 'Common anode or cathode pin', 90, 50, 'power')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = '7-segment-display'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'VCC', 'Supply voltage', 10, 8, 'power'),
    (2, 'GND', 'Ground', 10, 29, 'ground'),
    (3, 'CS', 'SPI chip select', 10, 50, 'special'),
    (4, 'RESET', 'Display reset', 10, 71, 'special'),
    (5, 'DC/RS', 'Data/command select', 10, 92, 'special'),
    (6, 'SDI/MOSI', 'SPI data in', 90, 8, 'special'),
    (7, 'SCK', 'SPI clock', 90, 36, 'special'),
    (8, 'LED', 'Backlight control', 90, 64, 'power'),
    (9, 'SDO/MISO', 'SPI data out', 90, 92, 'special')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'ili9341-tft'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'RST', 'Reset', 10, 8, 'special'),
    (2, 'CE', 'Chip enable / SPI select', 10, 36, 'special'),
    (3, 'DC', 'Data/command select', 10, 64, 'special'),
    (4, 'DIN', 'SPI data in', 10, 92, 'special'),
    (5, 'CLK', 'SPI clock', 90, 8, 'special'),
    (6, 'VCC', 'Supply voltage, 3.3V', 90, 36, 'power'),
    (7, 'BL', 'Backlight control', 90, 64, 'power'),
    (8, 'GND', 'Ground', 90, 92, 'ground')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'nokia5110-lcd'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'VCC', 'Relay coil supply, 5V', 10, 8, 'power'),
    (2, 'GND', 'Ground', 10, 50, 'ground'),
    (3, 'IN', 'Logic-level trigger input', 10, 92, 'io'),
    (4, 'COM', 'Common contact', 90, 8, 'power'),
    (5, 'NO', 'Normally open contact', 90, 50, 'power'),
    (6, 'NC', 'Normally closed contact', 90, 92, 'power')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = '5v-relay-module'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, '+', 'DC control input positive', 10, 8, 'io'),
    (2, '-', 'DC control input negative', 10, 92, 'ground'),
    (3, '1 (L)', 'AC load line in', 90, 8, 'power'),
    (4, '2 (T)', 'AC load line out to load', 90, 92, 'power')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'solid-state-relay'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'A,B,C,D', 'Four coil phase inputs (via driver board)', 10, 50, 'io'),
    (2, '+', 'Common coil center-tap supply', 90, 50, 'power')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = '28byj48-stepper'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'Signal', 'PWM control input, orange/yellow wire', 10, 8, 'io'),
    (2, 'VCC', 'Power, red wire, 4.8-6V', 10, 92, 'power'),
    (3, 'GND', 'Ground, brown/black wire', 90, 50, 'ground')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'sg90-servo'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'ENA', 'PWM speed enable, channel A', 10, 8, 'io'),
    (2, 'IN1,IN2', 'Direction control, channel A', 10, 29, 'io'),
    (3, 'OUT1,OUT2', 'Motor A output terminals', 10, 50, 'power'),
    (4, 'IN3,IN4', 'Direction control, channel B', 10, 71, 'io'),
    (5, 'OUT3,OUT4', 'Motor B output terminals', 10, 92, 'power'),
    (6, 'ENB', 'PWM speed enable, channel B', 90, 8, 'io'),
    (7, '+12V', 'Motor supply input', 90, 36, 'power'),
    (8, 'GND', 'Ground', 90, 64, 'ground'),
    (9, '+5V', 'Logic supply output/input', 90, 92, 'power')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'l298n-driver'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'VMOT', 'Motor supply voltage', 10, 8, 'power'),
    (2, 'GND', 'Motor ground', 10, 36, 'ground'),
    (3, '1A,1B,2A,2B', 'Stepper coil connections', 10, 64, 'power'),
    (4, 'STEP', 'Pulse input, one step per rising edge', 10, 92, 'io'),
    (5, 'DIR', 'Direction control', 90, 8, 'io'),
    (6, 'ENABLE', 'Active-low driver enable', 90, 36, 'special'),
    (7, 'MS1,MS2,MS3', 'Microstep resolution select', 90, 64, 'special'),
    (8, 'VDD', 'Logic supply, 3-5.5V', 90, 92, 'power')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'a4988-stepper-driver'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'VMOT', 'Motor supply voltage', 10, 8, 'power'),
    (2, 'GND', 'Motor ground', 10, 36, 'ground'),
    (3, 'A1,A2,B1,B2', 'Stepper coil connections', 10, 64, 'power'),
    (4, 'STEP', 'Pulse input, one step per rising edge', 10, 92, 'io'),
    (5, 'DIR', 'Direction control', 90, 8, 'io'),
    (6, 'ENABLE', 'Active-low driver enable', 90, 36, 'special'),
    (7, 'M0,M1,M2', 'Microstep resolution select', 90, 64, 'special'),
    (8, 'VDD', 'Logic supply', 90, 92, 'power')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'drv8825-stepper-driver'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, '~', 'AC input terminal 1', 10, 8, 'power'),
    (2, '~', 'AC input terminal 2', 10, 92, 'power'),
    (3, '+', 'DC positive output', 90, 8, 'power'),
    (4, '-', 'DC negative output / ground', 90, 92, 'ground')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'bridge-rectifier'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'MT1', 'Main terminal 1 (reference for gate)', 10, 8, 'power'),
    (2, 'MT2', 'Main terminal 2', 10, 92, 'power'),
    (3, 'GATE', 'Trigger input', 90, 50, 'special')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'bt136-triac'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'ANODE', 'Main current path input', 10, 8, 'power'),
    (2, 'CATHODE', 'Main current path output', 10, 92, 'power'),
    (3, 'GATE', 'Trigger input', 90, 50, 'special')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'thyristor-scr'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'GATE', 'Voltage-controlled switching input', 10, 8, 'io'),
    (2, 'COLLECTOR', 'High-side current terminal', 10, 92, 'power'),
    (3, 'EMITTER', 'Low-side current terminal', 90, 50, 'ground')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'igbt'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'NC/EN', 'No connect or enable/tri-state', 10, 8, 'special'),
    (2, 'GND', 'Ground', 10, 92, 'ground'),
    (3, 'OUT', 'Square wave clock output', 90, 8, 'special'),
    (4, 'VDD', 'Supply voltage', 90, 92, 'power')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = 'crystal-oscillator-can'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'XTAL1', 'Crystal terminal 1, to microcontroller oscillator pin', 10, 50, 'special'),
    (2, 'XTAL2', 'Crystal terminal 2, to microcontroller oscillator pin', 90, 50, 'special')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = '16mhz-quartz-crystal'
on conflict (component_id, pin_number) do nothing;

insert into public.component_pins (component_id, pin_number, label, description, x, y, pin_type)
select c.id, p.pin_number, p.label, p.description, p.x, p.y, p.pin_type
from public.components c
cross join lateral (
  values
    (1, 'XTAL1', 'Crystal terminal 1, to RTC oscillator pin', 10, 50, 'special'),
    (2, 'XTAL2', 'Crystal terminal 2, to RTC oscillator pin', 90, 50, 'special')
) as p(pin_number, label, description, x, y, pin_type)
where c.slug = '32768hz-watch-crystal'
on conflict (component_id, pin_number) do nothing;
