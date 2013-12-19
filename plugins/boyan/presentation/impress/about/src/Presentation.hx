package ;
import js.Browser;
import js.html.DivElement;
import js.html.Element;
import js.html.ParagraphElement;
import js.html.AnchorElement;

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
			start.className = "step";
			impress.appendChild(start);
			
			var p:ParagraphElement = Browser.document.createParagraphElement();
			p.style.width = "1000px";
			p.style.fontSize = "80px";
			p.style.textAlign = "center";
			p.innerText = "HIDE - cross platform extensible IDE for Haxe";
			start.appendChild(p);
						
			var slide2:DivElement = createSlide(2, "Haxe Foundation ", "http://haxe-foundation.org/", "haxe-foundation.org");
			slide2.setAttribute("data-x", "-3200");
			slide2.setAttribute("data-y", "0");
			impress.appendChild(slide2);

			var slide3:DivElement = createSlide(3, "FlashDevelop", "http://www.flashdevelop.org/", "www.flashdevelop.org");
			slide3.setAttribute("data-x", "-5200");
			slide3.setAttribute("data-y", "0");
			impress.appendChild(slide3);

			var slide4:DivElement = createSlide(4, "OpenFL", "http://www.openfl.org/", "www.openfl.org");
			slide4.setAttribute("data-x", "-7200");
			slide4.setAttribute("data-y", "0");
			impress.appendChild(slide4);

			//Adrian Cowan
			//Jonas Malaco Filho
			//tommy62
			//jdonaldson3

			//hypersurge.com
			//http://blog.othrayte.net/

			var slide10:DivElement = createSlide(5, "Without your help, this would not have been possible to make it");
			slide10.setAttribute("data-x", "-9200");
			slide10.setAttribute("data-y", "0");
			slide10.className = "step";
			impress.appendChild(slide10);
			
			var slide11:DivElement = createSlide(6, "Thanks for your support!");
			slide11.setAttribute("data-x", "-11200");
			slide11.setAttribute("data-y", "0");
			slide11.className = "step";
			impress.appendChild(slide11);

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
	
	private static function createSlide(n:Int, text:String, ?url:String, ?linkText:String):DivElement
	{
		var slide:DivElement = Browser.document.createDivElement();
		slide.id = "slide" + n;
		slide.className = "step";
		
		var p:ParagraphElement = Browser.document.createParagraphElement();
		p.style.width = "1000px";
		p.style.fontSize = "80px";
		p.innerText = text;
		slide.appendChild(p);

		if (url != null)
		{
			p = Browser.document.createParagraphElement();
			p.className = "footnote";
			p.innerText = "Website: ";
			p.style.fontSize = "24px";
			slide.appendChild(p);

			var a:AnchorElement = Browser.document.createAnchorElement();
			a.href = url;
			a.innerText = linkText;
			a.target = "_blank";
			p.appendChild(a);
		}

		return slide;
	}

	private static function runImpressJS():Void
	{
		untyped impress().init();
	}
}