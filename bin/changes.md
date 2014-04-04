0.3.5
-----------

* ADDED: Hxml syntax highlighting mode
* CHANGED: Show file list(Ctrl-Shift-O) for any file(previously worked only for *.hxml and *.hx)

0.3.4
-----------

* FIX: project.json saving
* FIX: CM theme loading
* FIX: completion for hxml projects
* FIX: multiple haxe processes issue(check if process if already started)
* FIX: window state preserving
* FIX: project options padding
* FIX: Tab Manager context menu: Close others
* FIX: Hotkeys for Mac
* CHANGED: Plugins were moved to the core(for performance, stability and to make development easier), HIDE still supports plugin system.
* CHANGED: Release on haxelib only JavaScript code(without source)
* CHANGED: removed Acorn(unused parser, which Tern depends on)
* CHANGED: removed Tern
* CHANGED: use TJSON to encode/parse JSON data
* CHANGED: show anyword completion when no completion available
* CHANGED: moved elements CSS to one file theme.css
* CHANGED: moved source code to packages
* CHANGED: renamed config.json to hotkeys.json
* CHANGED: Project options panel: show run action option for hxml projects
* CHANGED: check if run action url/file/command is empty
* CHANGED: replaced jQuery layout plugin with jQWidget splitter
* CHANGED: project options panel moved to tab
* CHANGED: use Mustache for templates
* CHANGED: use alertify for prompt/confirm/alert dialogs and notifications
* CHANGED: tab manager was rewritten
* CHANGED: hide outline panel and file tree when no project open
* CHANGED: linting will get updated on build/parse
* ADDED: Help: changelog command
* ADDED: Options: Open editor configuration file command
* ADDED: Help: Show code editor key bindings
* ADDED: Options: Open stylesheet(to customize visual look of HIDE)
* ADDED: Show hints for function parameters
* ADDED: compile time errors linting
* ADDED: Options: Open autoformat configuration file to adjust code formatter options
* ADDED: restore open tabs
* ADDED: Select last active tab when restoring open tabs
* ADDED: check document extension before showing function parameters/completion/linting
* ADDED: Results and Options tabs
* ADDED: Toggle comments on Ctrl-Q(was fixed in CM), also Ctrt-/ should work too as default hotkey
* ADDED: show compile-time errors in Results tab
* ADDED: Show build status indicator on output tab header
* ADDED: watch theme.css for changes and apply to UI
* ADDED: CM Haxe mode indent
* ADDED: Watch open files(and show confirmation for reload)
* ADDED: Prompt path to haxe
* ADDED: Go to Line(Ctrl-G) dialog
* ADDED: On close tab - confirm dialog to save file or not(hotkeys: Enter - to save, Esc - to not save)
* ADDED: open file(Ctrl-Shift-O)
* ADDED: show class list(Ctrl-Shift-P)
* ADDED: welcome screen
* ADDED: completion for hxml
* ADDED: imports completion(same as show class list)
* ADDED: show installed lib list in hxml completion
* UPDATED: CodeMirror to v4

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