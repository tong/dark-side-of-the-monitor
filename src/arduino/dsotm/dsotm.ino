
#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
    #include <avr/power.h>
#endif
//#include "dsotm.h"

#define NUM_PIXELS 8
#define PIN 6

Adafruit_NeoPixel light = Adafruit_NeoPixel( NUM_PIXELS, PIN, NEO_GRB + NEO_KHZ800 );

void setColor( uint8_t r, uint8_t g, uint8_t b ) {
    for( uint16_t i = 0; i < NUM_PIXELS; i++ ) {
        light.setPixelColor( i, r, g, b );
    }
    light.show();
}

void setup() {

    #if defined (__AVR_ATtiny85__)
        if( F_CPU == 16000000 ) clock_prescale_set( clock_div_1 );
    #endif

    Serial.begin( 115200 );

    light.begin();
    //light.setPixelColor( 0, 255,255,255 );
    light.show();
}

int ready = -1;

void loop() {

    int available = Serial.available();

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
