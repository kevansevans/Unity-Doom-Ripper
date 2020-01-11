package;

import haxe.io.Bytes;
import sys.FileSystem;
import sys.io.File;
import sys.io.FileInput;
import sys.io.FileOutput;

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
	static var default_install_path:String = "C:/Program Files (x86)/Bethesda.net Launcher/games";
	static var d1_is_present:Bool = false;
	static var d2_is_present:Bool = false;
	static var d1_fileinput:FileInput;
	static var d2_fileinput:FileInput;
	static var d1_bytes:Bytes;
	static var d2_bytes:Bytes;
	static function main() 
	{
		FileSystem.createDirectory("output");
		
		Sys.println("Unity Doom IWAD ripper");
		Sys.println("Checking default Bethesda games install...");
		
		checkIfGamesAreThere(default_install_path);
		
		checkForAddonFolder();
		
		quit();
	}
	static function checkIfGamesAreThere(_path:String) {
		if (_path.toUpperCase() == "SKIP") {
			return;
		}
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
			Sys.println("Doom games not found, please point me to the install folder! Type 'skip' to ignore this step");
			Sys.print(":>");
			var cmd = Sys.stdin().readLine();
			checkIfGamesAreThere(cmd);
			return;
		} else if (d1_is_present || d2_is_present) {
			extract();
		}
	}
	
	static function extract() {
		
		if (d1_is_present) {
			Sys.println("Loading Ultimate Doom...");
			d1_fileinput.bigEndian = true;
			d1_bytes = d1_fileinput.readAll();
			unityTextAssetReader(d1_bytes);
			Sys.println("Ultimate Doom Extracted");
		}
		
		if (d2_is_present) {
			Sys.println("Loading Doom II...");
			d2_fileinput.bigEndian = true;
			d2_bytes = d2_fileinput.readAll();
			unityTextAssetReader(d2_bytes);
			Sys.println("Doom II Extracted");
		}
		
		Sys.println("WADS Extrtacted");
	}
	
	static function unityTextAssetReader(_data:Bytes) {
		
		var wadname:String = "";
		var wadsize:Int = 0;
		var wadout:FileOutput;
		
		for (byte in 0..._data.length) {
			
			if (byte + 4 >= _data.length) break;
			
			var wadcheck:String = _data.getString(byte, 4);
			var skip = false;
			
			if (wadcheck == ".wad") {
				var pos = byte;
				while (_data.get(pos) != 0x00) {
					--pos;
					if (String.fromCharCode(_data.get(pos)) == "/") {
						skip = true;
						break;
					}
				}
				++pos;
				if (skip) continue;
				
				wadname = _data.getString(pos, (byte - pos));
				
				pos = byte;
				while (_data.getString(pos, 4) != "IWAD" && _data.getString(pos, 4) != "PWAD") {
					++pos;
				}
				wadsize = _data.get(pos - 4) | _data.get(pos - 3) << 8 | _data.get(pos - 2) << 16 | _data.get(pos - 1) << 24;
				
				Sys.println("WAD Found: " + wadname + " @" + wadsize + " bytes");
				
				if (_data.getString(pos, 4) == "IWAD") {
					wadout = File.write("./output/" + wadname.toUpperCase() + "UNITY.WAD");
					wadout.writeBytes(_data, pos, wadsize);
					wadout.close();
				} else if (_data.getString(pos, 4) == "PWAD" || _data.getString(pos, 4) == "PWAD") {
					wadout = File.write("./output/" + wadname.toUpperCase() + ".WAD");
					wadout.writeBytes(_data, pos, wadsize);
					wadout.close();
				}
			} 
		}
	}
	
	
	static function checkForAddonFolder() 
	{
		var d1_addon_path:Null<String> = null;
		var d2_addon_path:Null<String> = null;
		Sys.println("Scanning for addons...");
		var folders:Array<String> = FileSystem.readDirectory("C:/Users");
		for (dir in folders) {
			if (FileSystem.isDirectory("C:/Users/" + dir + "/Saved Games/id Software")) {
				Sys.println("Addon directory found...");
				if (FileSystem.isDirectory("C:/Users/" + dir + "/Saved Games/id Software/DOOM Classic/WADs")) {
					d1_addon_path = "C:/Users/" + dir + "/Saved Games/id Software/DOOM Classic/WADs";
					Sys.println("Ultimate Doom addon directory found");
				}
				if (FileSystem.isDirectory("C:/Users/" + dir + "/Saved Games/id Software/DOOM 2/WADs")) {
					d2_addon_path = "C:/Users/" + dir + "/Saved Games/id Software/DOOM 2/WADs";
					Sys.println("Doom II addon directory found");
				}
				if (d1_addon_path == null && d2_addon_path == null) {
					Sys.println("No addon folders found");
					return;
				} else {
					if (d1_addon_path != null) transfer_addons(d1_addon_path);
					if (d2_addon_path != null) transfer_addons(d2_addon_path);
				}
			}
		}
	}
	
	static function transfer_addons(_path:String) 
	{
		Sys.println("Starting search for addons in " + _path);
		var addons:Array<String>;
		addons = FileSystem.readDirectory(_path);
		var name:String;
		for (dir in addons) {
			var items:Array<String> = FileSystem.readDirectory(_path + "/" + dir);
			var name:String = items[2].substr(0, items[2].length - 5).toUpperCase(); //The preview screenshots seem to reflect the wad names, so we'll rely on that for renaming the wads
			if (FileSystem.exists("./output/" + name + ".WAD") || FileSystem.exists("./output/" + name + "UNITY.WAD")) continue;
			else {
				Sys.println("Transfering " + name);
				if (name.toUpperCase() == "PLUTONIA" || name.toUpperCase() == "TNT") {
					File.copy(_path + "/" + dir + "/" + dir, "./output/" + name.toUpperCase() + "UNITY.WAD");
				} else {
					File.copy(_path + "/" + dir + "/" + dir, "./output/" + name.toUpperCase() + ".WAD");
				}
			}
		}
		Sys.println("Done transfering addons in " + _path);
	}
	static function quit() {
		Sys.println("Program has finished");
		Sys.command("start", ["output"]);
		Sys.exit(0);
	}
}