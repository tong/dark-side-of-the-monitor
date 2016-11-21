package dsotm.cra;

import chrome.Storage;
import chrome.app.Runtime;
import chrome.app.Window;
import chrome.system.Display;

class Background {


	/*
	static var connectionId : Int;

	static function sendByte( byte : Int ) {
		var buf = new ArrayBuffer( 1 );
		var view = new Uint8Array( buf );
		view[0] = byte;
		Serial.send( connectionId, buf, function(r){
			Serial.flush( connectionId, function(e){} );
		});
	}

	static function sendString( str : String ) {
		Serial.send( connectionId, str2ab( str ), function(r){
			Serial.flush( connectionId, function(e){} );
		});
	}

	static function handleData( info : {connectionId:Int,data:ArrayBuffer} ) {
		if( info.connectionId == connectionId && info.data != null ) {
			var view = new Uint8Array( info.data );
			trace(view[0]);
			switch view[0] {
			case 0:
				trace(">>>");
				Timer.delay(function(){
					trace(Std.int(Math.random()*255));
				}, 1000 );
			case 1:
			}
		}
	}

	static function handleDeviceConnect( info : ConnectionInfo ) {
		connectionId = info.connectionId;
		trace( 'Connected (id=$connectionId)' );
		//Serial.onReceive.addListener( handleData );
		Timer.delay(function(){
			//sendByte(7);
			sendString("3");
			}, 2000 );
		}
		*/

	public static function test() {
		return "darkness";
	}

	public function connect() {
		return new js.Promise( function(resolve,reject){
		});
	}

	public function disconnect() {
	}

	static function main() {

		Runtime.onLaunched.addListener( function(?e) {

			untyped window.backlight = Background;

			Window.create( 'app.html',
				{
					//alwaysOnTop: true,
					//visibleOnAllWorkspaces: true,
					//state: fullscreen,
					//bounds: display.bounds,
					//outerBounds: {
						//width: 400,
						//height: 500
					//}
				},
				function( win : AppWindow ) {
					win.contentWindow.addEventListener( 'resize', function(e){

					}, false );
				}
			);
        });
	}

}
