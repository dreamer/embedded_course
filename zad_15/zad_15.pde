// vim: noai:ts=4:sw=4

/*
- J41, J42  (speaker)
- 8 <-> F39 (speaker)
- 2 <-> I31 (button)
- 9 <-> A9  (led)
*/

#include <assert.h>
#include "morse.h"

#define NOTE_C4 (262)
#define BUTTON_PIN (2)
#define LED_PIN (9)
#define DELAY (10) // ms
#define DOT (130) // ms
#define BUFFER_SIZE (10)

int button_state = LOW;
int prev_button_state = LOW;
int duration = 0;
bool printed_space = true;
char buffer[BUFFER_SIZE] = { '\0' };
int buffer_end = 0;

void signal_on()
{
	analogWrite(LED_PIN, 255);
	tone(8, NOTE_C4, 4);
}

void signal_off()
{
	analogWrite(LED_PIN, 0);
	noTone(8);
}

void save(char c)
{
	assert('.' == c || '-' == c);

	buffer[buffer_end] = c;
	buffer_end = min(buffer_end+1, BUFFER_SIZE-2);
}

bool has_letter()
{
	return buffer[0];
}

char get_letter()
{
	char c = decode(buffer);
	buffer_end = 0;
	memset(buffer, '\0', BUFFER_SIZE);
	return c ? c : '?';
}

void setup()
{
	Serial.begin(9600);
	pinMode(LED_PIN, OUTPUT);
	pinMode(BUTTON_PIN, INPUT);
}

void loop()
{
	button_state = digitalRead(BUTTON_PIN);

	duration += DELAY;

	if (prev_button_state != button_state) {

		if (button_state == HIGH)
			signal_on();
		else
			signal_off();

		// dash is 3 times longer than dot,
		// letters are separated with dash time of silence
		// words are separated with 7 dot time of silence
		// we use 0.5 dot of tolerance

		if (prev_button_state == HIGH) {

			if (duration < 2 * DOT)
				save('.');
			else
				save('-');
		}

		duration = 0;
	}

	if (button_state == LOW) {

		if (duration > 2 * DOT) {
			if (has_letter()) {
				Serial.print(get_letter());

				// printing any char implies, that we will want
				// new space after whole word
				printed_space = false;
			}
		}

		if (duration > 6 * DOT) {
			if (!printed_space) {
				Serial.print('_');
				printed_space = true;
			}
		}
	}

	prev_button_state = button_state;
	delay(DELAY);
}
