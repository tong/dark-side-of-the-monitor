
import haxe.Json;
import haxe.Timer;
import haxe.ds.Option;
import js.Error;
import js.html.ArrayBuffer;
import js.html.Uint8Array;
import om.Time;

#if nodejs
import js.Node.process;
import js.node.Buffer;
import Sys.print;
import Sys.println;
#end

#if electron_renderer
import js.Browser.console;
import js.Browser.document;
import js.Browser.window;
#end

using om.StringTools;
