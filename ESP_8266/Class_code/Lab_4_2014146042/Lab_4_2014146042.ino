#include <Adafruit_NeoPixel.h> 
#define ledPin 15
#define ledNum 4 
int count = 0;
Adafruit_NeoPixel pixels; 
void setup() {
    pixels = Adafruit_NeoPixel(ledNum, ledPin, NEO_GRB + NEO_KHZ800);
    Serial.begin(115200);
    pixels.begin();
    delay(500);
    Serial.println("starting");
}

void loop() {
    unsigned int R, G, B;
    int pre;
    R = random(0, 255);
    G = random(0, 255);
    B = random(0, 255);
    for (int i = 0; i < ledNum; i++)
    {
        if( i == 0)
        {
            pre = 3;
        }
        else
        {
            pre = i - 1;
        }
        pixels.setPixelColor(pre, pixels.Color(0, 0, 0));
        pixels.setPixelColor(i, pixels.Color(R, G, B));
        pixels.show();
        delay(500);
    }
    
}
