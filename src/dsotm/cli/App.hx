package dsotm.cli;

import Sys.println;
import sys.io.File;
import js.html.ArrayBuffer;
import js.html.Uint8Array;
import js.node.Buffer;
import js.npm.SerialPort;
import dsotm.node.Controller;
import om.color.space.RGB;
import haxe.Timer.delay;

@:require(nodejs)
class App {

	static var CONTROLLER = {
		vendorId: 0x1a86,
		productId: 0x7523
	}

	static var controller : Controller;

	static function error( msg : Dynamic, code = 1 ) {
		Sys.println( msg );
		Sys.exit( code );
	}

	static function main() {

		//var args = process.argv;
		//args.shift(); // node
		//args.shift(); // samba.js

		var args = Sys.args();
		var color = [255,255,255];
		if( args[0] != null ) {
			color = om.util.ColorUtil.hexToRGB( args[0] );
		}

		//trace(color);
		//var color = [255,255,255];
		//var palette = om.format.GimpPalette.parse( File.getContent('/home/tong/dev/lib/om.color/res/color/adapta.gpl') );
		//var colors = palette.colors;
		//var colors = [0xff0000,0x00ff00,0x0000ff,0xfff000,0x00ffff];
		//trace(colors);

		/*
		js.node.Http.createServer(function(req,res){

			trace(Reflect.fields(req));

			if( req.method == Post ) {

				req.on( 'data', function(chunk){
					var str = chunk.toString();
					var rgb : RGB = str;
					trace(str);
					trace(rgb);
				});


				res.writeHead( 200, {
					'Content-Type': 'text/plain',
					'Access-Control-Allow-Origin': '*'
				});
				res.end( 'Hello World\n' );
			}


		}).listen( 7020 );
		*/

		/*
		var server = new dsotm.net.WebServer( 'localhost', 7020 );
		server.start(function(rgb){
			trace(rgb);
			controller.setColor( rgb );
		});
		*/

		SerialPort.list( function(e,devices) {

			//trace(devices);

			if( e != null ) println(e) else {

				for( device in devices ) {

					//trace(device);

					//if( device.manufacturer.indexOf( 'Arduino' ) != -1 ) {
					if( Std.parseInt( device.vendorId ) == CONTROLLER.vendorId &&
						Std.parseInt( device.productId ) == CONTROLLER.productId ) {

						//trace("CONECCTING");
						trace(device);

						controller = new Controller();
						controller.connect( device.comName, _115200, function(e){

							trace("connected");
							delay( function(){
								controller.setColor( color, function(){
									trace("set.");
									controller.disconnect(function(e){
										js.Node.process.exit(0);
									});

								});
							}, 2000 );

							/*
							haxe.Timer.delay(function(){
								controller.setColor( color, function(){

									controller.disconnect(function(e){
										js.Node.process.exit(0);
									});

								});
							}, 200 );
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

						break;
					}

				}
			}
		});
	}

}
