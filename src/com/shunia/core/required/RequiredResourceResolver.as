package com.shunia.core.required
{
	public class RequiredResourceResolver implements IResourceResolver
	{
		
		protected var _exists:Boolean = false;
		protected var _name:String = null;
		protected var _path:String = null;
		protected var _type:int = 0;
		
		public function RequiredResourceResolver(path:String)
		{
			trace("Resolving path: " + path);
			
			_exists = path;
			_name = "";
			_path = path;
			_type = 0;
		}
		
		public function get exists():Boolean {
			return true;
		}
		
		public function get name():String
		{
			return null;
		}
		
		public function get path():String
		{
			return null;
		}
		
		public function get type():int
		{
			return 0;
		}
		
	}
}