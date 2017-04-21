package darkside;

import haxe.Timer;
import js.Error;
import js.html.Uint8Array;
import js.html.ArrayBuffer;
import js.node.Buffer;
import js.npm.SerialPort;
import Sys.println;

class Controller {

    public var port(default,null) : String;
    public var baudrate(default,null) : BaudRate;
    //inline function get_port() return serial.port;
    //public var brightness(get,set) : Int;

    var serial : SerialPort;
    var lastSentColor : Int;

    public function new( port : String, baudrate : BaudRate ) {
        this.port = port;
        this.baudrate = baudrate;
    }

	public function connect( callback : Error->Void, firstByteDelay = 500 ) {

        serial = new SerialPort( port, { baudrate: baudrate, autoOpen: false } );
		serial.on( 'error', function(e) trace(e) );
        serial.on( 'disconnect', function(e) trace(e) );
		serial.open( function(e){

            trace( 'Serialport connected' );

			serial.on( 'close', function(e) {
				//trace( "closed"+e );
				//process.exit(0);
			});
			serial.on( 'data', function(buf){
                trace(buf.toString());
                /*
                var result = buf.readInt8();
                trace(result);
                switch result {
                case -1: //error
                case 0:
                    //callback( null );
                }
                */
			});

            Timer.delay( function() {

                /*
                var buf = new Buffer(1);
                buf.writeInt8( 3, 0 );
                //buf.writeInt8( 2, 1 );
                //buf.writeInt8( 6, 2 );
                serial.write( buf );
                */

                /*
                trace(">>>>");

                var buf = new ArrayBuffer(1);
                var view = new Uint8Array( buf );
                view.set( [255], 0 );
                serial.write( new Buffer( buf ), function(e) {
                    if( e != null ) trace( 'Failed to write: '+e )
                    else
                        trace('Changed color');
                });
                */

                callback( null );

            }, firstByteDelay );
		});
	}

	public function disconnect( ?callback : Error->Void ) {
		if( serial != null ) {
			serial.close( callback );
		}
	}

    /*
    public function getBrightness() : Int {
    }

    public function setBrightness( brightness : Int ) {
    }
    */

    public function setColor( r : Int, g : Int, b : Int, ?callback : Void->Void ) {

        /*
		if( lastSentColor != null && color == lastSentColor )
			return;

		var buf = new ArrayBuffer(4);
		var view = new Uint8Array( buf );
		view.set( [0,color.r,color.g,color.b], 0 );
		serial.write( new Buffer( buf ), function(e){
			lastSentColor = color;
			if( callback != null ) callback();
			/*
			serial.flush(function(e){
				serial.drain(function(e){
					trace( "DRAIN"+e );
					if( callback != null ) callback();
				});
			});
		});
        */

        /*
        var buf = new ArrayBuffer( 3 );
        var view = new Uint8Array( buf );
        view.set( [color], 0 );
        serial.write( new Buffer( buf ), function(e){
            trace(e);
        });
        */

        var buf = new ArrayBuffer( 3 );
        var view = new Uint8Array( buf );
        view.set( [r,g,b], 0 );
        serial.write( new Buffer( buf ), function(e){
            if( e != null ) trace(e);
        });


        /*
        var buf = new ArrayBuffer(4);
        var view = new js.html.Uint32Array( buf );
        view.set( [color], 0 );
        serial.write( new Buffer( buf ), function(e){
            if( e != null ) trace(e);
        });
        */

        /*
        var buf = new ArrayBuffer(1);
        var view = new Uint8Array( buf );
        view.set( [color], 0 );
        serial.write( new Buffer( buf ), function(e){
            trace(e);
        });
        */
	}
}
