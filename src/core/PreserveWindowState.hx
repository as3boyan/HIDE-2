package core;
import haxe.Timer;
import js.Browser;
import js.html.Node;
import nodejs.webkit.Window;

//Ported to Haxe from https://github.com/rogerwang/node-webkit/wiki/Preserve-window-state-between-sessions

// Cross-platform window state preservation.
// Yes this code is quite complicated, but this is the best I came up with for 
// current state of node-webkit Window API (v0.7.3).
// Known issues:
// - unmaximization not always sets the window (x, y) in the lastly used coordinates
// - unmaximization animation sometimes looks wierd

class PreserveWindowState
{
	private static var winState:Dynamic;
	private static var currWinMode:String;
	private static var resizeTimeout:Timer;
	private static var isMaximizationEvent:Bool = false;
	private static var window:Window = Window.get();
	
	public static function init():Void
	{                
		initWindowState();

		window.on('maximize', function ():Void
		{
				isMaximizationEvent = true;
				currWinMode = 'maximized';
		});

		window.on('unmaximize', function ():Void
		{
				currWinMode = 'normal';
				restoreWindowState();
		});

		window.on('minimize', function ():Void
		{
				currWinMode = 'minimized';
		});

		window.on('restore', function ():Void
		{
				currWinMode = 'normal';
		});
		
		window.window.addEventListener('resize', function (e) 
		{
			// resize event is fired many times on one resize action,
			// this hack with setTiemout forces it to fire only once
			
			if (resizeTimeout != null)
			{
				resizeTimeout.stop();
			}
			
			resizeTimeout = new Timer(500);
			resizeTimeout.run = 
			function () 
			{
				// on MacOS you can resize maximized window, so it's no longer maximized
				if (isMaximizationEvent) 
				{
						// first resize after maximization event should be ignored
						isMaximizationEvent = false;
				} 
				else 
				{
						if (currWinMode == 'maximized') 
						{
								currWinMode = 'normal';
						}
				}
				
				resizeTimeout.stop();
				
				dumpWindowState();   
			};
				
		}, false);
		
		window.on("close", function (e)
		{
			saveWindowState();
			window.close(true);
		}
		);
	}
	
	private static function initWindowState():Void
	{
		var windowState = Browser.getLocalStorage().getItem("windowState");
				
		if (windowState != null)
		{
			winState = js.Node.parse(windowState);
		}
				
		if (winState != null) 
		{
			currWinMode = winState.mode;
			if (currWinMode == 'maximized') 
			{
				window.maximize();
			} 
			else 
			{
				restoreWindowState();
			}
		} 
		else 
		{
			currWinMode = 'normal';
			dumpWindowState();
		}
		
		window.show();
	}

	private static function dumpWindowState():Void
	{
		if (winState == null) 
		{
			winState = {};
		}
		
		// we don't want to save minimized state, only maximized or normal
		if (currWinMode == 'maximized') 
		{
			winState.mode = 'maximized';
		}
		else 
		{
			winState.mode = 'normal';
		}
		
		// when window is maximized you want to preserve normal
		// window dimensions to restore them later (even between sessions)
		if (currWinMode == 'normal') 
		{
			winState.x = window.x;
			winState.y = window.y;
			winState.width = window.width;
			winState.height = window.height;
		}
	}

	private static function restoreWindowState():Void
	{
		window.resizeTo(winState.width, winState.height);
		window.moveTo(winState.x, winState.y);
	}

	private static function saveWindowState():Void
	{
		dumpWindowState();
		Browser.getLocalStorage().setItem("windowState", js.Node.stringify(winState));
	}
        
}

