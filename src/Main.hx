package;

import haxe.io.Bytes;
import sys.FileSystem;
import sys.io.File;
import sys.io.FileInput;

/**
 * ...
 * @author Kaelan 'kevans' Evans
 * 
 * This tool is merely meant to extract the IWAD from the unity versions of Doom that were
 * re-released in 2019. Primarily made since they cary unique assets with minor differences
 * from the original 1993 release. This tool, albeit impossible currently, should not be used
 * for the sake of piracy. Please do not distribute the wads this program extracts, I'm super
 * cereal, please don't.
 */
class Main 
{
	static var default_path:String = "C:/Program Files (x86)/Bethesda.net Launcher/games";
	static var successful_extraction:Bool = false;
	static var d1_is_present:Bool = false;
	static var d2_is_present:Bool = false;
	static var d1_fileinput:FileInput;
	static var d2_fileinput:FileInput;
	static var d1_bytes:Bytes;
	static var d2_bytes:Bytes;
	static var d1_magicstart:Int = 0x1082;
	static var d1_magicend:Int = 0xBE5360;
	static var d2_magicstart:Int = 0x1C4DEF;
	static var d2_magicend:Int = 0x11974A2;
	static var d1_bytearray:Array<Int>;
	static var d2_bytearray:Array<Int>;
	static function main() 
	{
		Sys.println("Unity Doom IWAD ripper");
		Sys.println("Checking default Bethesda games install...");
		
		checkIfGamesAreThere(default_path);
		
		if (successful_extraction) {
			Sys.println("IWADS Extrtacted");
			Sys.command("start", ["output"]);
			Sys.exit(0);
		}
	}
	static function checkIfGamesAreThere(_path:String) {
		Sys.println("Checking for Doom and Doom II...");
		if (FileSystem.exists(_path + "/DOOM_Classic_2019/DOOM_Data/StreamingAssets/doom_disk")) {
			d1_is_present = true;
			d1_fileinput = File.read(_path + "/DOOM_Classic_2019/DOOM_Data/StreamingAssets/doom_disk");
			Sys.println("Ultimate Doom has been found!");
		} else {
			Sys.println("Ultimate Doom is not present.");
		}
		if (FileSystem.exists(_path + "/DOOM_II_Classic_2019/DOOM II_Data/StreamingAssets/doom2_disk")) {
			d2_is_present = true;
			d2_fileinput = File.read(_path + "/DOOM_II_Classic_2019/DOOM II_Data/StreamingAssets/doom2_disk");
			Sys.println("Doom II has been found!");
		} else {
			Sys.println("Doom II is not present.");
		}
		
		if (!d1_is_present && !d2_is_present) {
			Sys.println("Doom games not found, please point me to the install folder!");
			Sys.print(":>");
			var cmd = Sys.stdin().readLine();
			checkIfGamesAreThere(cmd);
			return;
		} else if (d1_is_present || d2_is_present) {
			extract();
		}
	}
	
	static function extract() {
		
		FileSystem.createDirectory("output");
		
		if (d1_is_present) {
			Sys.println("Loading Ultimate Doom...");
			d1_bytes = d1_fileinput.readAll();
			d1_bytearray = new Array();
			for (byte in d1_magicstart...d1_magicend) {
				d1_bytearray.push(d1_bytes.get(byte));
			}
			Sys.println("Ultimate Doom Parsed...");
			Sys.println("Writing Ultimate Doom IWAD...");
			var d1_wad = File.write("./output/DOOM1UNITY.WAD");
			var pos:Int = 0;
			for (byte in d1_bytearray) {
				d1_wad.writeByte(byte);
			}
			d1_wad.close();
			Sys.println("Ultimate Doom Extracted");
			successful_extraction = true;
		}
		
		if (d2_is_present) {
			Sys.println("Loading Doom II...");
			d2_bytes = d2_fileinput.readAll();
			d2_bytearray = new Array();
			for (byte in d2_magicstart...d2_magicend) {
				d2_bytearray.push(d2_bytes.get(byte));
			}
			Sys.println("Doom II Parsed...");
			Sys.println("Writing Doom II IWAD...");
			var d2_wad = File.write("./output/DOOM2UNITY.WAD");
			var pos:Int = 0;
			for (byte in d2_bytearray) {
				d2_wad.writeByte(byte);
			}
			d2_wad.close();
			Sys.println("Doom II Extracted");
			successful_extraction = true;
		}
	}
}