package io.shunia.core.required
{
	import flash.utils.Dictionary;
	
	import io.shunia.core.net.loaders.LoaderProxy;
	import io.shunia.core.net.loaders.LoaderProxyOption;

	/**
	 * Require核心.
	 *  
	 * @author 庆峰
	 */	
	public class RequiredCore
	{
		
		/**
		 * 增长型的值用于标识不同的模块引用. 
		 */		
		private static var _id:int = 0;
		/**
		 * 缓存加载中的模块.
		 */		
		private static var _loadingCache:Dictionary = new Dictionary();
		/**
		 * 缓存已加载的模块.通过模块name和模块实例作为k-v对.<br/>
		 * 因为整个required库在目前的版本里是使用简单缓存策略的,即被required的每个模块都只在内存里保留一份引用,所以对于同一个模块,这个缓存里永远只有一份实例.
		 */		
		private static var _loadedCache:Dictionary = new Dictionary();
		/**
		 * 路径解析类定义.目前使用默认解析逻辑. 
		 * 
		 * 考虑到之后可能会用不同的解析逻辑去进行测试和调整,把这里先提出来为可替换的概念.
		 */		
		private static var _resolverClass:Class = RequiredResourceResolver;
		/**
		 * 路径解析类实例. 
		 */		
		protected static var _resolver:IResourceResolver = new _resolverClass() as IResourceResolver;
		
		public static function init(resource:*, id:String = null):RequiredModule {
			var rm:RequiredModule = null;
			
			// 先尝试解析出具体的路径等属性
			_resolver.resolve(resource);
			
			// id策略
			var tmpId:String = id ? id : _resolver.name;
//			if (id && id.length > 0) {
//				tmpId = id;
//			} else {
//				tmpId = _resolver.name + _id;
//				_id ++;
//			}
			
			// 带id的缓存查找
			var cached:RequiredModule = matchCachedModule(resource, tmpId);
			if (cached) {
				// 命中直接返回
				rm = cached;
			} else {
				// 没缓存的情况下,如果解析后证明不存在,返回空
				if (!_resolver.exists) return rm;
				// 否则新建一个
				rm = resolveToModule(_resolver, tmpId);
				if (rm) {
					// 加载去
					sendToLoad(resource, rm)
					// 缓存起来
					cacheLoadingModule(resource, rm);
				}
			}
			
			return rm;
		}
		
		protected static function cacheLoadingModule(resource:*, module:RequiredModule):void {
			var caches:Array = _loadingCache[resource];
			!caches && (caches = []) && (_loadingCache[resource] = caches);
			caches.indexOf(module) == -1 && caches.push(module);
		}
		
		protected function cacheLoadedModule(resource:*, module:RequiredModule):void {
			// 先从加载缓存里删掉
			var caches:Array = _loadingCache[resource];
			caches.splice(caches.indexOf(module), 1);
			// 放到已加载缓存里
			caches = _loadedCache[resource];
			!caches && (caches = []) && (_loadedCache[resource] = caches);
			caches.indexOf(module) == -1 && caches.push(module);
		}
		
		protected static function matchCachedModule(resource:*, id:String = null):RequiredModule {
			var caches:Array = null;
			var match:RequiredModule = null;
			
			var foreach:Function = function (o:Array, key:String, v:*):Object {
				if (o) {
					var find:Object = null;
					for each (find in o) {
						if (find[key] == v) {
							return find;
						}
					}
				}
				return null;
			};
			
			// 如果已经加载完,返回加载好的内容
			!match && _loadedCache[resource] && (caches = _loadedCache[resource]);
			match = foreach(caches, "id", id);
			// 否则从正在加载的队列中搜寻是否有符合当前加载逻辑的相同项
			!match && _loadingCache[resource] && (caches = _loadingCache[resource]);
			match = foreach(caches, "id", id);
			
			return match;
		}
		
		protected static function resolveToModule(resolver:IResourceResolver, id:String = null):RequiredModule {
			var rm:RequiredModule = new RequiredModule();
			
			rm.type = resolver.type;
			rm.name = resolver.name;
			rm.path = resolver.path;
			rm.exists = resolver.exists;
			rm.id = id;
			
			return rm;
		}
		
		protected static function sendToLoad(resource:*, module:RequiredModule):Boolean {
			if (!module.exists) {
				//不存在
				return false;
			} else {
				//存在
				switch (module.type) {
					case requiredType.SWF : 
						loadExternalModule(
							module, 
							function (result:Object):void {
								module.__module = result;
								_loadedCache[resource] = module;
							}, 
							function (error:Object):void {
								module.__error = new Error("Resolving external module error: " + error.code + "|" + error.msg);
							}
						);
						break;
					case requiredType.AS : 
						loadExternalASFile(module, 
							function (result:Object):void {
								
							}, 
							function (error:Object):void {
								
							}
						);
						break;
					case requiredType.CLASS : 
						loadLocalClass(
							module, 
							function (result:Object):void {
								module.__module = result as Class;
							}, 
							function (error:Object):void {
								loadExternalASFile(
									module,
									function (result:Object):void {
										module.__module = result;
									}, 
									function (error:Object):void {
										module.__error = new Error("Resolving external as file error: " + error.code + "|" + error.msg);
									}
								);
							}
						);
						break;
				}
				return true;
			}
		}
		
		private static function loadLocalClass(m:Object, result:Function, fail:Function):void {
			
		}
		
		private static function loadExternalASFile(m:Object, result:Function, fail:Function):void {
			
		}
		
		private static function loadExternalModule(m:Object, result:Function, fail:Function):void {
			var loader:LoaderProxy = new LoaderProxy();
			var option:LoaderProxyOption = new LoaderProxyOption(
				m.path, 
				LoaderProxyOption.FORMAT_SWF, 
				LoaderProxyOption.TYPE_ASSET_LOADER, 
				result, 
				fail
			);
			loader.load(option);
		}
		
	}
}