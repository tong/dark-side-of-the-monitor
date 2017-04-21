
#include "darkside.h"

#define PIN 2
#define NUM_PIXELS 16

static int frameDelta = 10;

void setup() {

    #if defined (__AVR_ATtiny85__)
    if (F_CPU == 16000000) clock_prescale_set( clock_div_1 );
    #endif

    Serial.begin( 115200 );

    darkside_init( PIN, NUM_PIXELS );
}

void loop() {
    darkside_loop();
    delay( frameDelta );
}

/*
#include <Adafruit_NeoPixel.h>

#define PIN 2
#define NUM_PIXELS 16

Adafruit_NeoPixel light = Adafruit_NeoPixel( NUM_PIXELS, PIN, NEO_GRB + NEO_KHZ800 );

//int colors[] = {2, 4, 8, 3, 6};

void setColor( uint8_t r, uint8_t g, uint8_t b ) {
    for( uint16_t i = 0; i < NUM_PIXELS; i++ ) {
        light.setPixelColor( i, r, g, b );
    }
}

void setup() {

    #if defined (__AVR_ATtiny85__)
    if (F_CPU == 16000000) clock_prescale_set(clock_div_1);
    #endif

    Serial.begin( 57600 );

    //light.setBrightness( BRIGHTNESS );
    light.begin();
    //setColor( 255, 0, 0 );
    light.show();
}

void loop() {

    light.begin();
    light.show();

    int available = Serial.available();

    uint16_t i = 0;

    for( i = 0; i < 32; i++ ) {
        light.setPixelColor( i, 255, 255, 255 );
    }
    /*
    for( ; i < 16; i++ ) {
        light.setPixelColor( i, 255, 0, 0 );
    }
    for( ; i < 24; i++ ) {
        light.setPixelColor( i, 0, 255, 0 );
    }
    for( ; i < 32; i++ ) {
        light.setPixelColor( i, 0, 0, 255 );
    }
    * /

    //setColor( 255, 255, 255 );
    light.show();

    delay( 100 );

    /*
    int available = Serial.available();
    //int i = Serial.read();
    //Serial.println(i);
    //Serial.println( "ccc" );

    if( available > 0 ) {
        int i = Serial.read();
        light.begin();
        setColor(255,255,255);
        light.show();
    } else  {

        //light.begin();
        //setColor( 255, 255, 0 );
        //light.show();
    }

    //byte buf[4];
    //Serial.readBytes( buf, 4 );

    delay( 10 );
    * /
}
*/
