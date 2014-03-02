package ;
import js.Browser;
import js.html.DivElement;
import js.html.Element;

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
			var reveal:DivElement = Browser.document.createDivElement();
			reveal.className = "reveal";
			
			var slides:DivElement =  Browser.document.createDivElement();
			slides.className = "slides";
			reveal.appendChild(slides);
			
			slides.appendChild(createSection("Single Horizontal Slide"));
			
			var section:Element = createSection();
			section.appendChild(createSection("Vertical Slide 1"));
			section.appendChild(createSection("Vertical Slide 2"));
			
			slides.appendChild(section);
			
			Browser.document.body.appendChild(reveal);
			
			runRevealJS();
			
			var window = js.Node.require('nw.gui').Window.get();
			window.on("close", function (e):Void
			{
				window.close(true);
			}
			);
		};
	}
	
	private static function createSection(?text:String):Element
	{
		var section:Element = Browser.document.createElement("section");
		
		if (text != null)
		{
			section.innerText = text;
		}
		
		return section;
	}
	
	private static function runRevealJS():Void
	{
		var dependencies:Array<Dynamic> = 
		[
		{ src: 'includes/lib/js/classList.js', condition: function() { return Browser.document.body.classList == null; } },
			//{ src: 'includes/plugin/markdown/marked.js', condition: function() { return !!Browser.document.querySelector( '[data-markdown]' ); } },
			//{ src: 'includes/plugin/markdown/markdown.js', condition: function() { return !!Browser.document.querySelector( '[data-markdown]' ); } },
			{ src: 'includes/plugin/highlight/highlight.js', async: true, callback: function() { untyped hljs.initHighlightingOnLoad(); } },
			{ src: 'includes/plugin/zoom-js/zoom.js', async: true, condition: function() { return Browser.document.body.classList != null; } },
			{ src: 'includes/plugin/notes/notes.js', async: true, condition: function() { return Browser.document.body.classList != null; } }
		];
		
		// Full list of configuration options available here:
		// https://github.com/hakimel/reveal.js#configuration
		Reveal.initialize({
			controls: true,
			progress: true,
			history: true,
			center: true,
			
			theme: Reveal.getQueryHash().theme, // available themes are in /css/theme
			//transition: Reveal.getQueryHash().transition || 'default', // default/cube/page/concave/zoom/linear/fade/none
			
			// Optional libraries used to extend on reveal.js
			dependencies: dependencies
		});
	}
}