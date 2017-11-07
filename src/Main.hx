package ;

import haxe.Timer;
import js.Browser;


/**
 * ...
 * @author Lerc
 */

class Main 
{
	static function main() 
	{
		Browser.document.addEventListener("DOMContentLoaded", function(e) {
			var emulator : EmulatortHost;
			emulator  = new EmulatortHost();
		});
	}
	
	
}