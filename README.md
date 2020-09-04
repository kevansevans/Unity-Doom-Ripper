# Unity Doom Ripper

Extracts IWADS and PWADS from the Bethesda.net source ports of classic Doom. Program expects the games to be installed within their default C drive location, but will prompt user if it fails to find the games. Program will then create an "output" folder and dump the IWADS and PWADS there. After, it will scan the addons directory within the user files and copy any found wads into the output directory.

Program is relatively finished as is and serves it's purpose, and no updates are planned (outside of a few minor tweaks potentially). If any environments change or new factors come into play, (Linux/OSX or Steam gets updated), then this program for sure will get updated.

## IMPORTANT!

This program is mostly obsolete now. As of 03SEP2020, the base IWADS of Doom and Doom II are now separate files and no longer need extraction. However, the Master Levels need to still need to be extracted, and the program should still work on earlier versions, which Bethesda allows the user to set to. The Steam version has it's IWADS exposed and can not be set back to an earlier version, so this program is useless for it.

Unity location: ``Bethesda.net Launcher\games\[Doom or Doom 2]_Classic_2019\[Doom or Doom 2]_Data\StreamingAssets``

Steam location: ``SteamLibrary\steamapps\common\[Doom or Doom 2]\rerelease\[Doom or Doom 2]_Data\StreamingAssets``

Unless something really really stupid happens, this program will no longer be updated.

### Compile instructions

Requirements:

* Haxe https://haxe.org/ (recommended latest 4.0.5)
* Haxelib hxcpp ``haxelib install hxcpp``

UDR is only meant for the C++ target, obviously this won't work as a JavaScript program. This was not tested with any other targets that have access to the Sys library.

##### Method 1

* open terminal and run command ``haxe build.hxml`` within the source directory

##### Method 2

* Download Haxedevelop https://haxedevelop.org/
* Open ``Unity Doom Ripper.hxproj``
* hit the compile button

Program will be compiled into a bin directory, along with it's generated C++ files.

```
////////////////////////////////////////////////////////////////////////////////////////////////////
//Haxe code by kevansevans
////////////////////////////////////////////////////////////////////////////////////////////////////
//
//                         ...,,,,,,,,..                     
//                  ./&&%(/**,,,,,,,,,**/%&*               
//              .//,,,,,,,,,,,,,,,,,,,,,,,,/&&/            
//           ./&/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*&&,         
//         .#%*,*#/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#&,       
//        ,@#,,(*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,/&(      
//      .%@*,/#,,,,,,,,,,,,,,,,*((/,,,,,,,,,,,,,,,,,,,##     
//     .&&/,*/,,,,,,,,,,,,,/#/,,,,,,,,,,,,,,,,,,,,,,,,,#&.   
//     %##,*%,,,,,,,,,,,,#(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,%#   
//    ,%(/,#*,,,,,,,,,*#(,,,,,,,,,,,,,,,,,,,*/#%#%,,,,,,*&.  
//    (/#*,#,,,,,,,,,*%,,,,,,,,,,,,,,*/#%#*.    (*,,,,,,,((  
//    &*%**(,,,,,,,,/#,,,,,,,,,,*(&%(%.       /#,,,,,,,,,*%. 
//    &/%**(,,,,,,,/#,,,,,,,*/&%/%(  ,*     ,#/(#,,,,,,,,,&. 
//    ((##*%*******%*******#&&/*(@&**#,    *. (#,,,,,,,,,,&, 
//    .%/&/%/******%*****(&*.%**(@&*/&      *&/,,,,,,,,,,,&. 
//     /%/&/%******%****(#.  ,#****#(     /%**(*,,,,,,,,,*%. 
//      .%(&/%/****%/**/&(/    /%%/      .,#%*%*,,,,,,,,,#*  
//        ,%####***/%**#/   ....      /%/*****%*,,,,,,,,/&.  
//          .(%%/*/%*#*         .(#*.%/*****%,,,,,,,,*&*   
//              #%&@@%#%%#/*/%...#*    *%****(/,,,,,,,*&,    
//             /#*****/(%***#*...#,    (%***/%,,,,,,,(&.     
//          .%%*,,,,*#%&%%%,......*.,&/**/(,,,,,,/%,       
//       (&(((((##(/%%,,,,*%,....../##&/*(#*,,,,*&(.         
//         /%(/***/&/,,,,,,/(......*(#/,,,*(&(,            
//             .,(&,,,,,,,,*%    .*/(*,.                 
//              (#,,,,,**,,,/*    ..,#(#&&&/                 
//             *(,,,,*&/*,,,,%.  #*,,,,***&/                 
//           .#(,,,*%#(%******%(.%*******(&.                 
//           %/,,,/@(//##*******##*******&%#   
////////////////////////////////////////////////////////////////////////////////////////////////////
```
