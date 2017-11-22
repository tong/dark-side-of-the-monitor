package darkside;

import js.npm.SerialPort;

class Controller {

    public var port(default,null) : String;
    public var baudRate(default,null) : BaudRate;
    public var connected(default,null) : Bool;
    //inline function get_port() return serial.port;
    //public var brightness(get,set) : Int;

    var serial : SerialPort;
    var lastSentColor : Int;
    var isSending : Bool;
    var sendBuffer : Array<Array<Int>>;
    var colorToSet : Int;

    public function new( port : String, baudRate : BaudRate ) {
        this.port = port;
        this.baudRate = baudRate;
        connected = false;
        isSending = false;
    }

	public function connect( callback : Error->Void, firstByteDelay = 500 ) {
        serial = new SerialPort( port, { baudRate: baudRate } );
		serial.on( 'error', function(e) trace(e) );
        serial.on( 'disconnect', function(e) trace(e) );
        serial.on( 'data', function(buf) {
            trace( buf.toString() );
            var c = Std.parseInt( buf.toString() );
            trace(c,colorToSet);
            if( c == colorToSet ) {
                isSending = false;
                if( sendBuffer.length > 0 ) {
                    var c = sendBuffer.shift();
                    setColorRGB( c[0], c[1], c[2] );
                }
            }

        });
        serial.on( 'open', function() {
            trace( 'Serialport connected: '+port );
            connected = true;
            sendBuffer = [];
            if( firstByteDelay == null || firstByteDelay == 0 )
                callback( null );
            else {
                Timer.delay( function() callback( null ), firstByteDelay );
            }
        });
	}

	public function disconnect( ?callback : Error->Void ) {
		if( connected ) {
            connected = false;
            sendBuffer = [];
			serial.close( callback );
		}
	}

    /*
    public function getBrightness() : Int {
    }

    public function setBrightness( brightness : Int ) {
    }
    */

    public function setColor( color : Int, ?callback : Void->Void ) {
        setColorRGB( color >> 16 & 0xFF, color >> 8 & 0xFF, color & 0xFF, callback );
    }

    public function setColorRGB( r : Int, g : Int, b : Int, ?callback : Void->Void ) {

        if( !connected )
            throw 'not connected';

        var rgb = [r,g,b];
        var color = ColorUtil.rgbToInt( r, g, b );
        if( color == lastSentColor ) {
            return;
        }

        if( isSending ) {
            sendBuffer.push( rgb );
            return;
        }

        isSending = true;

        var abuf = new ArrayBuffer( 3 );
        var view = new Uint8Array( abuf );
        view.set( rgb );
        var buf = new Buffer( abuf );
        serial.write( buf, function(e){
            if( e != null ) trace(e);
            serial.flush( function(e){
                if( e != null ) trace(e) else {
                    //	serial.drain(function(e){
                    lastSentColor = color;
                    isSending = false;
                    if( sendBuffer.length > 0 ) {
                        var c = sendBuffer.shift();
                        setColorRGB( c[0], c[1], c[2] );
                    }
                }
            });
        });
	}

    public static function search( allowedDevices : Array<String>, callback : Error->Array<SerialPortInfo>->Void ) {
        SerialPort.list( function(e,infos) {
            if( e != null ) {
                callback( e, null );
            } else {
                var devices = new Array<SerialPortInfo>();
                for( dev in infos ) {
                    var allowed = false;
    				for( allowedDevice in allowedDevices ) {
    					if( dev.serialNumber == allowedDevice ) {
    						allowed = true;
                            break;
    					}
    				}
                    if( allowed ) devices.push( dev );
                }
                callback( null, devices );
            }
        });
    }

}
