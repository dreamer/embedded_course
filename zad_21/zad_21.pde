// vim: noai:ts=4:sw=4

/*
FIXME copy GND to all exercises!
- 5V idzie do -
- GND idzie do +
- GND do F21

- 9  <-> F26 (led)
- 11 <-> F23 (led)
- 10 <-> F24 (led)
*/

#define R_LED_PIN (9)
#define G_LED_PIN (10)
#define B_LED_PIN (11)
#define DELAY (30) // ms

int r_color = 255;
int g_color = 255;
int b_color = 255;

float brightness = 0.0;
float fade = 0.01;

void setup()
{
	Serial.begin(9600);
}

void loop()  {

	analogWrite(R_LED_PIN, r_color * brightness);
	analogWrite(G_LED_PIN, g_color * brightness);
	analogWrite(B_LED_PIN, b_color * brightness);

	if (brightness < fabs(fade)) {
		r_color = random(0, 255);
		g_color = random(0, 255);
		b_color = random(0, 255);
	}

	brightness += fade;

	if (brightness < fabs(fade) || brightness > 1.0 - fabs(fade))
		fade = -fade;

	delay(DELAY);
}
