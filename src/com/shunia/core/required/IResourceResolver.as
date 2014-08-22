package com.shunia.core.required
{
	public interface IResourceResolver
	{
		
		function get exists():Boolean;
		
		function get path():String;
		
		function get name():String;
		
		function get type():int;
		
	}
}