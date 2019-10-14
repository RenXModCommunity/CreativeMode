Creative Mode (created by Sarah and Cynthia)
=============


### Features

- Spawn Vehicles, Defences (buggy), Characters, Weapons
- God mode, fly mode, walk mode, destroy defences, promote
- CLI commands: Restore destroyed buldings (simple defences not included), toggle spawning for non-admins

## How to build
- Extract Creative Mode files into SDK root. 
- Navigate to the SDK's /UDKGame/Config/ directory, and open DefaultEngineUDK.ini. Navigate to the UnrealEd.EditorEngine section in the file, and at the bottom of the section add: ` +ModEditPackages=Rx_CreativeMode`
- Now you need to compile your mutator. Simply use the compile.bat file in the SDK root
- The compiled mutator will be saved in `UDKGame/Script/`

## How to install 
- Copy directory `UDKGame` into Renegade X root folder, replace existing files if requested. 
- Copy compiled Rx_CreativeMode.u in `UDKGame/CookedPC`
- Run local server or skirmish map with the mutator loaded.
Example: `open CNC-Field?mutator=Rx_CreativeMode.Rx_CreativeMode`

[Original repo here](https://github.com/sevans045/CreativeMode/ "Original repo here")
