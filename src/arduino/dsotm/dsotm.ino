
#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
    #include <avr/power.h>
#endif
//#include "dsotm.h"

#define NUM_PIXELS 32
#define PIN 2

Adafruit_NeoPixel light = Adafruit_NeoPixel( NUM_PIXELS, PIN, NEO_GRB + NEO_KHZ800 );
//uint8_t ready = -1;
bool ready = false;

void setColor( uint8_t r, uint8_t g, uint8_t b ) {
    for( uint16_t i = 0; i < NUM_PIXELS; i++ ) {
        light.setPixelColor( i, r, g, b );
    }
    light.show();
}

void setup() {

    #if defined (__AVR_ATtiny85__)
        if( F_CPU == 1600000a0 ) clock_prescale_set( clock_div_1 );
    #endif

    Serial.begin( 115200 );

    light.begin();
    setColor( 255, 255, 255 );
    //light.setPixelColor( 0, 255, 255, 255 );
    //light.show();
    //rainbow(100);
    light.show();

    /*
    while( !ready ) {
        if( Serial.available() ) {
            int i = Serial.read();
            if( i == 0 ) {
                ready = true;
                Serial.print(0);
                break;
            }
        }
    }
    */
}

void loop() {

    int available = Serial.available();

    /*
    if( !ready ) {
        if( available > 0 ) {
            int i = Serial.read();
            if( i == 3 ) {
                ready = true;
                light.setPixelColor( 0, 0, 255, 0 );
                Serial.print("READY");
            } else {
                light.setPixelColor( 0, 255, 0, 0 );
                Serial.print("FUCKED");
            }
        }
        return;
    }
    */

    /*
    if( available > 0 ) {
        int i = 0;
        byte buf[4];
        Serial.readBytes( buf, 4 );
        for( uint16_t i = 0; i < NUM_PIXELS; i++ ) {
            light.setPixelColor( i, buf[1], buf[2], buf[3] );
        }
        light.show();
        //delay(1000);
    } else {
        if( ready == -1 ) {
            //byte r = -1;
            Serial.write( 0 );
            ready = 0;
        }
    }
    */

    if( available > 0 ) {
        byte buf[4];
        Serial.readBytes( buf, 4 );
        for( uint16_t i = 0; i < NUM_PIXELS; i++ ) {
            light.setPixelColor( i, buf[1], buf[2], buf[3] );
        }
        light.show();
        /*
        Serial.print( buf[0] );
        Serial.print( ',' );
        Serial.print( buf[1] );
        Serial.print( ',' );
        Serial.print( buf[2] );
        Serial.print( ',' );
        Serial.println( buf[3] );
        */
    } else {
        /*
        int i = 0;
        while( i < available ) {
            Serial.print(Serial.read());
            i++;
        }
        if( ready == -1 ) {
            //byte r = -1;
            Serial.write( 0 );
            ready = 0;
        }
        */
    }
}

// Input a value 0 to 255 to get a color value.
// The colours are a transition r - g - b - back to r.
uint32_t Wheel(byte WheelPos) {
    WheelPos = 255 - WheelPos;
    if( WheelPos < 85) {
        return light.Color(255 - WheelPos * 3, 0, WheelPos * 3);
    }
    if(WheelPos < 170) {
        WheelPos -= 85;
        return light.Color(0, WheelPos * 3, 255 - WheelPos * 3);
    }
    WheelPos -= 170;
    return light.Color(WheelPos * 3, 255 - WheelPos * 3, 0);
}

void rainbow( uint8_t wait ) {
    uint16_t i, j;
    for(j=0; j<256; j++) {
        for(i=0; i<light.numPixels(); i++) {
            light.setPixelColor(i, Wheel((i+j) & 255));
        }
        light.show();
        delay( wait );
    }
}
