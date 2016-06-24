package dsotm.cra;

import js.Browser.document;
import js.Browser.document;
import js.html.ArrayBuffer;
import js.html.DivElement;
import js.html.Uint8Array;
import dsotm.gui.ColorPicker;
import chrome.Serial;
import om.color.space.RGB;
import om.util.ArrayBufferUtil.*;

class Controller {

	public var connected(get,null) = false;
	inline function get_connected() : Bool return connectionId != null;

	public var element(default,null) : DivElement;

	var colorPicker : ColorPicker;
	var connectionId : Int;

	public function new() {

		element = document.createDivElement();

		colorPicker = new ColorPicker( 200, 200 );
		colorPicker.onSelect = function(color:Array<Int>){
			setColor( color );
		}
		element.appendChild( colorPicker.element );
	}

	public function connect( device : SerialDeviceInfo, bitrate = 115200, callback : Void->Void ) {

		if( !connected ) {

			Serial.connect( device.path, { bitrate: bitrate }, function(info:ConnectionInfo){

				connectionId = info.connectionId;

				Serial.onReceive.addListener( handleData );
				Serial.onReceiveError.addListener( handleError );

				callback();
			});
		}
	}

	public function setColor( color : RGB ) {

		//trace( 'setColor '+color.r+":"+color.g+":"+color.b );

		var buf = new ArrayBuffer(4);
		var view = new Uint8Array( buf );
		view.set( [0,color.r,color.g,color.b], 0 );
		Serial.send( connectionId, buf, function(r){
			trace(r);
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

	function handleData( r ) {

		trace( ab2str( r.data ) );

		/*
		var view = new js.html.Uint8Array( r.data );
		trace( view.get(0) );
		trace( view.get(0) );
		var i = new haxe.io.BytesInput( haxe.io.Bytes.ofData(r.data) );
		var rgb = new RGB( i.readInt32() );
		trace( rgb );
		*/

	}


}
