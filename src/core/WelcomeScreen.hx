package core;
import jQuery.JQuery;
import js.Browser;
import js.html.AnchorElement;
import js.html.DivElement;
import js.html.HeadingElement;
import js.html.LIElement;
import js.html.UListElement;
import js.Node;
import newprojectdialog.NewProjectDialog;
import nodejs.webkit.Shell;
import openproject.OpenProject;

/**
 * ...
 * @author AS3Boyan
 */
class WelcomeScreen
{
	static var div:DivElement;
	
	public static function load():Void
	{		
		div = cast(Browser.document.getElementById("welcomeScreen"), DivElement);
		
		//div = Browser.document.createDivElement();
		//div.id = "welcomeScreen";
		
		//new JQuery().html()
		
		//var h3 = cast(Browser.document.createElement("h3"), HeadingElement);
		//h3.textContent = "Welcome to HIDE";
		//siteWrapper.appendChild(h3);
		//
		//var ul:UListElement = Browser.document.createUListElement();
		//siteWrapper.appendChild(ul);
		//
		//ul.appendChild(createListElement("Create New Project...", NewProjectDialog.show));
		//ul.appendChild(createListElement("Open File or Project...", OpenProject.openProject));
		
		//var options:NodeFsFileOptions = { };
		//options.encoding = NodeC.UTF8;
		
		//var data:String = Node.fs.readFileSync("welcomeScreen.html", options);
		
		//new JQuery(div).html(data);
		
		//new JQuery("#editor").append(div);
		
		new JQuery("#createNewProject").on("click", NewProjectDialog.show);
		
		new JQuery("#openProject").on("click", OpenProject.openProject.bind(null));
		
		new JQuery("#github").on("click", Shell.openExternal.bind("https://github.com/misterpah/HIDE/tree/master"));
		new JQuery("#as3boyan").on("click", Shell.openExternal.bind("http://twitter.com/As3Boyan"));
		new JQuery("#misterpah").on("click", Shell.openExternal.bind("http://twitter.com/misterpah"));
	}
	
	static function createListElement(text:String, onClick:Dynamic)
	{
		var li:LIElement = Browser.document.createLIElement();
		
		var a:AnchorElement = Browser.document.createAnchorElement();
		a.href = "#";
		a.textContent = text;
		a.onclick = function (e):Void 
		{
			onClick();
		};
		
		li.appendChild(a);
		
		return li;
	}
	
	public static function show():Void
	{
		new JQuery(div).fadeIn();
	}
	
	public static function hide():Void
	{
		new JQuery(div).fadeOut();
	}
}