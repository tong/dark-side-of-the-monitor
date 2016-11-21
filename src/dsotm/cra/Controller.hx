package dsotm.cra;

import js.Browser.document;
import js.Browser.document;
import js.html.ArrayBuffer;
import js.html.DivElement;
import js.html.ButtonElement;
import js.html.Uint8Array;
import dsotm.gui.ColorPicker;
import chrome.Serial;
import om.color.space.RGB;
import om.util.ArrayBufferUtil.*;

class Controller {

	public var connected(get,null) = false;
	inline function get_connected() : Bool return connectionId != null;

	public var ready(default,null) = false;
	public var connectionId(default,null) : Int;
	public var element(default,null) : DivElement;

	var button : ButtonElement;
	var hexValue : DivElement;
	var colorPicker : ColorPicker;

	//var ready = false;
	var onReady : Void->Void;

	public function new() {

		element = document.createDivElement();

		hexValue = document.createDivElement();
		hexValue.textContent = 'CONNECTING ...';
		element.appendChild( hexValue );

		colorPicker = new ColorPicker();
		colorPicker.onSelect = function(color:Array<Int>){
			setColor( color );
		}
		element.appendChild( colorPicker.element );
	}

	public function connect( device : SerialDeviceInfo, bitrate = 115200, callback : Void->Void ) {

		if( !connected ) {

			Serial.connect( device.path, { bitrate: bitrate }, function(info:ConnectionInfo){

				connectionId = info.connectionId;

				hexValue.textContent = 'SERIAL CONNECTED; WAITING FOR READY SIGNAL';

				callback();

				/*
				haxe.Timer.delay(function(){
					writeIntArray( [3], function(){
						hexValue.textContent = 'READY';
						callback();
					});
				}, 3000 );
				*/

				/*
				Serial.onReceive.addListener( function(r){
					var str = ab2str( r.data );
					trace( str );
					if( !ready ) {
						if( str != 'READY' ) {
							trace("SOULD BE: READY but is not");
						} else {
							ready = true;
						}
					}
				});

				Serial.onReceiveError.addListener( handleError );
				*/

				//callback();

				/*
				trace("IIIIINIT....");
				haxe.Timer.delay(function(){
					//controller.setColor( [0,0,255] );
					trace("wwwwwwrite init");
					writeIntArray( [3] );
				},3000);
				//trace("IIIIINIT2");
				*/

			});
		}
	}

	/*
	public function init( callback : Void->Void ) {
		writeIntArray( [3], function(){
			onReady = callback;
		});
	}
	*/

	public function receive( str : String ) {
		trace(str);
		/*
		if( !ready ) {
			if( str == 'READY' ) {
				trace("YOYOYOYO IAM REAAAAAAAAAAAADY");
				ready = true;
			}
		}
		*/
	}

	public function setColor( rgb : RGB ) {

		//trace( 'setColor '+color.r+":"+color.g+":"+color.b );

		var buf = new ArrayBuffer(4);
		var view = new Uint8Array( buf );
		view.set( [0,rgb.r,rgb.g,rgb.b], 0 );
		Serial.send( connectionId, buf, function(r){
			//trace(r);
			hexValue.textContent = rgb.toString() +' '+ rgb.toCSS3();
		});

		/*
		var str = color.toArray().join(',');
		Serial.send( connectionId, str2ab( str ), function(r){
			trace(r);
		});
		*/

		/*
		var str = color.toArray().join(',')+',';

		Serial.send( connectionId, str2ab( str ), function(r){

		});
		*/

		/*
		var buf = new ArrayBuffer(1);
		var view = new Uint8Array( buf );
		view[0] = '\n'.code;
		Serial.send( connectionId, buf, function(r){

		});
		*/

		/*
		var buf = new ArrayBuffer(4);
		var view = new Uint8Array( buf );
		view[0] = color.r;
		view[1] = color.g;
		view[2] = color.b;
		view[3] = '\n'.code;
		//var buf = str2ab( 'c:'+color.toArray().join(',') );
		///var buf = str2ab( color.toArray().join(':')+ );
		Serial.send( connectionId, buf, function(r){

		});
		*/

		/*
		var buf = new ArrayBuffer( 1 );
		var view = new js.html.Int32Array( buf );
		//for( i in 0...arr.length ) view[i] = arr[i];
		view[0] = (color.r<<16) | (color.g<<8) | color.b;
		Serial.send( connectionId, buf, function(e){
		});
		*/

		//sendIntArray( [color.r,color.g,color.b] );
		//var i : Int = color;
		//sendInt( i );
		/*
		sendIntArray( color );
		*/
	}

	function writeIntArray( arr : Array<Int>, ?callback : Void->Void ) {
		var buf = new ArrayBuffer( arr.length );
		var view = new Uint8Array( buf );
		view.set( arr, 0 );
		write( buf, callback );
	}

	function write( buf : ArrayBuffer, ?callback : Void->Void ) {
		Serial.send( connectionId, buf, function(r){
			if( callback != null ) callback();
			//trace(r);
			//hexValue.textContent = rgb.toString() +' '+ rgb.toCSS3();
		});
	}

	/*
	function sendIntArray( arr : Array<Int> ) {
		var buf = new ArrayBuffer( arr.length );
		var view = new Uint8Array( buf );
		for( i in 0...arr.length ) view[i] = arr[i];
		Serial.send( connectionId, buf, function(e){
		});
	}

	public function sendInt( i : Int, ?callback : Void->Void ) {
		var buf = new ArrayBuffer(1);
		var view = new Uint8Array( buf );
		view[0] = i;
		Serial.send( connectionId, buf, function(e){
			if( callback != null ) callback();
		});
	}

	function sendString( str : String ) {
		Serial.send( connectionId, str2ab( str ) , function(e){
		});
	}
	*/

	function handleError( e ) {
		trace(e);
	}
}
