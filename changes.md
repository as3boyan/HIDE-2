0.3.3
-----------

* Use jQueryExtern and nodejs from haxelib(instead of local copies)
* Source: Autoformat(uses haxeprinter to format code)
* hxml project management changes: from now, HIDE will not import hxml data to project arguments, it will create reference to them instead
* Override Project: Build command if currently active document matches hxml file extension, added Project: Set hxml as project
* View: Themes(saves current theme to localStorage)
* Drag and drop project files(project.json, project.xml, *.hxml) to open project
* Replaced prompt dialog for file tree context menu commands(New File..., New Folder...) to Bootbox.js prompt(Bootstrap based)
* Hotkeys management using config file in JSON format, added "Options: Open hotkey configuration file" command to open configuration file in HIDE(It will update hotkeys on configuration file save)

0.3.2
-----------

* Project options panel: relative paths now should work fine for Run Action: Open File
* boyan.bootstrap.tab-manager now should save files on tab close and "Close Others" context menu command
* Drag and drop folder to HIDE to show it's contents in file tree
* Preprocess build and run commands(use %path% var to specify path to project and %join%(path/to/folder,project.xml) function to join two paths). For example for OpenFL build and run commands preprocessed with such pattern: "%join%(%path%,project.xml)".
* Added context menu to file tree(needs custom prompt dialog, because default starts not focused)

0.3.1
-----------

* Fix for HIDE haxelib - don't recompile HIDE plugins on first start(to make it start faster first time)

0.3.0
-----------

* Release on haxelib