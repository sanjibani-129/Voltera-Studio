-- ============================================================================
-- Voltera Electronics Encyclopedia -- 04_update_model_urls.sql
-- Populates model_url for every catalog component with a REAL, verified,
-- publicly and anonymously fetchable .glb/.gltf file URL where one exists.
--
-- Research outcome: no component in this catalog currently has a real
-- public model URL that can be safely hardcoded here. The vast majority of
-- freely licensed electronics 3D models live on Sketchfab, GrabCAD, Cults3D,
-- FetchCFD, and similar sites -- all of which require an authenticated
-- click-through/download flow (OAuth tokens, session cookies, or signed,
-- expiring URLs) rather than exposing a stable, anonymous, directly
-- fetchable .glb/.gltf file URL suitable for a database column and
-- useGLTF()/fetch() in the browser. Per the brief, no URL is invented here --
-- every row is left explicitly NULL, and the 3D viewer now renders a
-- premium "3D model not yet available." placeholder for all of them.
--
-- As real model_url values are sourced later (e.g. self-hosted conversions
-- uploaded to Supabase Storage), update the relevant row below from NULL to
-- the real https://...supabase.co/storage/... or other direct file URL --
-- next.config.mjs already allow-lists *.supabase.co for next/image, and
-- useGLTF() will fetch any https URL directly, no allow-list needed there.
-- Run AFTER 01_update_components.sql.
-- ============================================================================


