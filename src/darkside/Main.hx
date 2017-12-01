package darkside;

import electron.main.BrowserWindow;
import electron.main.IpcMain;
import electron.main.WebContents;
import hxargs.Args;
import js.node.Fs;
import js.node.Http;

@:require(electron)
class Main {

	static var web : js.node.http.Server;
	static var win : BrowserWindow;
	static var color : Int;

	static var allowedDevices = [
		'74034313938351717211' // Arduino Mega
	];

	static var controllers : Array<Controller>;

	static function updateControllers( ?callback : Error->Void ) {
		Controller.search( allowedDevices, function(e,devices){
			if( e != null ) callback( e ) else {
				for( dev in devices ) {
					var already = false;
					for( controller in controllers ) {
						if( controller.port == dev.comName ){
	                        already = true;
	                        break;
	                    }
					}
					if( !already ) {
						var controller = new Controller( dev.comName, 115200 );
						controllers.push( controller );
					}
				}
				callback( null );
			}
		});
	}

	static function openWindow() {
		if( win != null )
			return;

		win = new BrowserWindow( {
			width: 320, height: 480,
			//frame: false,
			//useContentSize: true,
			backgroundColor: '#101010',
			show: false,
			frame: false,
		} );
		win.on( closed, function() {
			win = null;
			//if( js.Node.process.platform != 'darwin' ) electron.main.App.quit();
		});
		win.on( ready_to_show, function() {
			win.setMenu( null );
			win.show();
		});
		win.webContents.on( did_finish_load, function() {
			#if debug
			//win.webContents.openDevTools();
			#end
			//win.webContents.send( 'ping', 'whoooooooh!' );
		});
		win.loadURL( 'file://' + js.Node.__dirname + '/app.html' );

		//trace(win.webContents);
	}

	static function main() {

		Sys.println( '\x1B[41m \x1B[42m \x1B[44m \x1B[0m' );

		#if !debug
		electron.CrashReporter.start({
			companyName : "disktree",
			submitURL : "https://github.com/rrreal/dark-side-of-the-monitor"
		});
		#end

		color = 0xffffff;

		var gui = false;

		var argHandler : ArgHandler;

		function usage() {
			println( 'Usage : darkside [-g]' );
			var doc = argHandler.getDoc();
			var lines = doc.split('\n').map( l -> return '  $l' );
			println( lines.join( '\n' ) );
		}

		argHandler = hxargs.Args.generate([

			@doc("initial color")
			["-c","--color"] => function(color:String) {
				//TODO check input format
				if( !color.startsWith('0x') ) color = '0x'+color; //color.substr(2);
				var i = try Std.parseInt( color ) catch(e:Dynamic) {
					trace(e);
					return;
				}
				Main.color = i;
			},

			/*
			@doc("")
			["-q","--quiet"] => () -> {
			},

			@doc("provide web interface")
			["-w","--web"] => (port:Int,host:String) -> {
			},
			*/

			@doc("open graphical user interface")
			["-g","--gui"] => () -> gui = true,

			@doc("show help")
			["-h","--help"] => () -> {
				usage();
				Sys.exit(0);
			},

			_ => (arg:String) -> {
				println( 'Unknown command: $arg' );
				Sys.exit(1);
			}
		]);
		argHandler.parse( Sys.args() );

		controllers = [];

		electron.main.App.on( 'ready', function(e) {
			if( gui ) {
				openWindow();
			}
		});

		updateControllers( function(e){
			if( e != null ) {
				Sys.println( 'ERROR: '+e );
				Sys.exit(1);
			} else {
				for( ctrl in controllers ) {
					println( 'Connecting to '+ctrl );
					ctrl.connect( function(e){
						if( e != null ) {
							println( e );
						} else {
							Timer.delay( function(){
								ctrl.setColor( color );
							}, 500 );

						}
					});
				}
			}
		});

		IpcMain.on( 'asynchronous-message', function(e,a) {
			var msg = Json.parse(a);
			//trace(msg);
			switch msg.type {
			case 'setColor':
				var rgb = msg.value;
				//trace(rgb);
				for( ctrl in controllers ) {
					if( !ctrl.connected )
						continue;
					ctrl.setColorRGB( rgb[0], rgb[1], rgb[2] );
				}
			}

			//trace(a);
			//e.sender.send( 'asynchronous-reply', 'pong' );

			/*
			var c = a.split( ',' );
			for( ctrl in controllers ) {
				ctrl.setColorRGB( c[0], c[1], c[2] );
			}
			*/
		} );

		/// Readline
		/*
		var rl = js.node.Readline.createInterface({
			input: process.stdin,
			output: process.stdout,
			prompt: 'DARKSIDE> '
		});
		rl.on( 'line', line -> {
			trace(line);
		});
		rl.prompt();
		*/

		/// Read from named pipe
		/*
		var pipe = Fs.createReadStream( 'pipe' );
		pipe.on( 'data', function(buf){
			trace(buf.toString());
		} );
		*/

		/*
		web = js.node.Http.createServer( (req,res) -> {
			res.writeHead( 200, {'Content-Type': 'text/plain'} );
            res.end( 'Hello World\n' );
		});
		web.listen( 1100, '127.0.0.1' );
		*/
	}

}
