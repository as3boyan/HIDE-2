* Autocompletion for hxml (including path for "-cp");
get list of haxelibs(using haxelib list) and provide autocompletion for "-lib |" command.
* Check how much plugins loaded, if only few, propose to recompile all plugins
* Move some elements from project options panel to new panel(somewhere in menu) or hide it(toggle visibility using some command)
* Try out Ext JS
* Use theming and tab management from hide-future
* Generate CSS and JS scripts embed code for folders
* Autoformat on change
* Autorebuild on change
* Show history of recently opened/build hxmls
* Options : Open snippets configuration file
* Configure autoformat using config.json
* Hide panes when no project was opened(hide project options for hxml files)
* Code comments
* Show hotkeys for first times
* Show file state(changed or not) in tab title
* Store commands in Commands class
* Move basic menu commands to commands and add to menu in one class(automatically add to menu if menu is specified)
* Show compiler arguments bugs
* Generate new on "="
* Get function parameters and completion from cache
* Use hxparse for completion
* Rename HaxeClient to ProcessHelper
* If cursor is in class scope, then show completion for 
* Do not save file for completion(provided from haxeparser)
* Code snippets for functions(autocompletion)
* Rename file when class name changes
* Search for imports on some hotkey(auto import if possible)
* Show list of classes in completion(probably another hotkey)
* Check if package matches path
* Try haxe multiple tabs(join all files together, and then parse on open them)
* Show how much space take obsolete versions of haxelibs
* Open project
* Open project in new window
* Open html in new window
* Start webserver and open in new window
* Build hxml
* New file in same folder
* Move inlined CSS to theme.css
* Split HIDE core into multiple classes(ones for plugin loading and compiling);
* Localization
* Debounce function
* Add CodeMirror.Pos to definitions
* haxeparser: check mode before parsing
* Use node js lib to walk througth folder
* Make parser walk througth source code
	* Haxe compiler std folder
	* Source code folders(-cp arguments)
	* Haxelibs folders
	
* Code completion for imports, full imports/classes list, completion for current class based on imports for current class, class modifiers, search for not imported classes and autoimport some of classes(show completion for multiple choices, notify user)

* Code snippets could be implemented in a same way you did with search addon

* CodeMirror: xmlcomplete, visibletabs, matchtabs, html5complete, closetags

* Generate imports
* Code generation
* Replace create file functions with code from templates(create new templates)
* Code snippets
* settings.json for HIDE settings

* Parse code if error - exclude line and try again

* Fix first launch - open HIDE project as first project(source code will not be included in haxelib)
* Add link to GitHub repository and website
* Move run.n to bin
* Close Project/Welcome screen
* Fix last project reopening for user of previous versions of HIDE
* Change title according to current project
* Show create new project or open project
* File tree context menu: Open file in New Tab
* File tree context menu: Delete
* Reconsider source code packages
* Check if file exists before creating new - change name
* Project templates
* Add dividers to menus
* Restructure menus
* Multiple commands support for run command action
* Search for Haxe std folder
* Escape paths
* Get libs and classes for OpenFL projects
* CM hint: add completions to open dialog
* CM hint: add round bracket to function completion
* Suggestions by deepnight
* Javascript breakpoints
* Completion: show results based on return type
* Completion: most used move up
* Jqxsplitter preserve layout
* Small tutorial for configuration files editing
* Autocomplete meta tags and show types on ":"
* Trace function run count
* Test ereg
* Return local variable in function
* cache completion from Haxe(add it to type completion)
* Watch file tree
* Hotkeys to hide/show panels
* Find in files
* FD theme
* Lower case first char of path on Windows
* Fix removing dist file with --no-output
* Calculate indents based on brackets
* HaxeParserProvider: check if pos is null
* Adjust ":" completion for typedefs
* Show multiple function declaration
* Function description in completion
* Check if hxml is in proper format
* Show do not installed warning in hxml
* Parse hxml
* Make themes for editor
* Check hotkeys for Mac OS(check os, and fix replacing Ctrl to Cmd)
* Download and install Haxe
* Check and refactor code for Haxe server(if not found, then download and install)
* Add notification for errors
* Prevent getting completion from Haxe more than one time(if no completion found for it) for function parameters hint
* Fix match brackets
* Split RunProject to multiple classes
* Show hints for variables
* Search in API reference
* Replace tab tooltips with tooltips from Bootstrap
* Fix indentation for "for" loop
* Automatically fix missing colon
* Standalone package each platform(install Haxe if not installed, get updates from haxelib)
* Toggle EReg preview from popup over EReg
* Build Failed Behaviour Change: if errors not found, then switch to Output(if haxelibs missing propose to install)
* Add Enter hotkey for Browse File Dialog
* Run Grunt for current project(add support for multiple build/run commands)
* Add current HIDE version(from haxelib.json) to issue reporter

###Important
* Fix for building *.hxml with -cmd arguments(test https://github.com/Justinfront/Jigsawx)
* Fix OpenFL projects(check webserver)
* Parse code with hxparse(classes on path)
* Unit tests
* Annotation ruler
* Go to definition
* Show prompt to install missing haxelibs
* Outline panel
* move out plugins loading function to new classes
* Check if import is missing
* Add completion to menu(and Go to Line command to menu)