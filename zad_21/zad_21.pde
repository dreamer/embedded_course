- 5V idzie do -
- GND idzie do +
- GND do F21
- 11 do F23
- 10 do F24
- 9 do F26




byte r_pin = 9;
byte g_pin = 10;
byte b_pin = 11;

int r_color = 255;
int g_color = 0;
int b_color = 255;

float brightness = 0.0;
float iFadeAmount = 0.01;
float fadeAmount = 0.01;

void setup()
{
    Serial.begin(9600);
}

void loop()  {
    analogWrite(r_pin, r_color*brightness);
    analogWrite(g_pin, g_color*brightness);
    analogWrite(b_pin, b_color*brightness); 

    brightness = brightness + fadeAmount;
    Serial.println(brightness);
    if (brightness < fabs(fadeAmount) || brightness > 1.0-fabs(fadeAmount)) {
      fadeAmount = -fadeAmount ;
    }     
    if(brightness < fabs(fadeAmount)){
        r_color = random(0,255);
        g_color = random(0, 255);
        b_color = random(0, 255);
    }  
    delay(30);                            
}
