package darkside;

import darkside.gui.ColorPicker;
import electron.renderer.IpcRenderer;
//import om.Tween;
import om.ease.*;

//class App implements om.App {
class App{

	static var timeStart : Float;
	static var timer : Timer;
	static var buffer : Array<Int>;
	static var index = 0;

	static function update() {


	/*
		index++;
		if( index == 256 ) index = 0;
		var rgb = ColorUtil.wheel( index );
		buffer = rgb;
		*/

		//var elapsed = Time.now() - timeStart;

		if( buffer != null ) {
			IpcRenderer.send( 'asynchronous-message', Json.stringify( { type: 'setColor', value: buffer } ) );
			buffer = null;
		}
	}

	static function main() {

		IpcRenderer.on( 'asynchronous-reply', function(e,a) {
			trace(e,a);
		});

		IpcRenderer.on( 'color', function(e,m) {
			trace(e,m);
		});

		var fps = 100;
		var picker = new ColorPicker( window.innerWidth, window.innerHeight );
		picker.onSelect = function(c){
			buffer = c;
		}
		document.body.appendChild( picker.element );

		timeStart = Time.now();

		timer = new Timer( Std.int( 1000 / fps ) );
		timer.run = update;

		/*
		var obj = { v:0 };
		var tween = new Tween( obj )
			.to( { v:255 }, 2000 )
			.delay( 2500 )
			.easing( Bounce.Out )
			.onUpdate( function(){
				next = [obj.v,obj.v,obj.v];
			} )
			.start();
			*/


	}

}
