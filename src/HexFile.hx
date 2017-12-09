package;
import haxe.Int32;

/**
 * ...
 * @author Lerc
 */
using StringTools;

typedef DataRange = {
	var address: Int32;
	var data : Array<Int>;
}
class HexFile
{
  public var data : List <DataRange> = new List<DataRange>();
	public var startAddress : Int32 = 0;
	
	public function new(code : String) 
	{
		 decode(code);
	}


	inline function decodeHex(text : String, size: Int, startIndex : Int = 0) {
		var t = "0x" + text.substr(startIndex, size);
		return Std.parseInt(t);
	}

	inline function decodeByte(text : String, startIndex : Int = 0) {
		return decodeHex(text, 2, startIndex);
	}
	
	inline function decodeWord(text : String, startIndex : Int = 0) {
		return decodeHex(text, 4, startIndex);
	}
	
	public function decode(code : String)  {
		var regex = ~/\n/gm;
		var lines = regex.split(code);
		
		var baseAddress : Int32 = 0x00000000;	
		var segmentAddress : Int32 = 0x000000;	
		
		for (line in lines) {
			if (line.startsWith(":")) {
				if (line.length >= 9) {
					var recordType = decodeByte(line, 7);
					var byteCount = decodeByte(line, 1); 
					var address = decodeWord(line, 3); 
					
					if (line.length < 11 + byteCount * 2) {
						return;  /// bail because line too short
					}
					var dataStart = 9;
					
					if (recordType != 0) baseAddress = 0;
					
					switch (recordType) {
						case 0:  //data
							
							var range = {
								"address" : baseAddress + segmentAddress + address,
								"data" : [for (i in 0...byteCount) decodeByte(line, dataStart + i * 2)]
							};
							data.add(range);	
							
						case 1: //eof
							return; //probably need some sort of success/fail reporting :-)
							
						case 2: // extended segment address
							segmentAddress = (decodeWord(line, dataStart) << 4);
							
						case 3: // start segment address
							startAddress = (decodeWord(line, dataStart) << 4) + decodeWord(line, dataStart + 4);							
							
						case 4: // extended linear address							
							segmentAddress = 0; 
							baseAddress = (decodeWord(line, dataStart) << 16);
							
						case 5: // start linear address
							startAddress = (decodeWord(line, dataStart) << 16) + decodeWord(line, dataStart + 4);
							
					}
				}
			}
		}
	}
}