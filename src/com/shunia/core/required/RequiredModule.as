package com.shunia.core.required
{
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	use namespace flash_proxy;
	
	public dynamic class RequiredModule extends Proxy
	{
		
		private var _id:String = null;
		private var _name:String = null;
		private var _type:int = 0;
		private var _fullPath:String = null;
		private var _exists:Boolean = false;
		
		private var _module:Object = null;
		private var _delayCalls:Dictionary = null;
		
		public function RequiredModule()
		{
			_delayCalls = new Dictionary();
		}
		
		public function get exists():Boolean
		{
			return _exists;
		}

		public function set exists(value:Boolean):void
		{
			_exists = value;
		}

		public function get fullPath():String
		{
			return _fullPath;
		}

		public function set fullPath(value:String):void
		{
			_fullPath = value;
		}

		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get id():String
		{
			return _id;
		}

		public function set id(value:String):void
		{
			_id = value;
		}

		override flash_proxy function callProperty(name:*, ...args):* {
			delayCache.apply(null, [name, args]);
		}
		
		override flash_proxy function setProperty(name:*, value:*):void {
			switch (name) {
				case "__module" : 
					_module = value;
					resolveDelayCalls();
					break;
				
				default : 
					delayCache.apply(null, [name, value]);
					break;
			}
		}
		
		override flash_proxy function getProperty(name:*):* {
			return null;
		}
		
		private function delayCache(key:String, ...args):void {
			if (_module) {
				resolveDelayCalls();
			} else {
				
			}
		}
		
		private function resolveDelayCalls():void {
			
		}
		
		private function onCall(key:String, ...args):void {
			
		}
		
		private function onFunctionCallParams(func:Function, params:Array, thisArgs:* = null):void {
			if (func == null) return;
			
			var funcLen:int = func.length;
			var paramsLen:int = params ? params.length : 0;
			if (paramsLen < funcLen) {
				params = params ? params.concat() : [];
				var len:int = funcLen - paramsLen;
				while (len) {
					len --;
					params.push(null);
				}
			}
			
			switch (func.length) {
				case 0 : 
					func.call(thisArgs);
					break;
				case 1 : 
					func.call(thisArgs, params[0]);
					break;
				case 2 : 
					func.call(thisArgs, params[0], params[1]);
					break;
				case 3 : 
					func.call(thisArgs, params[0], params[1], params[2]);
					break;
				case 4 : 
					func.call(thisArgs, params[0], params[1], params[2], params[3]);
					break;
				case 5 : 
					func.call(thisArgs, params[0], params[1], params[2], params[3], params[4]);
					break;
				case 6 : 
					func.call(thisArgs, params[0], params[1], params[2], params[3], params[4], params[6]);
					break;
				case 7 : 
					func.call(thisArgs, params[0], params[1], params[2], params[3], params[4], params[5], params[6]);
					break;
				case 8 : 
					func.call(thisArgs, params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7]);
					break;
				case 9 : 
					func.call(thisArgs, params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8]);
					break;
				
				default : 
					func.call(thisArgs);
					break;
			}
		}
		
	}
}