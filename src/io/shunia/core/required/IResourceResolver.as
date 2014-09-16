package io.shunia.core.required
{
	public interface IResourceResolver
	{
		
		function resolve(path:*):void;
		
		function get exists():Boolean;
		
		function get path():String;
		
		function get name():String;
		
		function get type():int;
		
	}
}