// vim: noai:ts=4:sw=4

/*
- J41, J42  (speaker)
- 8 <-> F39 (speaker)
- 9 <-> A9  (led)
*/

#include "morse.h"

#include <string.h>
#include <ctype.h>

#define NOTE_C4 (262)
#define LED_PIN (9)
#define DOT (200) // ms
#define BUFFER_SIZE (1024)

enum State { READ, BEEP };

char buffer[BUFFER_SIZE] = { '\0' };
State state = READ;

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

void beep()
{
	unsigned msg_length = strlen(buffer);

	for (unsigned i = 0; i < msg_length; i++) {
		char c = buffer[i];

		if (isspace(c)) {
			signal_off();
			delay(7 * DOT);
			while (isspace(buffer[i+1])) i++;
			continue;
		}

		const char *code = encode(buffer[i]);
		if (!code[0])
			continue;

		for (unsigned j = 0; j < strlen(code); j++) {
			int dots = code[j] == '-' ? 3 : 1;
			signal_on();
			delay(dots * DOT);
			signal_off();
			delay(DOT);
		}
		delay(3 * DOT);
	}
}

void setup()
{
	Serial.begin(9600);
	pinMode(LED_PIN, OUTPUT);
}

void loop()
{
	switch (state)
	{
		case READ:
			Serial.readBytesUntil('\n', buffer, BUFFER_SIZE);
			state = BEEP;
			break;

		case BEEP:
			beep();
			state = READ;
			break;
	}
}
