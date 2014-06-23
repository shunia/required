package com.shunia.core.required
{
	public class RequiredPath implements IPathResolver
	{
		public function RequiredPath(path:String)
		{
		}
		
		public function get id():String
		{
			return null;
		}
		
		public function get isLocalClassPossible():Boolean
		{
			return false;
		}
		
		public function get exists():Boolean {
			return false;
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