update public.components set model_url = NULL where slug = 'carbon-film-resistor';
update public.components set model_url = NULL where slug = 'metal-film-resistor';
update public.components set model_url = NULL where slug = 'potentiometer';
update public.components set model_url = NULL where slug = 'smd-resistor-0805';
update public.components set model_url = NULL where slug = 'trimmer-potentiometer';
update public.components set model_url = NULL where slug = 'ceramic-capacitor';
update public.components set model_url = NULL where slug = 'electrolytic-capacitor';
update public.components set model_url = NULL where slug = 'tantalum-capacitor';
update public.components set model_url = NULL where slug = 'film-capacitor';
update public.components set model_url = NULL where slug = 'supercapacitor';
update public.components set model_url = NULL where slug = 'variable-capacitor';
update public.components set model_url = NULL where slug = 'toroidal-inductor';
update public.components set model_url = NULL where slug = 'ferrite-bead';
update public.components set model_url = NULL where slug = 'power-inductor';
update public.components set model_url = NULL where slug = 'rectifier-diode-1n4007';
update public.components set model_url = NULL where slug = 'schottky-diode-1n5819';
update public.components set model_url = NULL where slug = 'zener-diode';
update public.components set model_url = NULL where slug = 'switching-diode-1n4148';
update public.components set model_url = NULL where slug = 'tvs-diode';
update public.components set model_url = NULL where slug = 'led-5mm';
update public.components set model_url = NULL where slug = 'rgb-led';
update public.components set model_url = NULL where slug = 'ir-led';
update public.components set model_url = NULL where slug = 'ws2812b-led';
update public.components set model_url = NULL where slug = 'npn-transistor-2n2222';
update public.components set model_url = NULL where slug = 'pnp-transistor-2n2907';
update public.components set model_url = NULL where slug = 'darlington-transistor-tip120';
update public.components set model_url = NULL where slug = 'bc547-transistor';
update public.components set model_url = NULL where slug = 'mosfet-irf540n';
update public.components set model_url = NULL where slug = 'mosfet-irf9540';
update public.components set model_url = NULL where slug = 'mosfet-irlz44n';
update public.components set model_url = NULL where slug = 'mosfet-2n7000';
update public.components set model_url = NULL where slug = 'lm7805-regulator';
update public.components set model_url = NULL where slug = 'lm317-regulator';
update public.components set model_url = NULL where slug = 'ams1117-regulator';
update public.components set model_url = NULL where slug = 'lm2596-buck-module';
update public.components set model_url = NULL where slug = 'lm358-opamp';
update public.components set model_url = NULL where slug = 'lm741-opamp';
update public.components set model_url = NULL where slug = 'tl072-opamp';
update public.components set model_url = NULL where slug = '74hc595-shift-register';
update public.components set model_url = NULL where slug = '74hc00-nand-gate';
update public.components set model_url = NULL where slug = 'cd4017-decade-counter';
update public.components set model_url = NULL where slug = 'cd4051-multiplexer';
update public.components set model_url = NULL where slug = 'ne555-timer';
update public.components set model_url = NULL where slug = 'ne556-dual-timer';
update public.components set model_url = NULL where slug = 'atmega328p';
update public.components set model_url = NULL where slug = 'esp32-wroom32';
update public.components set model_url = NULL where slug = 'esp8266-esp12f';
update public.components set model_url = NULL where slug = 'stm32f103c8t6';
update public.components set model_url = NULL where slug = 'pic16f877a';
update public.components set model_url = NULL where slug = 'arduino-uno-r3';
update public.components set model_url = NULL where slug = 'raspberry-pi-4';
update public.components set model_url = NULL where slug = 'raspberry-pi-pico';
update public.components set model_url = NULL where slug = 'esp32-devkitv1';
update public.components set model_url = NULL where slug = 'nodemcu-esp8266';
update public.components set model_url = NULL where slug = 'dht22-sensor';
update public.components set model_url = NULL where slug = 'hc-sr04-sensor';
update public.components set model_url = NULL where slug = 'pir-hcsr501-sensor';
update public.components set model_url = NULL where slug = 'mpu6050-sensor';
update public.components set model_url = NULL where slug = 'ldr-photoresistor';
update public.components set model_url = NULL where slug = 'bmp280-sensor';
update public.components set model_url = NULL where slug = 'soil-moisture-sensor';
update public.components set model_url = NULL where slug = 'mq2-gas-sensor';
update public.components set model_url = NULL where slug = 'hc-05-bluetooth';
update public.components set model_url = NULL where slug = 'nrf24l01-module';
update public.components set model_url = NULL where slug = 'sim800l-module';
update public.components set model_url = NULL where slug = 'rc522-rfid-module';
update public.components set model_url = NULL where slug = 'sx1278-lora-module';
update public.components set model_url = NULL where slug = 'lcd-16x2-hd44780';
update public.components set model_url = NULL where slug = 'ssd1306-oled';
update public.components set model_url = NULL where slug = '7-segment-display';
update public.components set model_url = NULL where slug = 'ili9341-tft';
update public.components set model_url = NULL where slug = 'nokia5110-lcd';
update public.components set model_url = NULL where slug = '5v-relay-module';
update public.components set model_url = NULL where slug = 'solid-state-relay';
update public.components set model_url = NULL where slug = 'dc-motor';
update public.components set model_url = NULL where slug = '28byj48-stepper';
update public.components set model_url = NULL where slug = 'sg90-servo';
update public.components set model_url = NULL where slug = 'bldc-motor';
update public.components set model_url = NULL where slug = 'l298n-driver';
update public.components set model_url = NULL where slug = 'a4988-stepper-driver';
update public.components set model_url = NULL where slug = 'drv8825-stepper-driver';
update public.components set model_url = NULL where slug = 'bridge-rectifier';
update public.components set model_url = NULL where slug = 'bt136-triac';
update public.components set model_url = NULL where slug = 'thyristor-scr';
update public.components set model_url = NULL where slug = 'igbt';
update public.components set model_url = NULL where slug = 'usb-type-c-connector';
update public.components set model_url = NULL where slug = 'jst-xh-connector';
update public.components set model_url = NULL where slug = 'male-header-pins';
update public.components set model_url = NULL where slug = 'dc-barrel-jack';
update public.components set model_url = NULL where slug = 'female-header-socket';
update public.components set model_url = NULL where slug = 'terminal-block';
update public.components set model_url = NULL where slug = '18650-liion-cell';
update public.components set model_url = NULL where slug = 'lipo-battery-pack';
update public.components set model_url = NULL where slug = '9v-battery';
update public.components set model_url = NULL where slug = 'cr2032-coin-cell';
update public.components set model_url = NULL where slug = 'crystal-oscillator-can';
update public.components set model_url = NULL where slug = 'ceramic-resonator';
update public.components set model_url = NULL where slug = 'rc-relaxation-oscillator';
update public.components set model_url = NULL where slug = '16mhz-quartz-crystal';
update public.components set model_url = NULL where slug = '32768hz-watch-crystal';
