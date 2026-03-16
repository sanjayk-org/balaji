# RGB LED Wiring for ESP32 and ESP8266

## Pin Connections

- **ESP32:**
  - Red: GPIO 23
  - Green: GPIO 22
  - Blue: GPIO 21

- **ESP8266:**
  - Red: GPIO 5
  - Green: GPIO 4
  - Blue: GPIO 0

## Breadboard Layout

1. Place the RGB LED on the breadboard.
2. Connect the long leg (common anode/cathode) of the RGB LED to the positive voltage rail (+5V for common anode or ground for common cathode).
3. Connect the respective color legs to the designated GPIO pins through current-limiting resistors.

## Resistor Values

- Use 220 ohm resistors for each color leg of the RGB LED to limit the current:
  - Red: 220 ohm
  - Green: 220 ohm
  - Blue: 220 ohm

## Power Supply Considerations

- Ensure that the power supply voltage matches the LED specifications (typically 5V).
- If using a common anode LED, connect to the positive voltage.

## Troubleshooting Guide

1. **LED not lighting up:**
   - Check the wiring connections.
   - Ensure the correct GPIO pins are used in your code.
   - Verify that the power supply is functioning properly.

2. **Colors not appearing as expected:**
   - Double-check resistor values.
   - Swap the connections for the color pins.

3. **Flickering or dim light:**
   - Investigate power supply quality.
   - Ensure the ESP32/ESP8266 PWM settings are correctly configured.

## Conclusion
Setting up an RGB LED with the ESP32 or ESP8266 can add a vibrant aspect to your projects. Follow the above guidelines for a successful implementation!