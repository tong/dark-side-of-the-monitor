
#include "Darkside.h"

#define PIN 2
#define NUM_PIXELS 16
//#define FRAME_DELTA 400

//Adafruit_NeoPixel strip = Adafruit_NeoPixel( NUM_PIXELS, PIN, NEO_GRB + NEO_KHZ800);
//Darkside darkside(NUM_PIXELS,PIN);
Darkside darkside(NUM_PIXELS,PIN);
uint8_t brightness = 255;

int color[3];

void setup() {

    #if defined (__AVR_ATtiny85__)
    if( F_CPU == 16000000 ) clock_prescale_set( clock_div_1 );
    #endif

    Serial.begin( 115200 );

    darkside.color( 255, 0, 0 );
}

void loop() {

    int bytesReceived = 0;
    while( bytesReceived < 3 ) {
        int available = Serial.available();
        if( available > 0 ) {
            color[bytesReceived] = Serial.read();
            bytesReceived++;
        }
    }

    darkside.begin();
    for( int i = 0; i < darkside.numPixels(); i++ ) {
        //darkside.setPixelColor( i, color );
        darkside.setPixelColor( i, color[0], color[1], color[2] );
    }
    darkside.show();

    /*
    uint32_t c = (uint32_t) color[0] << 16;
    c |= (uint32_t) color[1] << 8;
    c |= (uint32_t) color[2];
    Serial.print(c);
    */

    /*
    if( FRAME_DELTA > 0 ) {
        //delay( FRAME_DELTA );
    }
    */
}
