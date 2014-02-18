[![Build Status](https://travis-ci.org/misterpah/HIDE.png?branch=master)](https://travis-ci.org/misterpah/HIDE)

HIDE
====

HIDE - plugin based IDE for Haxe programming language

Thanks to a group of [crowd funders at IndieGoGo](http://www.indiegogo.com/projects/cactus-ide/), HIDE is open source, licensed under the terms of the MIT License.

Google Plus:
[HIDE Google Plus page](https://plus.google.com/113245482496557815887)

Google Group:
[HIDE Google Group](https://groups.google.com/forum/#!forum/haxeide)

There, you can discuss anything related to HIDE; including features requests, bugs, or just give feedback about HIDE.

Please note that HIDE is in active development. HIDE is currently not ready for use. 
This information is for curious people and contributors.

1. Before doing something it's better to start a discussion at [HIDE Google Group](https://groups.google.com/forum/#!forum/haxeide) or create an issue on [GitHub](https://github.com/misterpah/hide/issues?state=open).
2. If you have questions about how it works, or wonder where to find for something, you can ask your questions in the HIDE Google Group. We will try to answer them as soon as possible.

###How to run:

1. Download node-webkit binary from https://github.com/rogerwang/node-webkit
2. Extract the contents of the archive to the bin/ folder of HIDE, so it looks like this: 
![Alt text](http://s13.postimg.org/9l0qcxo87/screenshot_204.png)
3. Run nw.exe

We will provide easier ways to run and distribute HIDE when it is ready for use.

###How to compile:
1. You will need Haxe 3. Make sure you have installed the jQueryExtern and hxparse(currently not used) haxelibs:
	
        haxelib install jQueryExtern

2. If you are on Windows, open HIDE.hxproj using FlashDevelop. If you are on Linux or Mac, you should be able to compile HIDE using this command:

        haxe HIDE.hxml
    
3. On Windows, you can start HIDE using run.bat, if you provide the path to node-webkit.
On Linux, you can run it like this:

        nw /path/to/HIDE/bin
        
	If you got message in the console saying that your system is lacking libudev.so.0(taken from https://github.com/rogerwang/node-webkit/wiki/The-solution-of-lacking-libudev.so.0).
	Then please try executing this commands in the terminal:

	``` bash
	# ln -s /lib/x86_64-linux-gnu/libudev.so.1 ./libudev.so.0
	```

	Then create a shell script to run nw:

	``` bash
	#!/bin/sh
	LD_LIBRARY_PATH=/home/omi/nw:$LD_LIBRARY_PATH ./nw $*
	```
    
Mac users can run it using the instructions on the node-webkit page:
https://github.com/rogerwang/node-webkit/wiki/How-to-run-apps

The main thing you need to know is that you need to run nw with the path/to/hide/bin folder argument.

###How to contribute:

1. Make sure you have a [GitHub Account](https://github.com/signup/free)
2. Fork [HIDE](https://github.com/misterpah/hide)
  ([how to fork a repo](https://help.github.com/articles/fork-a-repo))
3. Make your changes
4. Submit a pull request
([how to create a pull request](https://help.github.com/articles/fork-a-repo))

Contributions are welcome.

###Getting help

Community discussion, questions, and informal bug reporting is done on the
[HIDE Google group](https://groups.google.com/group/haxeide).
	
## Submitting bug reports

The preferred way to report bugs is to use the
[GitHub issue tracker](https://github.com/misterpah/hide/issues).

Questions should be asked on the
[HIDE Google group](http://groups.google.com/group/haxeide).

###Developer's Guide

####How HIDE works

A few words on inner structure of HIDE.

When HIDE(node-webkit) starts it tries to load "bin/index.html".

Which is basically looks like this:

```
<!DOCTYPE html>
<head>
	<title>HIDE - cross platform extensible IDE for Haxe</title>
	<meta charset="utf-8">

	<!-- Code generated using Haxe -->
	<script type="text/javascript" src="./HIDE.js"></script>
</head>

<body>	
</body>
```

"bin/HIDE.js" is the script which contains core of the HIDE. It is responsible for loading plugins, plugins provide most of the IDE's functionality.

HIDE core consists of:
1. src/HIDE.hx
2. src/Main.hx

Core classes walk through "plugins" directory and search for "plugin.hxml" file.

When "plugin.hxml" is found, HIDE will try to add

```
<script src="path/to/plugin/bin/Main.js">
```

to html page. Which will cause script loading and execution.

NOTE: Currently HIDE will recompile each plugin before adding it to the page. Stable version of HIDE will not recompile plugins on start, but there will be such option for developers.

Probably it would be easier to understand, if you could imagine HIDE core as some require.js(AMD) lib, written entirely in Haxe, which checks plugin dependencies and loads plugins when dependencies are met.

####Plugin Structure:

Required files:
1. plugin.hxml
2. bin/Main.js

Most of HIDE functionality is based on plugins.

####How to develop a plugin

Create a copy of "plugins/boyan/samples/helloworld" folder.
And rename it to plugin name, for example "plugins/john/samples/test".

Modify "src/Main.hx" to suit your needs.

you can use HIDE core functions to load JS and CSS scripts you may need:

```
//JS
HIDE.loadJS(name, ["script1.js", "script2.js", "script3.js"], function ()
{
	trace("JS scripts load complete");
}
);

//CSS
HIDE.loadCSS(name, ["stylesheet1.css", "stylesheet2.css", "stylesheet3.css"], function ()
{
	trace("CSS load complete");
}
);
```

notify HIDE core, that plugin is ready to use:

```
HIDE.notifyLoadingComplete(name);
```

So if some plugins depend on this plugin, then they can start loading themselves.

###Known issues

###Current TODOs:
1. Port code from not-plugin-based branch to master(which is plugin based)
2. Project Management
3. Code completion(Haxe completion + hxparse)

###License:
HIDE is licensed under the terms of the MIT License.
CodeMirror, Tern and Acorn are licensed under the terms of the MIT License.
JQuery and JQuery UI are licensed under the terms of the MIT License.
JQuery xml2json is licensed under the terms of the MIT License.
JQuery Layout plugin is dual-licensed under the GPL and MIT licenses.
Bootstrap is licensed under the terms of the Apache License Version 2.0

jQueryExtern is released in the public domain.