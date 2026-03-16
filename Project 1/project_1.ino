// RGB Wheel Controller Code for Arduino

// Define the pins for the RGB LED
#define RED_PIN 9
#define GREEN_PIN 10
#define BLUE_PIN 11

void setup() {
  // Set the RGB pins as output
  pinMode(RED_PIN, OUTPUT);
  pinMode(GREEN_PIN, OUTPUT);
  pinMode(BLUE_PIN, OUTPUT);
}

void loop() {
  // Cycle through colors
  for (int i = 0; i < 255; i++) {
    setColor(i, 0, 255 - i); // From blue to red
  }
  for (int i = 0; i < 255; i++) {
    setColor(255 - i, i, 0); // From red to green
  }
  for (int i = 0; i < 255; i++) {
    setColor(0, 255 - i, i); // From green to blue
  }
}

void setColor(int red, int green, int blue) {
  analogWrite(RED_PIN, red);
  analogWrite(GREEN_PIN, green);
  analogWrite(BLUE_PIN, blue);
  delay(10); // Delay for a short while to see the color change
}