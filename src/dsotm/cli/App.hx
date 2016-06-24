package dsotm.cli;

import Sys.println;
import sys.io.File;
import js.html.ArrayBuffer;
import js.html.Uint8Array;
import js.node.Buffer;
import js.npm.SerialPort;
import dsotm.node.Controller;

class App {

	static function error( msg : Dynamic, code = 1 ) {
		Sys.println( msg );
		Sys.exit( code );
	}

	static function main() {

		//var args = process.argv;
		//args.shift(); // node
		//args.shift(); // samba.js

		var args = Sys.args();
		var color : Array<Int> = null; // = [255,255,255];
		if( args[0] != null ) {
			color = om.util.ColorUtil.hexToRGB( args[0] );
			//trace(color);
		}

		//var color = [255,255,255];
		//var palette = om.format.GimpPalette.parse( File.getContent('/home/tong/dev/lib/om.color/res/color/adapta.gpl') );
		//var colors = palette.colors;
		//var colors = [0xff0000,0x00ff00,0x0000ff,0xfff000,0x00ffff];
		//trace(colors);

		SerialPort.list( function(e,devices) {

			if( e != null ) println(e) else {

				for( device in devices ) {

					if( device.manufacturer.indexOf( 'Arduino' ) != -1 ) {

						//trace(device);

						var controller = new Controller();
						controller.connect( device.comName, _115200, function(e){

							//controller.setColor( color, function(){});
							/*
							haxe.Timer.delay(function(){
								controller.setColor( color, function(){
									/*
									controller.disconnect(function(e){
										js.Node.process.exit(0);
									});
								});
							}, 3000 );
							*/

							/*
							var timer = new haxe.Timer(100);
							var colorIndex = 0;
							timer.run = function(){
								colorIndex++;
								if( colorIndex > colors.length ) {
										colorIndex = 0;
								}

								var c = colors[colorIndex];

								controller.setColor( c, function(){
									//controller.disconnect();
								});
							}
							*/

						});
					}
				}
			}
		});
	}

}
