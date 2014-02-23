(function () { "use strict";
var $estr = function() { return js.Boot.__string_rec(this,''); };
var FileTools = function() { };
FileTools.__name__ = ["FileTools"];
FileTools.createDirectoryRecursively = function(path,folderPath,onCreated) {
	var fullPath = js.Node.require("path").join(path,folderPath[0]);
	FileTools.createDirectory(fullPath,function() {
		folderPath.splice(0,1);
		if(folderPath.length > 0) FileTools.createDirectoryRecursively(fullPath,folderPath,onCreated); else onCreated();
	});
};
FileTools.createDirectory = function(path,onCreated) {
	js.Node.require("fs").mkdir(path,null,function(error) {
		if(error != null) console.log(error);
		if(onCreated != null) onCreated();
	});
};
var HxOverrides = function() { };
HxOverrides.__name__ = ["HxOverrides"];
HxOverrides.dateStr = function(date) {
	var m = date.getMonth() + 1;
	var d = date.getDate();
	var h = date.getHours();
	var mi = date.getMinutes();
	var s = date.getSeconds();
	return date.getFullYear() + "-" + (m < 10?"0" + m:"" + m) + "-" + (d < 10?"0" + d:"" + d) + " " + (h < 10?"0" + h:"" + h) + ":" + (mi < 10?"0" + mi:"" + mi) + ":" + (s < 10?"0" + s:"" + s);
};
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
};
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
};
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
};
var List = function() { };
List.__name__ = ["List"];
List.prototype = {
	iterator: function() {
		return { h : this.h, hasNext : function() {
			return this.h != null;
		}, next : function() {
			if(this.h == null) return null;
			var x = this.h[0];
			this.h = this.h[1];
			return x;
		}};
	}
	,__class__: List
};
var Main = function() { };
Main.__name__ = ["Main"];
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,function() {
		NewProjectDialog.getCategory("Haxe",1).addItem("Flash Project",Main.createFlashProject);
		NewProjectDialog.getCategory("Haxe").addItem("JavaScript Project",Main.createJavaScriptProject);
		NewProjectDialog.getCategory("Haxe").addItem("Neko Project",Main.createNekoProject);
		NewProjectDialog.getCategory("Haxe").addItem("PHP Project",Main.createPhpProject);
		NewProjectDialog.getCategory("Haxe").addItem("C++ Project",Main.createCppProject);
		NewProjectDialog.getCategory("Haxe").addItem("Java Project",Main.createJavaProject);
		NewProjectDialog.getCategory("Haxe").addItem("C# Project",Main.createCSharpProject);
		NewProjectDialog.getCategory("Haxe").select();
		HIDE.readFile(Main.$name,"templates/Main.hx",function(data) {
			Main.code = data;
			HIDE.notifyLoadingComplete(Main.$name);
		});
		HIDE.readFile(Main.$name,"templates/index.html",function(data) {
			Main.indexPageCode = data;
		});
	});
};
Main.createCSharpProject = function(data) {
	Main.createHaxeProject(data,5);
};
Main.createJavaProject = function(data) {
	Main.createHaxeProject(data,4);
};
Main.createCppProject = function(data) {
	Main.createHaxeProject(data,3);
};
Main.createPhpProject = function(data) {
	Main.createHaxeProject(data,2);
};
Main.createNekoProject = function(data) {
	Main.createHaxeProject(data,6);
};
Main.createFlashProject = function(data) {
	Main.createHaxeProject(data,0);
};
Main.createJavaScriptProject = function(data) {
	Main.createHaxeProject(data,1);
};
Main.createHaxeProject = function(data,target) {
	FileTools.createDirectoryRecursively(data.projectLocation,[data.projectName,"src"],function() {
		var pathToProject = data.projectLocation;
		if(data.createDirectory) pathToProject = js.Node.require("path").join(pathToProject,data.projectName);
		var pathToMain = pathToProject;
		ProjectAccess.currentProject.path = pathToProject;
		pathToMain = js.Node.require("path").join(pathToMain,"src","Main.hx");
		js.Node.require("fs").writeFile(pathToMain,Main.code,null,function(error) {
			if(error != null) console.log(error);
			js.Node.require("fs").exists(pathToMain,function(exists) {
				if(exists) TabManager.openFileInNewTab(pathToMain); else console.log(pathToMain + " file was not generated");
			});
		});
		var project = new Project();
		project.name = data.projectName;
		project.projectPackage = data.projectPackage;
		project.company = data.projectCompany;
		project.license = data.projectLicense;
		project.url = data.projectURL;
		project.type = 0;
		project.target = target;
		FileTree.load(project.name,pathToProject);
		var pathToBin = js.Node.require("path").join(pathToProject,"bin");
		js.Node.require("fs").mkdir(pathToBin);
		var args = "-cp src\n-main Main\n";
		var _g = project.target;
		switch(_g) {
		case 0:
			args += "-swf " + "bin/" + project.name + ".swf\n";
			break;
		case 1:
			var pathToScript = "bin/" + project.name + ".js";
			args += "-js " + pathToScript + "\n";
			var updatedPageCode = StringTools.replace(Main.indexPageCode,"::title::",project.name);
			updatedPageCode = StringTools.replace(Main.indexPageCode,"::script::",pathToScript);
			js.Node.require("fs").writeFile(js.Node.require("path").join(pathToBin,"index.html"),Main.indexPageCode,"utf8",function(error) {
			});
			break;
		case 2:
			args += "-php " + "bin/" + project.name + ".php\n";
			break;
		case 3:
			args += "-cpp " + "bin/" + project.name + ".exe\n";
			break;
		case 4:
			args += "-java " + "bin/" + project.name + ".jar\n";
			break;
		case 5:
			args += "-cs " + "bin/" + project.name + ".exe\n";
			break;
		default:
		}
		args += "-debug\n -dce full";
		project.args = args.split("\n");
		var path = js.Node.require("path").join(pathToProject,"project.hide");
		js.Node.require("fs").writeFile(path,haxe.Serializer.run(project),"utf8",function(error) {
		});
		js.Browser.getLocalStorage().setItem("pathToLastProject",path);
		ProjectAccess.currentProject = project;
		var textarea;
		textarea = js.Boot.__cast(window.document.getElementById("project-options-textarea") , HTMLTextAreaElement);
		textarea.value = args;
	});
};
var IMap = function() { };
IMap.__name__ = ["IMap"];
Math.__name__ = ["Math"];
var Reflect = function() { };
Reflect.__name__ = ["Reflect"];
Reflect.hasField = function(o,field) {
	return Object.prototype.hasOwnProperty.call(o,field);
};
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && f != "hx__closures__" && hasOwnProperty.call(o,f)) a.push(f);
		}
	}
	return a;
};
Reflect.deleteField = function(o,field) {
	if(!Reflect.hasField(o,field)) return false;
	delete(o[field]);
	return true;
};
var Std = function() { };
Std.__name__ = ["Std"];
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
};
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
};
var StringBuf = function() {
	this.b = "";
};
StringBuf.__name__ = ["StringBuf"];
StringBuf.prototype = {
	__class__: StringBuf
};
var StringTools = function() { };
StringTools.__name__ = ["StringTools"];
StringTools.urlEncode = function(s) {
	return encodeURIComponent(s);
};
StringTools.replace = function(s,sub,by) {
	return s.split(sub).join(by);
};
var ValueType = { __ename__ : ["ValueType"], __constructs__ : ["TNull","TInt","TFloat","TBool","TObject","TFunction","TClass","TEnum","TUnknown"] };
ValueType.TNull = ["TNull",0];
ValueType.TNull.toString = $estr;
ValueType.TNull.__enum__ = ValueType;
ValueType.TInt = ["TInt",1];
ValueType.TInt.toString = $estr;
ValueType.TInt.__enum__ = ValueType;
ValueType.TFloat = ["TFloat",2];
ValueType.TFloat.toString = $estr;
ValueType.TFloat.__enum__ = ValueType;
ValueType.TBool = ["TBool",3];
ValueType.TBool.toString = $estr;
ValueType.TBool.__enum__ = ValueType;
ValueType.TObject = ["TObject",4];
ValueType.TObject.toString = $estr;
ValueType.TObject.__enum__ = ValueType;
ValueType.TFunction = ["TFunction",5];
ValueType.TFunction.toString = $estr;
ValueType.TFunction.__enum__ = ValueType;
ValueType.TClass = function(c) { var $x = ["TClass",6,c]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; };
ValueType.TEnum = function(e) { var $x = ["TEnum",7,e]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; };
ValueType.TUnknown = ["TUnknown",8];
ValueType.TUnknown.toString = $estr;
ValueType.TUnknown.__enum__ = ValueType;
var Type = function() { };
Type.__name__ = ["Type"];
Type.getClassName = function(c) {
	var a = c.__name__;
	return a.join(".");
};
Type.getEnumName = function(e) {
	var a = e.__ename__;
	return a.join(".");
};
Type["typeof"] = function(v) {
	var _g = typeof(v);
	switch(_g) {
	case "boolean":
		return ValueType.TBool;
	case "string":
		return ValueType.TClass(String);
	case "number":
		if(Math.ceil(v) == v % 2147483648.0) return ValueType.TInt;
		return ValueType.TFloat;
	case "object":
		if(v == null) return ValueType.TNull;
		var e = v.__enum__;
		if(e != null) return ValueType.TEnum(e);
		var c = v.__class__;
		if(c != null) return ValueType.TClass(c);
		return ValueType.TObject;
	case "function":
		if(v.__name__ || v.__ename__) return ValueType.TObject;
		return ValueType.TFunction;
	case "undefined":
		return ValueType.TNull;
	default:
		return ValueType.TUnknown;
	}
};
var haxe = {};
haxe.Serializer = function() {
	this.buf = new StringBuf();
	this.cache = new Array();
	this.useCache = haxe.Serializer.USE_CACHE;
	this.useEnumIndex = haxe.Serializer.USE_ENUM_INDEX;
	this.shash = new haxe.ds.StringMap();
	this.scount = 0;
};
haxe.Serializer.__name__ = ["haxe","Serializer"];
haxe.Serializer.run = function(v) {
	var s = new haxe.Serializer();
	s.serialize(v);
	return s.toString();
};
haxe.Serializer.prototype = {
	toString: function() {
		return this.buf.b;
	}
	,serializeString: function(s) {
		var x = this.shash.get(s);
		if(x != null) {
			this.buf.b += "R";
			this.buf.b += Std.string(x);
			return;
		}
		this.shash.set(s,this.scount++);
		this.buf.b += "y";
		s = StringTools.urlEncode(s);
		this.buf.b += Std.string(s.length);
		this.buf.b += ":";
		this.buf.b += Std.string(s);
	}
	,serializeRef: function(v) {
		var vt = typeof(v);
		var _g1 = 0;
		var _g = this.cache.length;
		while(_g1 < _g) {
			var i = _g1++;
			var ci = this.cache[i];
			if(typeof(ci) == vt && ci == v) {
				this.buf.b += "r";
				this.buf.b += Std.string(i);
				return true;
			}
		}
		this.cache.push(v);
		return false;
	}
	,serializeFields: function(v) {
		var _g = 0;
		var _g1 = Reflect.fields(v);
		while(_g < _g1.length) {
			var f = _g1[_g];
			++_g;
			this.serializeString(f);
			this.serialize((function($this) {
				var $r;
				var v1 = null;
				try {
					v1 = v[f];
				} catch( e ) {
				}
				$r = v1;
				return $r;
			}(this)));
		}
		this.buf.b += "g";
	}
	,serialize: function(v) {
		{
			var _g = Type["typeof"](v);
			switch(_g[1]) {
			case 0:
				this.buf.b += "n";
				break;
			case 1:
				if(v == 0) {
					this.buf.b += "z";
					return;
				}
				this.buf.b += "i";
				this.buf.b += Std.string(v);
				break;
			case 2:
				if(Math.isNaN(v)) this.buf.b += "k"; else if(!Math.isFinite(v)) this.buf.b += Std.string(v < 0?"m":"p"); else {
					this.buf.b += "d";
					this.buf.b += Std.string(v);
				}
				break;
			case 3:
				this.buf.b += Std.string(v?"t":"f");
				break;
			case 6:
				var c = _g[2];
				if(c == String) {
					this.serializeString(v);
					return;
				}
				if(this.useCache && this.serializeRef(v)) return;
				switch(c) {
				case Array:
					var ucount = 0;
					this.buf.b += "a";
					var l = v.length;
					var _g1 = 0;
					while(_g1 < l) {
						var i = _g1++;
						if(v[i] == null) ucount++; else {
							if(ucount > 0) {
								if(ucount == 1) this.buf.b += "n"; else {
									this.buf.b += "u";
									this.buf.b += Std.string(ucount);
								}
								ucount = 0;
							}
							this.serialize(v[i]);
						}
					}
					if(ucount > 0) {
						if(ucount == 1) this.buf.b += "n"; else {
							this.buf.b += "u";
							this.buf.b += Std.string(ucount);
						}
					}
					this.buf.b += "h";
					break;
				case List:
					this.buf.b += "l";
					var v1 = v;
					var $it0 = v1.iterator();
					while( $it0.hasNext() ) {
						var i = $it0.next();
						this.serialize(i);
					}
					this.buf.b += "h";
					break;
				case Date:
					var d = v;
					this.buf.b += "v";
					var x = HxOverrides.dateStr(d);
					this.buf.b += Std.string(x);
					break;
				case haxe.ds.StringMap:
					this.buf.b += "b";
					var v1 = v;
					var $it1 = v1.keys();
					while( $it1.hasNext() ) {
						var k = $it1.next();
						this.serializeString(k);
						this.serialize(v1.get(k));
					}
					this.buf.b += "h";
					break;
				case haxe.ds.IntMap:
					this.buf.b += "q";
					var v1 = v;
					var $it2 = v1.keys();
					while( $it2.hasNext() ) {
						var k = $it2.next();
						this.buf.b += ":";
						this.buf.b += Std.string(k);
						this.serialize(v1.get(k));
					}
					this.buf.b += "h";
					break;
				case haxe.ds.ObjectMap:
					this.buf.b += "M";
					var v1 = v;
					var $it3 = v1.keys();
					while( $it3.hasNext() ) {
						var k = $it3.next();
						var id;
						var v2 = null;
						try {
							v2 = k.__id__;
						} catch( e ) {
						}
						id = v2;
						Reflect.deleteField(k,"__id__");
						this.serialize(k);
						k.__id__ = id;
						this.serialize(v1.h[k.__id__]);
					}
					this.buf.b += "h";
					break;
				case haxe.io.Bytes:
					var v1 = v;
					var i = 0;
					var max = v1.length - 2;
					var charsBuf = new StringBuf();
					var b64 = haxe.Serializer.BASE64;
					while(i < max) {
						var b1;
						var pos = i++;
						b1 = v1.b[pos];
						var b2;
						var pos = i++;
						b2 = v1.b[pos];
						var b3;
						var pos = i++;
						b3 = v1.b[pos];
						var x = b64.charAt(b1 >> 2);
						charsBuf.b += Std.string(x);
						var x = b64.charAt((b1 << 4 | b2 >> 4) & 63);
						charsBuf.b += Std.string(x);
						var x = b64.charAt((b2 << 2 | b3 >> 6) & 63);
						charsBuf.b += Std.string(x);
						var x = b64.charAt(b3 & 63);
						charsBuf.b += Std.string(x);
					}
					if(i == max) {
						var b1;
						var pos = i++;
						b1 = v1.b[pos];
						var b2;
						var pos = i++;
						b2 = v1.b[pos];
						var x = b64.charAt(b1 >> 2);
						charsBuf.b += Std.string(x);
						var x = b64.charAt((b1 << 4 | b2 >> 4) & 63);
						charsBuf.b += Std.string(x);
						var x = b64.charAt(b2 << 2 & 63);
						charsBuf.b += Std.string(x);
					} else if(i == max + 1) {
						var b1;
						var pos = i++;
						b1 = v1.b[pos];
						var x = b64.charAt(b1 >> 2);
						charsBuf.b += Std.string(x);
						var x = b64.charAt(b1 << 4 & 63);
						charsBuf.b += Std.string(x);
					}
					var chars = charsBuf.b;
					this.buf.b += "s";
					this.buf.b += Std.string(chars.length);
					this.buf.b += ":";
					this.buf.b += Std.string(chars);
					break;
				default:
					this.cache.pop();
					if(v.hxSerialize != null) {
						this.buf.b += "C";
						this.serializeString(Type.getClassName(c));
						this.cache.push(v);
						v.hxSerialize(this);
						this.buf.b += "g";
					} else {
						this.buf.b += "c";
						this.serializeString(Type.getClassName(c));
						this.cache.push(v);
						this.serializeFields(v);
					}
				}
				break;
			case 4:
				if(this.useCache && this.serializeRef(v)) return;
				this.buf.b += "o";
				this.serializeFields(v);
				break;
			case 7:
				var e = _g[2];
				if(this.useCache && this.serializeRef(v)) return;
				this.cache.pop();
				this.buf.b += Std.string(this.useEnumIndex?"j":"w");
				this.serializeString(Type.getEnumName(e));
				if(this.useEnumIndex) {
					this.buf.b += ":";
					this.buf.b += Std.string(v[1]);
				} else this.serializeString(v[0]);
				this.buf.b += ":";
				var l = v.length;
				this.buf.b += Std.string(l - 2);
				var _g1 = 2;
				while(_g1 < l) {
					var i = _g1++;
					this.serialize(v[i]);
				}
				this.cache.push(v);
				break;
			case 5:
				throw "Cannot serialize function";
				break;
			default:
				throw "Cannot serialize " + Std.string(v);
			}
		}
	}
	,__class__: haxe.Serializer
};
haxe.ds = {};
haxe.ds.IntMap = function() { };
haxe.ds.IntMap.__name__ = ["haxe","ds","IntMap"];
haxe.ds.IntMap.__interfaces__ = [IMap];
haxe.ds.IntMap.prototype = {
	get: function(key) {
		return this.h[key];
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key | 0);
		}
		return HxOverrides.iter(a);
	}
	,__class__: haxe.ds.IntMap
};
haxe.ds.ObjectMap = function() { };
haxe.ds.ObjectMap.__name__ = ["haxe","ds","ObjectMap"];
haxe.ds.ObjectMap.__interfaces__ = [IMap];
haxe.ds.ObjectMap.prototype = {
	keys: function() {
		var a = [];
		for( var key in this.h.__keys__ ) {
		if(this.h.hasOwnProperty(key)) a.push(this.h.__keys__[key]);
		}
		return HxOverrides.iter(a);
	}
	,__class__: haxe.ds.ObjectMap
};
haxe.ds.StringMap = function() {
	this.h = { };
};
haxe.ds.StringMap.__name__ = ["haxe","ds","StringMap"];
haxe.ds.StringMap.__interfaces__ = [IMap];
haxe.ds.StringMap.prototype = {
	set: function(key,value) {
		this.h["$" + key] = value;
	}
	,get: function(key) {
		return this.h["$" + key];
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key.substr(1));
		}
		return HxOverrides.iter(a);
	}
	,__class__: haxe.ds.StringMap
};
haxe.io = {};
haxe.io.Bytes = function() { };
haxe.io.Bytes.__name__ = ["haxe","io","Bytes"];
haxe.io.Bytes.prototype = {
	__class__: haxe.io.Bytes
};
var js = {};
js.Boot = function() { };
js.Boot.__name__ = ["js","Boot"];
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) str += "," + js.Boot.__string_rec(o[i],s); else str += js.Boot.__string_rec(o[i],s);
				}
				return str + ")";
			}
			var l = o.length;
			var i;
			var str = "[";
			s += "\t";
			var _g = 0;
			while(_g < l) {
				var i1 = _g++;
				str += (i1 > 0?",":"") + js.Boot.__string_rec(o[i1],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString) {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
};
js.Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0;
		var _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js.Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js.Boot.__interfLoop(cc.__super__,cl);
};
js.Boot.__instanceof = function(o,cl) {
	if(cl == null) return false;
	switch(cl) {
	case Int:
		return (o|0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return typeof(o) == "boolean";
	case String:
		return typeof(o) == "string";
	case Dynamic:
		return true;
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) {
					if(cl == Array) return o.__enum__ == null;
					return true;
				}
				if(js.Boot.__interfLoop(o.__class__,cl)) return true;
			}
		} else return false;
		if(cl == Class && o.__name__ != null) return true;
		if(cl == Enum && o.__ename__ != null) return true;
		return o.__enum__ == cl;
	}
};
js.Boot.__cast = function(o,t) {
	if(js.Boot.__instanceof(o,t)) return o; else throw "Cannot cast " + Std.string(o) + " to " + Std.string(t);
};
js.Browser = function() { };
js.Browser.__name__ = ["js","Browser"];
js.Browser.getLocalStorage = function() {
	try {
		var s = window.localStorage;
		s.getItem("");
		return s;
	} catch( e ) {
		return null;
	}
};
js.Node = function() { };
js.Node.__name__ = ["js","Node"];
Math.NaN = Number.NaN;
Math.NEGATIVE_INFINITY = Number.NEGATIVE_INFINITY;
Math.POSITIVE_INFINITY = Number.POSITIVE_INFINITY;
Math.isFinite = function(i) {
	return isFinite(i);
};
Math.isNaN = function(i) {
	return isNaN(i);
};
String.prototype.__class__ = String;
String.__name__ = ["String"];
Array.prototype.__class__ = Array;
Array.__name__ = ["Array"];
Date.prototype.__class__ = Date;
Date.__name__ = ["Date"];
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
if(Array.prototype.map == null) Array.prototype.map = function(f) {
	var a = [];
	var _g1 = 0;
	var _g = this.length;
	while(_g1 < _g) {
		var i = _g1++;
		a[i] = f(this[i]);
	}
	return a;
};
var module, setImmediate, clearImmediate;
js.Node.setTimeout = setTimeout;
js.Node.clearTimeout = clearTimeout;
js.Node.setInterval = setInterval;
js.Node.clearInterval = clearInterval;
js.Node.global = global;
js.Node.process = process;
js.Node.require = require;
js.Node.console = console;
js.Node.module = module;
js.Node.stringify = JSON.stringify;
js.Node.parse = JSON.parse;
var version = HxOverrides.substr(js.Node.process.version,1,null).split(".").map(Std.parseInt);
if(version[0] > 0 || version[1] >= 9) {
	js.Node.setImmediate = setImmediate;
	js.Node.clearImmediate = clearImmediate;
}
Main.$name = "boyan.project.haxe";
Main.dependencies = ["boyan.bootstrap.new-project-dialog","boyan.bootstrap.tab-manager","boyan.bootstrap.project-options","boyan.bootstrap.file-tree"];
haxe.Serializer.USE_CACHE = false;
haxe.Serializer.USE_ENUM_INDEX = false;
haxe.Serializer.BASE64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789%:";
Main.main();
})();

//# sourceMappingURL=Main.js.map