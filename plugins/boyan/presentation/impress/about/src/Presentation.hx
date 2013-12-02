package ;
import js.Browser;
import js.html.DivElement;
import js.html.Element;
import js.html.ParagraphElement;

/**
 * ...
 * @author AS3Boyan
 */
class Presentation
{
	public static function main()
	{		
		Browser.window.onload = function (e):Void
		{
			var impress:DivElement = Browser.document.createDivElement();
			impress.id = "impress";
		
			var start:DivElement = Browser.document.createDivElement();
			start.id = "start";
			impress.appendChild(start);
			
			var p:ParagraphElement = Browser.document.createParagraphElement();
			p.style.width = "1000px";
			p.style.fontSize = "80px";
			p.style.textAlign = "center";
			p.innerText = "Creating Stunning Visualizations";
			start.appendChild(p);
			
			p = Browser.document.createParagraphElement();
			p.innerText = "Impress.js";
			start.appendChild(p);
			
			var slide2:DivElement = Browser.document.createDivElement();
			slide2.id = "slide2";
			slide2.setAttribute("data-x", "-1200");
			slide2.setAttribute("data-y", "0");
			impress.appendChild(slide2);
			
			p = Browser.document.createParagraphElement();
			p.style.width = "1000px";
			p.style.fontSize = "80px";
			p.innerText = "First Slide Moves From Left To Right";
			slide2.appendChild(p);
			
			p = Browser.document.createParagraphElement();
			p.innerText = "Impress.js";
			slide2.appendChild(p);
			
			Browser.document.body.appendChild(impress);
			
			runImpressJS();
			
			var window = js.Node.require('nw.gui').Window.get();
			window.on("close", function (e):Void
			{
				window.close(true);
			}
			);
		};
	}
	
	private static function runImpressJS():Void
	{
		untyped impress().init();
	}
}