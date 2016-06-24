package dsotm.gui;

import js.Browser.document;
import js.html.DivElement;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;

class ColorPicker {

	public dynamic function onSelect( color : Array<Int> ) {}

	public var element(default,null) : DivElement;

	public var value(get,set) : String;
	inline function get_value() : String return _value;
	function set_value(v:String) : String {
		return _value = v;
	}

	var _value : String;
	var canvas : CanvasElement;
	var context : CanvasRenderingContext2D;
	var marker : DivElement;

	public function new( width : Int, height : Int, color = '#000000' ) {

		//this.color = color;

		element = document.createDivElement();

		canvas = document.createCanvasElement();
		canvas.width = width;
		canvas.height = height;
		element.appendChild( canvas );

		//marker = document.createDivElement();
		//marker.style.position = 'absolute';
		//element.appendChild( marker );

		context = canvas.getContext2d();

		drawColorArea();

		canvas.addEventListener( 'mousedown', handleMouseDown, false );
		canvas.addEventListener( 'mouseup', handleMouseUp, false );
		canvas.addEventListener( 'mouseout', handleMouseOut, false );
	}

	public function show() {
		element.style.display = 'inline-block';
	}

	public function hide() {
		element.style.display = 'none';
	}

	public function getColorAtPosition( x : Int, y : Int ) : Array<Int> {
		return untyped Array.from( context.getImageData( x, y, 1, 1 ).data );
	}

	function drawColorArea() {

		var gradient = context.createLinearGradient( 0, 0, canvas.width, 0 );
		gradient.addColorStop( 0,    "rgb(255,   0,   0)" );
		gradient.addColorStop( 0.15, "rgb(255,   0, 255)" );
		gradient.addColorStop( 0.33, "rgb(0,     0, 255)" );
		gradient.addColorStop( 0.49, "rgb(0,   255, 255)" );
		gradient.addColorStop( 0.67, "rgb(0,   255,   0)" );
		gradient.addColorStop( 0.84, "rgb(255, 255,   0)" );
		gradient.addColorStop( 1,    "rgb(255,   0,   0)" );

		context.fillStyle = gradient;
		context.fillRect( 0, 0, canvas.width, canvas.height );

		// Create semi transparent gradient (white -> trans. -> black)
		gradient = context.createLinearGradient( 0, 0, 0, canvas.height );
		gradient.addColorStop( 0,   "rgba(255, 255, 255, 1)" );
		gradient.addColorStop( 0.5, "rgba(255, 255, 255, 0)" );
		gradient.addColorStop( 0.5, "rgba(0,     0,   0, 0)" );
		gradient.addColorStop( 1,   "rgba(0,     0,   0, 1)" );

		// Apply gradient to canvas
		context.fillStyle = gradient;
		context.fillRect( 0, 0, canvas.width, canvas.height );
	}

	function handleMouseDown(e) {
		//trace(e.offsetX);
		canvas.addEventListener( 'mousemove', handleMouseMove, false );
		var color = getColorAtPosition( e.offsetX, e.offsetY );
		onSelect( color );
	}

	function handleMouseMove(e) {
		onSelect( getColorAtPosition( e.offsetX, e.offsetY ) );
	}

	function handleMouseOut(e) {
		canvas.removeEventListener( 'mousemove', handleMouseMove );
	}

	function handleMouseUp(e) {
		canvas.removeEventListener( 'mousemove', handleMouseMove );
	}
}
