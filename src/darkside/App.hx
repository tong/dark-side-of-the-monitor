package darkside;

import electron.renderer.IpcRenderer;
import js.Browser.document;
import darkside.gui.ColorPicker;

class App implements om.App {

	static var picker : ColorPicker;

	static function main() {

        trace( 'DARKSIDE' );

		/*
		IpcRenderer.send( 'asynchronous-message', 'ping');
		IpcRenderer.on( 'asynchronous-reply', function(e,a){
			trace(e);
			trace(a);
		} );
		*/

		picker = new ColorPicker();
		picker.onSelect = function(c){
			IpcRenderer.send( 'asynchronous-message', c.join( ',' ) );
		}
		document.body.appendChild( picker.element );

	}

}
