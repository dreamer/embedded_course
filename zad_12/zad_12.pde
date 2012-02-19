// vim: noai:ts=4:sw=4

/*
- 5V  <-> -
- GND <-> +

- A0 <-> F4  (photoresistor)
- 9  <-> A9  (led)
- 2  <-> H13 (button 1)
- 4  <-> H31 (button 2)
*/

#define BUTTON_1_PIN (2)
#define BUTTON_2_PIN (4)
#define LED_PIN (9)
#define LIGHT_PIN (0)

int low = 750;
int high = 980;
int button_1_state = LOW;
int button_2_state = LOW;
int prev_button_1_state = LOW;
int prev_button_2_state = LOW;

int map(int x) {
   if (x < low)
	   return 0;
   if (x > high)
	   return 255;

	float val = x - low;
	float range = high - low;
	return val / range * 255.0;
}

void setup()
{
	Serial.begin(9600);
	pinMode(LED_PIN, OUTPUT );
	pinMode(BUTTON_1_PIN, INPUT);  
	pinMode(BUTTON_2_PIN, INPUT);  
}

void loop()
{
	button_1_state = digitalRead(BUTTON_1_PIN);
	button_2_state = digitalRead(BUTTON_2_PIN);

	if (prev_button_1_state != button_1_state) {
		prev_button_1_state = button_1_state;
		high = analogRead(LIGHT_PIN);
		Serial.print("high: ");
		Serial.println(high);
	}

	if (prev_button_2_state != button_2_state) {
		prev_button_2_state = button_2_state;
		low = analogRead(LIGHT_PIN);
		Serial.print("low: ");
		Serial.println(low);
	}

	analogWrite(LED_PIN, map(analogRead(LIGHT_PIN)));
	delay(30); 
}
