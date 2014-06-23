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
		private static var _pathResolverClass:Class = RequiredPath;
		
		public static function init(module:String, id:String = null):RequiredModule {
			var tmp:RequiredModule = new RequiredModule();
			if (id && id.length > 0) {
				tmp.id = id;
			}
			
			var p:IPathResolver = new _pathResolverClass(module) as IPathResolver;
			
			tmp.name = p.name;
			tmp.fullPath = p.path;
			tmp.exists = p.exists;
			tmp.type = p.type;
			
			if (!p.exists) {
				//不存在
			} else {
				//存在
				if (p.isLocalClassPossible) {
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
									
								}
							);
						}
					);
				} else {
					resolveExternalModule(
						tmp, 
						function (result:Object):void {
							tmp.__module = result;
						}, 
						function (error:Object):void {
							
						}
					);
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