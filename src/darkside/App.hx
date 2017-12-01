package darkside;

import darkside.gui.ColorPicker;
import electron.renderer.IpcRenderer;
//import om.Tween;
import om.ease.*;

class App {

	static var timeStart : Float;
	static var timer : Timer;
	static var buffer : Array<Int>;
	static var index = 0;

	static function update() {

		/*
		if( ++index >= 256 ) index = 0;
		var rgb = ColorUtil.wheel( index );
		rgb.push(255);
		buffer = rgb;
		*/

		//var elapsed = Time.now() - timeStart;

		if( buffer != null ) {
			var msg = Json.stringify( { type: 'setColor', value: buffer } );
			IpcRenderer.send( 'asynchronous-message', msg );
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

		var fps = 90;

		var element = document.querySelector( '.darkside' );

		var info = document.createDivElement();
		info.classList.add( 'info' );
		info.textContent = 'DARKSIDE';
		element.appendChild( info );

		var picker = new ColorPicker( Std.int( window.innerWidth - 20 ), Std.int( window.innerHeight - 20 ) );
		picker.onSelect = function(c) buffer = c;
		element.appendChild( picker.element );

		//var html = haxe.Resource.getString( 'colorpicker.html' );
		//element.innerHTML = html;

		//var color = document.createInputElement();
		//color.type = 'color';
		//element.appendChild( color );

		Timer.delay( function(){
			timer = new Timer( Std.int( 1000/fps ) );
			timer.run = update;
		}, 500 );

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
