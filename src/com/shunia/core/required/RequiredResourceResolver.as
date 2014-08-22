package com.shunia.core.required
{
	public class RequiredResourceResolver implements IResourceResolver
	{
		
		protected var _exists:Boolean = false;
		
		public function RequiredResourceResolver(path:String)
		{
			trace("Resolving path: " + path);
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