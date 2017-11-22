package darkside;

class ColorUtil {

    public static function rgbToInt( r : Int, g : Int, b : Int ) : Int {
        return (r<<16) | (g<<8) | b;
    }

    /**
        Input a value 0 to 255 to get a color value.
        The colours are a transition r - g - b - back to r.
    */
    public static function wheel( pos : Int ) : Array<Int> {
        pos = 255 - pos;
        if( pos < 85 )
            return [255 - pos * 3, 0, pos * 3 ];
        if( pos < 170 ) {
            pos -= 85;
            return [0, pos * 3, 255 - pos * 3];
        }
        pos -= 170;
        return [pos * 3, 255 - pos * 3, 0];
    }


}
