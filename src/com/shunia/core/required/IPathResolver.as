package com.shunia.core.required
{
	public interface IPathResolver
	{
		
		function get isLocalClassPossible():Boolean;
		
		function get exists():Boolean;
		
		function get path():String;
		
		function get name():String;
		
		function get type():int;
		
		function get id():String;
		
	}
}