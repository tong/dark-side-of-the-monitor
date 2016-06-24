package dsotm.cra;

import js.html.ArrayBuffer;
import js.html.Uint8Array;
import js.html.DivElement;
import js.Browser.document;
import js.Browser.window;
import om.util.ArrayBufferUtil;
import chrome.Serial;
import chrome.app.Window;

class App {

	static var controllers : Array<Controller>;

	static function update( time : Float ) {
		window.requestAnimationFrame( update );
		om.Tween.step( time );
	}

	static function handleWindowClose() {
	}

	static function main() {

		Window.onClosed.addListener( handleWindowClose );

		window.onload = function(){

			window.requestAnimationFrame( update );

			controllers = [];

			Serial.getDevices( function(devices:Array<SerialDeviceInfo>){

				if( devices.length == 0 ) {
					document.body.textContent = 'No devices found';
					return;
				}

				for( device in devices ) {

					var connectButton = document.createButtonElement();
					connectButton.textContent = 'CONNECT';
					connectButton.onclick = function(){

						connectButton.remove();

						var controller = new Controller();
						controllers.push( controller );
						controller.connect( device, function(){
							trace("connected");

							controller.setColor( [0,255,0] );

							//controller.sendInt(-1);
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

				/*
				var device = devices[0];

				Serial.connect( device.path, { bitrate: 57600 }, function(info:ConnectionInfo){

					connectionId = info.connectionId;

					Serial.onReceive.addListener( function(r){
						trace( 'ARDUINO: '+ ArrayBufferUtil.ab2str(r.data) );
					} );
				});
				*/

				//trace( devices[0] );

			//	var control = new DeviceControl( devices[0], 0, 64 );
			//	document.body.appendChild( control.element );
			//	control.connect( 115200 );

				/*
				var deviceListElement = document.createDivElement();
				deviceListElement.classList.add( 'device-list' );
				document.body.appendChild( deviceListElement );

				for( device in devices ) {

				var e = document.createDivElement();
				e.textContent = device.path;
				document.body.appendChild( deviceListElement );

				//var control = new DeviceControl( devices[0], 0, 64 );
				//document.body.appendChild( control.element );
				//control.connect( 115200 );
			}
			*/

			});
		}
		}
}
