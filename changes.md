0.3.2
-----------

* Relative paths now should work fine for Run Action: Open File
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