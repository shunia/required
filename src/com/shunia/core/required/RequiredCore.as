package com.shunia.core.required
{

	/**
	 * Require核心.
	 *  
	 * @author 庆峰
	 */	
	public class RequiredCore
	{
		
		/**
		 * 路径解析类定义.
		 * 目前使用默认解析逻辑. 
		 */		
		private static var _resolverClass:Class = RequiredResourceResolver;
		protected static var _resolver:IResourceResolver = new _resolverClass() as IResourceResolver;
		
		public static function init(module:*, id:String = null):RequiredModule {
			var tmp:RequiredModule = new RequiredModule();
			if (id && id.length > 0) {
				tmp.id = id;
			}
			
			_resolver.resolve(module);
			
			tmp.type = _resolver.type;
			tmp.name = _resolver.name;
			tmp.fullPath = _resolver.path;
			tmp.exists = _resolver.exists;
			
			if (!tmp.exists) {
				//不存在
			} else {
				//存在
				switch (tmp.type) {
					case requiredType.SWF : 
						resolveExternalModule(
							tmp, 
							function (result:Object):void {
								tmp.__module = result;
							}, 
							function (error:Object):void {
								throw new Error("Resolving external module error: " + error.code + "|" + error.msg);
							}
						);
						break;
					case requiredType.AS : 
						resolveExternalASFile(tmp, 
							function (result:Object):void {
								
							}, 
							function (error:Object):void {
								
							}
						);
						break;
					case requiredType.CLASS : 
						resolveLocalClass(
							tmp, 
							function (result:Object):void {
								tmp.__module = result as Class;
							}, 
							function (error:Object):void {
								resolveExternalASFile(
									tmp,
									function (result:Object):void {
										tmp.__module = result;
									}, 
									function (error:Object):void {
										throw new Error("Resolving external as file error: " + error.code + "|" + error.msg);
									}
								);
							}
						);
						break;
				}
			}
			
			return tmp;
		}
		
		private static function resolveLocalClass(m:Object, result:Function, fail:Function):void {
			
		}
		
		private static function resolveExternalASFile(m:Object, result:Function, fail:Function):void {
			
		}
		
		private static function resolveExternalModule(m:Object, result:Function, fail:Function):void {
			
		}
		
	}
}