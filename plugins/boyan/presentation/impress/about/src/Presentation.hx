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
	private static var impressDiv:DivElement;
	private static var slidesCount:Int;

	public static function main()
	{		
		Browser.window.onload = function (e):Void
		{
			impressDiv = Browser.document.createDivElement();
			impressDiv.id = "impress";
		
			var start:DivElement = Browser.document.createDivElement();
			start.id = "start";
			start.className = "step";
			impressDiv.appendChild(start);
			
			var p:ParagraphElement = Browser.document.createParagraphElement();
			p.style.width = "1000px";
			p.style.fontSize = "80px";
			p.style.textAlign = "center";
			p.innerText = "HIDE - cross platform extensible IDE for Haxe";
			start.appendChild(p);
						
			slidesCount = 1;

			var slide:DivElement;

			slide = createSlide("'Feature request' perk backer and project sponsor");
			slide.setAttribute("data-x", "-3200");
			slide.setAttribute("data-y", "0");

			slide = createSlide("Haxe Foundation ", "http://haxe-foundation.org/", "haxe-foundation.org");
			slide.setAttribute("data-x", "-5200");
			slide.setAttribute("data-y", "0");

			slide = createSlide("'Link to your website' perk backers");
			slide.setAttribute("data-x", "-7200");
			slide.setAttribute("data-y", "0");

			slide = createSlide("FlashDevelop", "http://www.flashdevelop.org/", "www.flashdevelop.org");
			slide.setAttribute("data-x", "-9200");
			slide.setAttribute("data-y", "0");

			slide = createSlide("OpenFL", "http://www.openfl.org/", "www.openfl.org");
			slide.setAttribute("data-x", "-11200");
			slide.setAttribute("data-y", "0");
			
			slide = createSlide("Hypersurge", "http://hypersurge.com/", "hypersurge.com");
			slide.setAttribute("data-x", "-13200");
			slide.setAttribute("data-y", "0");

			slide = createSlide("Adrian Cowan", "http://blog.othrayte.net/", "blog.othrayte.net");
			slide.setAttribute("data-x", "-15500");
			slide.setAttribute("data-y", "0");

			slide = createSlide("Justin Donaldson", "http://scwn.net/", "scwn.net");
			slide.setAttribute("data-x", "-17200");
			slide.setAttribute("data-y", "0");

			slide = createSlide("Jonas Malaco Filho");
			slide.setAttribute("data-x", "-19800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("tommy62");
			slide.setAttribute("data-x", "-21800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("'Contributor ' perk backers");
			slide.setAttribute("data-x", "-23200");
			slide.setAttribute("data-y", "0");

			slide = createSlide("Allan Dowdeswell");
			slide.setAttribute("data-x", "-24800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("Samuel Batista");
			slide.setAttribute("data-x", "-26800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("JongChan Choi");
			slide.setAttribute("data-x", "-28800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("Patric Vormstein");
			slide.setAttribute("data-x", "-30800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("Harry.french");
			slide.setAttribute("data-x", "-32800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("Vincent Blanchet");
			slide.setAttribute("data-x", "-34800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("zaynyatyi");
			slide.setAttribute("data-x", "-36800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("qzix13");
			slide.setAttribute("data-x", "-38800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("free24speed");
			slide.setAttribute("data-x", "-41800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("franco.ponticelli");
			slide.setAttribute("data-x", "-43800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("william.shakour");
			slide.setAttribute("data-x", "-45800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("frabbit");
			slide.setAttribute("data-x", "-47800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("Nick Holder");
			slide.setAttribute("data-x", "-49800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("fintanboyle");
			slide.setAttribute("data-x", "-51800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("Katsuomi Kobayashi");
			slide.setAttribute("data-x", "-53800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("grigoruk");
			slide.setAttribute("data-x", "-55800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("jessetalavera");
			slide.setAttribute("data-x", "-57800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("bradparks");
			slide.setAttribute("data-x", "-59800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("pchertok");
			slide.setAttribute("data-x", "-61800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("Masahiro Wakame");
			slide.setAttribute("data-x", "-63800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("Stojan Ilic");
			slide.setAttribute("data-x", "-65800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("Renaud Bardet");
			slide.setAttribute("data-x", "-67800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("Filip Loster");
			slide.setAttribute("data-x", "-69800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("MatejTyc");
			slide.setAttribute("data-x", "-71800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("Tiago Ling Alexandre");
			slide.setAttribute("data-x", "-73800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("Skial Bainn");
			slide.setAttribute("data-x", "-75800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("lars.doucet");
			slide.setAttribute("data-x", "-77800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("Ido Yehieli");
			slide.setAttribute("data-x", "-79800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("Ronan Sandford");
			slide.setAttribute("data-x", "-81800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("brutfood");
			slide.setAttribute("data-x", "-83800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("Matan Uberstein");
			slide.setAttribute("data-x", "-85800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("rcarcasses");
			slide.setAttribute("data-x", "-87800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("vic.cvc");
			slide.setAttribute("data-x", "-89800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("Richard Lovejoy");
			slide.setAttribute("data-x", "-91800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("Tarwin Stroh-Spijer");
			slide.setAttribute("data-x", "-93800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("obutovich");
			slide.setAttribute("data-x", "-95800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("erik.escoffier");
			slide.setAttribute("data-x", "-97800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("Robert Wahler");
			slide.setAttribute("data-x", "-99800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("Louis Tovar");
			slide.setAttribute("data-x", "-101800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("L Pope");
			slide.setAttribute("data-x", "-103800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("Florian Landerl");
			slide.setAttribute("data-x", "-105800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("shohei 909");
			slide.setAttribute("data-x", "-107800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("Andy Li");
			slide.setAttribute("data-x", "-109800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("dionjw");
			slide.setAttribute("data-x", "-111800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("Aaron Spjut");
			slide.setAttribute("data-x", "-115800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("sebpatu");
			slide.setAttribute("data-x", "-117800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("brycedneal");
			slide.setAttribute("data-x", "-119800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("Sam Twidale");
			slide.setAttribute("data-x", "-121800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("Phillip Louderback");
			slide.setAttribute("data-x", "-123800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("Mario Vormstein");
			slide.setAttribute("data-x", "-125800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("deepnight");
			slide.setAttribute("data-x", "-127800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("Daniel Freeman");
			slide.setAttribute("data-x", "-129800");
			slide.setAttribute("data-y", "0");

			slide = createSlide("Also there is anonymous contributors, people who helped us to spread the word and people who helped us through pull requests, bug reports and feature requests");
			slide.setAttribute("data-x", "-131200");
			slide.setAttribute("data-y", "0");

			slide = createSlide("Without your help, this would not have been possible to make it");
			slide.setAttribute("data-x", "-133200");
			slide.setAttribute("data-y", "0");
			
			slide = createSlide("Thanks for your support!");
			slide.setAttribute("data-x", "-135200");
			slide.setAttribute("data-y", "0");

			slide = createSlide("(in case if you want to change website or name, just let me know - AS3Boyan)");
			slide.setAttribute("data-x", "-137200");
			slide.setAttribute("data-y", "0");

			Browser.document.body.appendChild(impressDiv);
			
			runImpressJS();
			
			var window = js.Node.require('nw.gui').Window.get();
			window.on("close", function (e):Void
			{
				window.close(true);
			}
			);
		};
	}
	
	private static function createSlide(text:String, ?url:String, ?linkText:String):DivElement
	{
		slidesCount++;

		var slide:DivElement = Browser.document.createDivElement();
		slide.id = "slide" + Std.string(slidesCount);
		slide.className = "step";
		trace(slide.id);
		
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

		impressDiv.appendChild(slide);
		return slide;
	}

	private static function runImpressJS():Void
	{
		untyped impress().init();
	}
}