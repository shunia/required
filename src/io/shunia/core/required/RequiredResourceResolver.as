package io.shunia.core.required
{
	import flash.utils.getQualifiedClassName;

	public class RequiredResourceResolver implements IResourceResolver
	{
		
		protected var _exists:Boolean = false;
		protected var _name:String = null;
		protected var _path:String = null;
		protected var _type:int = 0;
		
		public function RequiredResourceResolver()
		{
			init();
		}
		
		protected function init():void {
			_exists = false;
			_name = "";
			_path = path;
			_type = 0;
		}
		
		public function resolve(path:*):void {
			// reset
			init();
			
			var t:String = typeof(path);
			switch (typeof(path)) {
				case "string" : 
					var s:String = path as String;
					// get extension
					_name = s.substring(0, s.lastIndexOf("."));
					var ext:String = s.substring(s.lastIndexOf(".") + 1);
					if (ext && ext == "as") {
						// path ends with ".as" will be treated as aa as file.
						_exists = tryResolveToAsFile(s);
					} else if (!ext || ext == "swf") {
						// path ends with ".swf" or has no extend type will be treated as a swf file.
						_exists = tryResolveToSwf(s);
					} else {
						// no can do
						_exists = false;
					}
					break;
				case "class" : 
					// path as a class type will be treated as a internal class.
					var c:Class = path as Class;
					_name = getQualifiedClassName(c);
					_exists = c && tryResolveToClass(c);
					break;
			}
		}
		
		protected function tryResolveToSwf(path:String):Boolean {
			_type = requiredType.SWF;
			_path = path;
			return true;
		}
		
		protected function tryResolveToAsFile(path:String):Boolean {
			return false;
		}
		
		protected function tryResolveToClass(c:Class):Boolean {
			return false;
		}
		
		public function get exists():Boolean {
			return true;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get path():String
		{
			return _path;
		}
		
		public function get type():int
		{
			return _type;
		}
		
	}
}