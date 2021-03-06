package parser;
import byte.ByteData;
import cm.Editor;
import haxe.ds.StringMap.StringMap;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.Function;
import haxeparser.Data.ClassFlag;
import haxeparser.Data.Definition;
import haxeparser.Data.TypeDef;
import haxeparser.HaxeParser;
import hxparse.NoMatch;
import hxparse.Unexpected;
import js.Node;

/**
 * ...
 * @author 
 */
class ClassParser
{	
	public static var classList:Array<String> = [];
	public static var classCompletions:StringMap<Array<String>> = new StringMap();
	public static var filesList:Array<String> = [];
	
	static function parse(data:String, path:String)
	{
		var input = ByteData.ofString(data);
		var parser = new HaxeParser(input, path);
		var ast = null;
		
		try 
		{
			ast = parser.parse();
		}
		catch (e:NoMatch<Dynamic>) 
		{
			trace(e.pos.format(input) + ": Unexpected " + e.token.tok);
		}
		catch (e:Unexpected<Dynamic>) 
		{
			trace(e.pos.format(input) + ": Unexpected " + e.token.tok);
		} 
		catch (e:Dynamic)
		{			
			trace("Unhandled parsing error: ");
			trace(e);
		}
		
		return ast;
	}
	
	public static function processFile(data:String, path:String, std:Bool):Void 
	{
		var ast = parse(data, path);
		
		if (ast != null) 
		{
			processAst(ast, Node.path.basename(path, ".hx"), std);
		}
		else 
		{
			//trace("ast for " + path + " is null");
		}
	}
	
	static function processAst(ast:{decls:Array<TypeDef>, pack:Array<String>}, mainClass:String, std:Bool):Void
	{		
		parseDeclarations(ast, mainClass, std);
	}
	
	static function parseDeclarations(ast:{decls:Array<TypeDef>, pack:Array<String>}, mainClass:String, std:Bool) 
	{		
		for (decl in ast.decls) switch (decl) 
		{
			case EImport(sl, mode): 
			case EUsing(path): 
			case EAbstract(data): 
				var className:String = resolveClassName(ast.pack, mainClass, data.name);
				addClassName(className, std);
			case EClass(data): 
				var className:String = resolveClassName(ast.pack, mainClass, data.name);
				processClass(className, data);
				addClassName(className, std);
				
				//
				
				//if (processClass(data, pos)) 
				//{
					//break;
				//}
			case EEnum(data): 
				var className:String = resolveClassName(ast.pack, mainClass, data.name);
				addClassName(className, std);
			case ETypedef(data): 
				var className:String = resolveClassName(ast.pack, mainClass, data.name);
				addClassName(className, std);
		}
	}
	
	static function processClass(className:String, type:Definition<ClassFlag, Array<Field>>) 
	{
		var completions:Array<String> = [];
		
		for (i in 0...type.data.length)
		{
			if (getScope(type.data[i]))
			{
				completions.push(type.data[i].name);
			}
		}
		
		//switch (type.data[i].kind) 
		//{
			//case FFun(f):
				//
				//currentFunctionScopeType = getFunctionScope(type.data[i], f);
				//
				//if (pos > f.expr.pos.min && pos < f.expr.pos.max) 
				//{
					//if (processExpression(f.expr.expr, pos)) 
					//{
						//break;
					//}
				//}
			//case FVar(t, e):
				//completions.push(type.data[i].name);
				//trace(e);
				//currentFunctionScopeType = SClass;
			//case FProp(get, set, t, e):
				//completions.push(type.data[i].name);
				//currentFunctionScopeType = SClass;
		//}
		
		if (completions.length > 0) 
		{
			classCompletions.set(className, completions);
		}
	}
	
	static function getScope(field:Field) 
	{
		var isPublic:Bool = false;
		var access:Array<Access> = field.access;
		
		for (accessType in access)
		{
			switch (accessType) 
			{
				case APublic:
					isPublic = true;
				case AStatic:
				case AMacro:
				case AInline:
				case ADynamic:
				case AOverride:
				case APrivate:
			}
		}
		
		return isPublic;
	}
	
	static function resolveClassName(pack:Array<String>, mainClass:String, name:String):String 
	{
		var classPackage = pack.copy();
				
		if (name == mainClass) 
		{
			classPackage.push(name);
		}
		else 
		{
			classPackage.push(mainClass);
			classPackage.push(name);
		}
		
		var className= classPackage.join(".");
		return className;
	}
	
	static function addClassName(name:String, std:Bool):Void 
	{
		if (std) 
		{
			ClasspathWalker.haxeStdClassList.push(name);
		}
		
		if (classList.indexOf(name) == -1)
		{
			classList.push(name);
		}
	}
}