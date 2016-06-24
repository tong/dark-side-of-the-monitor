package dsotm.node;

import js.Error;
import js.Node.process;
import js.node.Buffer;
import js.html.ArrayBuffer;
import js.html.Uint8Array;
import js.npm.SerialPort;
import om.color.space.RGB;
import om.util.ArrayBufferUtil.*;

class Controller {

	var serial : SerialPort;

	public function new() {}

	public function connect( port : String, baudrate : BaudRate, callback : Error->Void ) {
		serial = new SerialPort( port, { baudrate: baudrate, autoOpen: false }, false );
		serial.on( 'error', function(e) trace(e) );
		serial.open( function(e){
			serial.on( 'disconnect', function(e) trace(e) );
			serial.on( 'close', function(e) {
				//trace( "closed"+e );
				//process.exit(0);
			});
			serial.on( 'data', function(buf){

				//trace(buf.toString());
				trace( "dATA ");

				var cmd : Int = buf.readInt8();
				trace("CMD:"+cmd);
				if( cmd == 0 ) {
					//callback( null );
				}

			});

			callback( null );
		});
	}

	public function disconnect( ?callback : Error->Void ) {
		if( serial != null ) {
			serial.close( callback );
		}
	}

	public function setColor( color : RGB, ?callback : Void->Void ) {
		var buf = new ArrayBuffer(4);
		var view = new Uint8Array( buf );
		view.set( [0,color.r,color.g,color.b], 0 );
		serial.write( new Buffer( buf ), function(e){
			if( callback != null ) callback();
			/*
			serial.flush(function(e){
				serial.drain(function(e){
					trace( "DRAIN"+e );
					if( callback != null ) callback();
				});
			});
			*/
		});
	}

	/*
	public function getColor( ?callback : RGB->Void ) {
	}
	*/

	public static function findDevices( callback : Error->Array<SerialPortInfo>->Void ) {
		SerialPort.list(function(e,devices){
			if( e != null ) callback( e, null ) else {
				var lights = new Array<SerialPortInfo>();
				for( device in devices ) {
					if( device.manufacturer != null && device.manufacturer.indexOf( 'Arduino' ) != -1 ) {
						lights.push( device );
					}
				}
				callback( null, lights );
			}
		});
	}

}
