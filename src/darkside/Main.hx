package darkside;

import electron.main.BrowserWindow;
import electron.main.IpcMain;
import electron.main.WebContents;
import haxe.Timer;
import js.npm.SerialPort;

class Main {

	static var allowedDevices = [
        {
            vendorId : 0x2341,
            productId : 0x0043,
            //baudRate : _57600,
        },
        {
            vendorId : 0x0403,
            productId : 0x6001,
            //baudRate : _57600,
        },
        {
            vendorId : 0x2341,
            productId : 0x0042
        }
    ];

	static var controllers : Array<Controller>;

	static function searchControllers( callback : Void->Void ) {

		controllers = new Array<Controller>();

		SerialPort.list( function(e,devices) {

			if( e != null ) {
                Sys.println( e );
                Sys.exit( 1 );
            }

			for( dev in devices ) {

                trace(dev);

				var allowed = false;
                for( allowedDevice in allowedDevices ) {
                    if( allowedDevice.vendorId == Std.parseInt( dev.vendorId ) &&
                    allowedDevice.productId == Std.parseInt( dev.productId ) ) {
                        allowed = true;
                        break;
                    }
                }
                if( !allowed ) continue;
                allowed = true;
                for( controller in controllers )
                    if( controller.port == dev.comName ){
                        allowed = false;
                        break;
                    }
                if( !allowed )
                    continue;

				var controller = new Controller( dev.comName, _115200 );
				controllers.push( controller );
			}

			//callback( controllers );
			callback();
		});
	}

	static function main() {

		#if !debug
		electron.CrashReporter.start({
			companyName : "disktree",
			submitURL : "https://github.com/rrreal/dark-side-of-the-monitor"
		});
		#end

		var args = Sys.args();

		searchControllers( function() {

			if( controllers.length == 0 ) {
				Sys.println( 'No controllers found' );
				Sys.exit( 0 );
			}

			for( ctrl in controllers ) {

				ctrl.connect( function(e){

					if( e != null ) {
                        Sys.println( 'Failed to connect controller: $e' );
                        Sys.exit( 1 );
                    }

					Sys.println( 'Controller connected (${ctrl.port})' );
					controllers.push( ctrl );

					/*
					Timer.delay( function() {
						ctrl.setColor( 0, 255, 0 );
						Timer.delay( function() {
							ctrl.disconnect( function(e){
                                if( e != null ) {
                                    trace(e);
                                    Sys.exit(1);
                                } else {
                                    Sys.exit(0);
                                }
                            });
						}, 200 );
					}, 1000 );
					*/
				});
			}
		});

		IpcMain.on( 'asynchronous-message', function(e,a) {
			//trace(e);
			//trace(a);
			//e.sender.send( 'asynchronous-reply', 'pong' );
			var c = a.split( ',' );
			for( ctrl in controllers ) {
				ctrl.setColor( c[0], c[1], c[2] );
			}
		} );

		electron.main.App.on( 'ready', function(e) {

			var win = new BrowserWindow( {
				width: 720, height: 480,
				backgroundColor: '#000',
				show: false
			} );
			win.on( closed, function(e) {
				//if( js.Node.process.platform != 'darwin' ) electron.main.App.quit();
			});
			win.on( ready_to_show, function() {
	            win.show();
	        });
			win.webContents.on( did_finish_load, function() {
	            #if debug
	            win.webContents.openDevTools();
	            #end
			});
			win.loadURL( 'file://' + js.Node.__dirname + '/app.html' );
		});



	}

}
