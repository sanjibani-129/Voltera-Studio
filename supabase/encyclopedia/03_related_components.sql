-- ============================================================================
-- Voltera Electronics Encyclopedia -- 03_related_components.sql
-- Curated "related components" graph, used to power a smarter related-items
-- section than the existing same-category fallback in getRelatedComponents().
-- Run AFTER 01_update_components.sql.
-- ============================================================================

create table if not exists public.component_relations (
  id uuid primary key default gen_random_uuid(),
  component_id uuid not null references public.components (id) on delete cascade,
  related_component_id uuid not null references public.components (id) on delete cascade,
  note text,
  created_at timestamptz not null default now(),
  unique (component_id, related_component_id)
);

alter table public.component_relations enable row level security;

drop policy if exists "Component relations are public read" on public.component_relations;
create policy "Component relations are public read" on public.component_relations
  for select using (true);

create index if not exists component_relations_component_idx on public.component_relations (component_id);

delete from public.component_relations;

insert into public.component_relations (component_id, related_component_id, note)
select c.id, r.id, x.note
from (values

  ('carbon-film-resistor', 'metal-film-resistor', 'Alternative resistor construction with tighter tolerance'),
  ('carbon-film-resistor', 'potentiometer', 'Variable counterpart to a fixed resistor'),
  ('carbon-film-resistor', 'led-5mm', 'Commonly paired to limit LED current'),
  ('metal-film-resistor', 'smd-resistor-0805', 'Surface-mount equivalent for compact PCB layouts'),
  ('potentiometer', 'trimmer-potentiometer', 'One-time calibration alternative to a panel potentiometer'),
  ('smd-resistor-0805', 'metal-film-resistor', 'Through-hole equivalent of the SMD part'),
  ('trimmer-potentiometer', 'potentiometer', 'Panel-mount alternative for user-facing adjustment'),
  ('ceramic-capacitor', 'electrolytic-capacitor', 'Often paired together for combined high- and low-frequency filtering'),
  ('electrolytic-capacitor', 'tantalum-capacitor', 'Alternative polarized capacitor with better stability'),
  ('electrolytic-capacitor', 'lm7805-regulator', 'Commonly placed on regulator input/output for stability'),
  ('tantalum-capacitor', 'ceramic-capacitor', 'Alternative for board-space-constrained decoupling'),
  ('film-capacitor', 'ceramic-capacitor', 'Non-polarized alternative with different frequency behavior'),
  ('supercapacitor', '18650-liion-cell', 'Alternative short-term energy storage technology'),
  ('variable-capacitor', 'crystal-oscillator-can', 'Both used in frequency-determining circuits'),
  ('toroidal-inductor', 'lm2596-buck-module', 'Energy storage element in switching regulator designs'),
  ('ferrite-bead', 'lm2596-buck-module', 'Used to suppress switching noise on power rails'),
  ('power-inductor', 'lm2596-buck-module', 'Core energy-storage component inside buck converter modules'),
  ('rectifier-diode-1n4007', 'bridge-rectifier', 'Four rectifier diodes packaged as one component'),
  ('schottky-diode-1n5819', 'lm2596-buck-module', 'Common freewheeling diode in switching regulator circuits'),
  ('zener-diode', 'lm317-regulator', 'Alternative simple way to create a voltage reference'),
  ('switching-diode-1n4148', 'ne555-timer', 'Frequently used for signal steering in 555 timer circuits'),
  ('tvs-diode', 'usb-type-c-connector', 'Commonly placed on data/power lines for ESD protection'),
  ('led-5mm', 'carbon-film-resistor', 'Needs a current-limiting resistor in series'),
  ('rgb-led', 'ws2812b-led', 'Addressable version of the same multi-color LED concept'),
  ('ir-led', 'pir-hcsr501-sensor', 'Alternative motion/presence sensing technologies'),
  ('ws2812b-led', 'rgb-led', 'Simple discrete alternative without integrated driver'),
  ('npn-transistor-2n2222', 'pnp-transistor-2n2907', 'Complementary transistor pair for push-pull designs'),
  ('pnp-transistor-2n2907', 'npn-transistor-2n2222', 'Complementary transistor pair for push-pull designs'),
  ('darlington-transistor-tip120', 'mosfet-irlz44n', 'Alternative high-current switch for driving motors'),
  ('bc547-transistor', 'npn-transistor-2n2222', 'Functionally similar general-purpose NPN transistor'),
  ('mosfet-irf540n', 'mosfet-irf9540', 'Complementary N/P-channel pair for H-bridge designs'),
  ('mosfet-irf9540', 'mosfet-irf540n', 'Complementary N/P-channel pair for H-bridge designs'),
  ('mosfet-irlz44n', 'atmega328p', 'Logic-level gate suited to direct microcontroller GPIO drive'),
  ('mosfet-2n7000', 'npn-transistor-2n2222', 'Alternative small-signal switching device'),
  ('lm7805-regulator', 'lm317-regulator', 'Fixed vs adjustable linear regulator alternatives'),
  ('lm317-regulator', 'lm7805-regulator', 'Adjustable vs fixed linear regulator alternatives'),
  ('ams1117-regulator', 'esp32-wroom32', 'Commonly used to supply 3.3V to this module'),
  ('lm2596-buck-module', 'lm7805-regulator', 'Efficient switching alternative to linear regulation'),
  ('lm358-opamp', 'lm741-opamp', 'Alternative general-purpose operational amplifier'),
  ('lm741-opamp', 'tl072-opamp', 'Modern low-noise alternative to the classic 741'),
  ('tl072-opamp', 'lm358-opamp', 'Dual-supply vs single-supply op-amp alternatives'),
  ('74hc595-shift-register', 'cd4017-decade-counter', 'Alternative way to drive multiple outputs sequentially'),
  ('74hc00-nand-gate', 'cd4017-decade-counter', 'Basic logic building blocks often combined together'),
  ('cd4017-decade-counter', 'ne555-timer', 'Frequently clocked by a 555 timer astable circuit'),
  ('cd4051-multiplexer', 'atmega328p', 'Commonly used to expand a microcontroller''s analog inputs'),
  ('ne555-timer', 'ne556-dual-timer', 'Dual-channel version of the same timer design'),
  ('ne556-dual-timer', 'ne555-timer', 'Single-channel version of the same timer design'),
  ('atmega328p', 'arduino-uno-r3', 'The microcontroller at the heart of this development board'),
  ('esp32-wroom32', 'esp32-devkitv1', 'Bare module vs breadboard-friendly breakout board'),
  ('esp8266-esp12f', 'nodemcu-esp8266', 'Bare module vs breadboard-friendly breakout board'),
  ('stm32f103c8t6', 'atmega328p', '32-bit vs 8-bit microcontroller alternatives'),
  ('pic16f877a', 'atmega328p', 'Alternative 8-bit microcontroller family'),
  ('arduino-uno-r3', 'atmega328p', 'The microcontroller chip this board is built around'),
  ('arduino-uno-r3', 'l298n-driver', 'Commonly paired for DC motor control projects'),
  ('raspberry-pi-4', 'raspberry-pi-pico', 'Full Linux computer vs bare-metal microcontroller board'),
  ('raspberry-pi-pico', 'raspberry-pi-4', 'Bare-metal microcontroller vs full Linux computer'),
  ('esp32-devkitv1', 'esp32-wroom32', 'Breakout board built around this Wi-Fi/Bluetooth module'),
  ('nodemcu-esp8266', 'esp8266-esp12f', 'Breakout board built around this Wi-Fi module'),
  ('dht22-sensor', 'bmp280-sensor', 'Complementary environmental sensors often used together'),
  ('hc-sr04-sensor', 'pir-hcsr501-sensor', 'Alternative presence/distance sensing approaches'),
  ('pir-hcsr501-sensor', 'hc-sr04-sensor', 'Alternative motion/distance sensing approaches'),
  ('mpu6050-sensor', 'bmp280-sensor', 'Commonly combined on flight controllers for full state sensing'),
  ('ldr-photoresistor', 'mq2-gas-sensor', 'Simple analog environmental sensors'),
  ('bmp280-sensor', 'mpu6050-sensor', 'Commonly combined on flight controllers for full state sensing'),
  ('soil-moisture-sensor', 'dht22-sensor', 'Often combined in garden/greenhouse monitoring projects'),
  ('mq2-gas-sensor', 'ldr-photoresistor', 'Simple analog environmental sensors'),
  ('hc-05-bluetooth', 'nrf24l01-module', 'Alternative short-range wireless communication technologies'),
  ('nrf24l01-module', 'sx1278-lora-module', 'Short-range vs long-range wireless alternatives'),
  ('sim800l-module', 'sx1278-lora-module', 'Cellular vs unlicensed-band long-range connectivity alternatives'),
  ('rc522-rfid-module', 'sim800l-module', 'Both used in access-control and remote monitoring projects'),
  ('sx1278-lora-module', 'nrf24l01-module', 'Long-range vs short-range wireless alternatives'),
  ('lcd-16x2-hd44780', 'ssd1306-oled', 'Character vs graphical display alternatives'),
  ('ssd1306-oled', 'lcd-16x2-hd44780', 'Graphical vs character display alternatives'),
  ('7-segment-display', '74hc595-shift-register', 'Commonly driven through a shift register to save pins'),
  ('ili9341-tft', 'ssd1306-oled', 'Full-color graphics vs simple monochrome display alternatives'),
  ('nokia5110-lcd', 'ssd1306-oled', 'Alternative low-power monochrome graphic displays'),
  ('5v-relay-module', 'solid-state-relay', 'Electromechanical vs solid-state switching alternatives'),
  ('solid-state-relay', '5v-relay-module', 'Solid-state vs electromechanical switching alternatives'),
  ('dc-motor', 'l298n-driver', 'Requires an H-bridge driver for direction and speed control'),
  ('28byj48-stepper', 'a4988-stepper-driver', 'Common driver pairing, though the 28BYJ-48 typically uses ULN2003'),
  ('sg90-servo', 'raspberry-pi-pico', 'Commonly controlled via PWM from this board'),
  ('bldc-motor', 'igbt', 'Higher-power BLDC controllers often use IGBTs for phase switching'),
  ('l298n-driver', 'dc-motor', 'Drives the speed and direction of this type of motor'),
  ('a4988-stepper-driver', 'drv8825-stepper-driver', 'Similar stepper driver, higher current and finer microstepping'),
  ('drv8825-stepper-driver', 'a4988-stepper-driver', 'Similar stepper driver, lower current and coarser microstepping'),
  ('bridge-rectifier', 'rectifier-diode-1n4007', 'Built from four of these individual rectifier diodes'),
  ('bt136-triac', 'thyristor-scr', 'Bidirectional vs unidirectional thyristor family devices'),
  ('thyristor-scr', 'bt136-triac', 'Unidirectional vs bidirectional thyristor family devices'),
  ('igbt', 'mosfet-irf540n', 'Alternative high-power switching device'),
  ('usb-type-c-connector', 'dc-barrel-jack', 'Alternative power input connector styles'),
  ('jst-xh-connector', 'lipo-battery-pack', 'Standard connector for this battery''s balance lead'),
  ('male-header-pins', 'female-header-socket', 'Mating connector pair'),
  ('female-header-socket', 'male-header-pins', 'Mating connector pair'),
  ('dc-barrel-jack', 'usb-type-c-connector', 'Alternative power input connector styles'),
  ('terminal-block', 'dc-barrel-jack', 'Alternative field-wiring power connection method'),
  ('18650-liion-cell', 'lipo-battery-pack', 'Alternative rechargeable lithium battery formats'),
  ('lipo-battery-pack', '18650-liion-cell', 'Alternative rechargeable lithium battery formats'),
  ('9v-battery', 'cr2032-coin-cell', 'Alternative primary battery formats for hobby projects'),
  ('cr2032-coin-cell', '9v-battery', 'Alternative primary battery formats for hobby projects'),
  ('crystal-oscillator-can', '16mhz-quartz-crystal', 'Self-contained alternative to a bare crystal plus amplifier'),
  ('ceramic-resonator', '16mhz-quartz-crystal', 'Lower-cost, lower-precision alternative to a quartz crystal'),
  ('rc-relaxation-oscillator', 'ne555-timer', 'Built directly from this timer IC in astable mode'),
  ('16mhz-quartz-crystal', 'atmega328p', 'Common external clock source for this microcontroller'),
  ('32768hz-watch-crystal', 'crystal-oscillator-can', 'Alternative low-frequency timekeeping reference')

) as x(component_slug, related_slug, note)
join public.components c on c.slug = x.component_slug
join public.components r on r.slug = x.related_slug
on conflict (component_id, related_component_id) do update set note = excluded.note;
