package dsotm.cra;

import js.html.DivElement;
import js.Browser.document;
import js.Browser.window;
import chrome.Serial;
import haxe.ds.IntMap;
import om.util.ArrayBufferUtil.*;

class App {

	//static var controllers : Array<Controller>;
	static var controllers : IntMap<Controller>;

	static function update( time : Float ) {
		window.requestAnimationFrame( update );
		//om.Tween.step( time );
	}

	static function handleDeviceInfoUpdate( devices : Array<SerialDeviceInfo> ) {

		trace(devices);

		if( devices.length == 0 ) {
			document.body.textContent = 'No devices found';
			return;
		}

		for( device in devices ) {

			trace(device);

			var connectButton = document.createButtonElement();
			connectButton.textContent = device.displayName +' : '+ device.path;
			connectButton.onclick = function(){

				connectButton.remove();

				var controller = new Controller();
				//controllers.push( controller );
				//controllers.set( controller );
				controller.connect( device, function(){

					trace( 'Serial connected' );

					controllers.set( controller.connectionId, controller );


					haxe.Timer.delay(function(){

						/*
						controller.init( function(){
							trace("I AM FINALKLY READY");
						});
						*/

						controller.setColor( [255,255,255] );

					},3000);


				});

				/*
				var btn = document.createButtonElement();
				btn.textContent = 'Fade';
				btn.onclick = function() {
					controller.setRGB( [0,0,0] );
					var obj = {r:0.0,g:0.0,b:0.0};
					var tween = new om.Tween( obj )
						.to( {r:255,g:255,b:255}, 2000 )
						.easing( om.easing.Cubic.InOut )
						.onUpdate(function(){
							controller.setRGB( [Std.int(obj.r), Std.int(obj.g), Std.int(obj.b)] );
						})
						.onComplete(function(){
							controller.setRGB( [Std.int(obj.r), Std.int(obj.g), Std.int(obj.b)] );
						})
						.start();
				}
				document.body.appendChild(btn);
				*/

				document.body.appendChild( controller.element );
			}
			document.body.appendChild( connectButton );
		}
	}

	static function handleSerialData( info ) {
		trace(info);
		var str = ab2str( info.data );
		trace( str );
		if( !controllers.exists( info.connectionId ) ) {
			trace("NO CONTROLLER FOUND FOR "+info.connectionId );
			return;
		}
		var controller = controllers.get( info.connectionId );
		controller.receive( str );
	}

	static function handleSerialError( info ) {
		trace(info);
		/*
		if( controllers.exists( info.connectionId ) ) {
			var controller = controllers.get( info.connectionId );
			controller.close();
			controllers.remove( controller );
		}
		*/
	}

	static function main() {

		window.onload = function(){

			chrome.Runtime.getBackgroundPage(function(win){

				//var setup = document.getElementById('setup');
				//trace( untyped  w.dsotm.test() );

				controllers = new IntMap();

				Serial.onReceive.addListener( handleSerialData );
				Serial.onReceiveError.addListener( handleSerialError );

				Serial.getDevices( handleDeviceInfoUpdate );
			});

			chrome.app.Window.onClosed.addListener( function(){

			});
		}
	}
}
