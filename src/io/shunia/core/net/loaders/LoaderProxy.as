package io.shunia.core.net.loaders
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import io.shunia.core.net.loaders.resolver.BinaryResolver;
	import io.shunia.core.net.loaders.resolver.IManuallyResolver;
	import io.shunia.core.net.loaders.resolver.JSONResolver;
	import io.shunia.core.net.loaders.resolver.XMLResolver;

	/**
	 * 加载器.需要配合LoaderProxyOption类进行使用.
	 * 根据option中的配置,实例化并进行不同类型的加载.
	 * 自动重试.允许中途取消.
	 *  
	 * @author shunia-17173
	 */	
	public class LoaderProxy
	{
		
		private static const RETRY_INTERVAL:int = 2000;
		private static const RETRY:int = 3;
		
		private var _retry:int = 0;
		private var _retryFlag:int = -1;
		private var _option:LoaderProxyOption = null;
		
		public function LoaderProxy(option:LoaderProxyOption = null, autoStart:Boolean = false)
		{
			_option = option;
			
			if (autoStart && option) {
				loadInternal();
			}
		}
		
		public function load(option:LoaderProxyOption):void {
			_option = _option && option == null ? _option : option;
			
			loadInternal();
		}
		
		private function loadInternal():void {
			_retry ++;
			var loaderInfo:Object = _option.getLoader();
			var loader:Object = loaderInfo.loader;
			var req:URLRequest = loaderInfo.request;
			var handler:IEventDispatcher = loaderInfo.handler;
			var loaderDataKey:String = loaderInfo.key;
			handler.addEventListener(Event.COMPLETE, function (e:Event):void {
				var result:* = null;
				if (loaderDataKey && loader.hasOwnProperty(loaderDataKey)) {
					result = loader[loaderDataKey];
				} else {
					result = loader;
				}
				var resolver:Class = null;
				if (_option.manuallyResolver) {
					resolver = _option.manuallyResolver;
				} else {
					resolver = getDefaultResolver();
				}
				if (resolver) {
					try {
						if (resolver) {
							var resolveInstance:IManuallyResolver = IManuallyResolver(new resolver());
							result = resolveInstance.resolve(result);
						}
					} catch (er:Error) {
						if (_option.onFault != null) {
							var obj:Object = {"code":er.errorID, "msg":er.message};
							_option.onFault.apply(null, [obj]);
						}
					}
					if (result && _option.onSuccess != null) {
						_option.onSuccess.apply(null, [result]);
					}
				} else {
					if (_option.onSuccess != null) {
						_option.onSuccess.apply(null, [result]);
					}
				}
			});
			//handler init event(only for swf files)
			handler.addEventListener(Event.INIT, function (e:Event):void {
				if (_option.onAvaliable != null) {
					_option.onAvaliable.apply(null, [loader]);
				}
			});
			//handle errors
			handler.addEventListener(IOErrorEvent.IO_ERROR, function (e:IOErrorEvent):void {
				if (!retry()) {
					if (_option.onFault != null) {
						var obj:Object = {"code":e.errorID, "msg":e.text};
						_option.onFault.apply(null, [obj]);
					}
				}
			});
			//handler securityError
			handler.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function (e:SecurityErrorEvent):void {
				if (_option.onFault != null) {
					var obj:Object = {"code":e.errorID, "msg":e.text};
					_option.onFault.apply(null, [obj]);
				}
			});
			
			if (loader is URLLoader) {
				var d:URLVariables = req.data as URLVariables;
				if (d == null) {
					d = new URLVariables();
				}
				if (d.toString().indexOf("&t=") == -1 && req.url.indexOf("&t=") == -1 && req.url.indexOf("?t=") == -1) {
					d.decode("t=" + new Date().time);
				}
				req.data = d;
				URLLoader(loader).load(req);
			} else {
				var context:LoaderContext = null;
				if (_option.allowSecurityCheck) {
					context = new LoaderContext(true, ApplicationDomain.currentDomain);
					//security模型在本地是不能使用的,所以在这里加一个判断,看是否是本地调试或者测试
					var domain:SecurityDomain = null;
					if (Security.sandboxType == Security.REMOTE) {
						domain = SecurityDomain.currentDomain;
					}
					context.securityDomain = domain;
				}
				loader.load(req, context);
			}
		}
		
		private function retry():Boolean {
			if (_retry < RETRY) {
				_retryFlag = setTimeout(function ():void {
					if (_retryFlag >= 0) {
						clearTimeout(_retryFlag);
						_retryFlag = -1;
					}
					
					loadInternal();
				}, RETRY_INTERVAL * _retry);
				return true;
			} else {
				return false;
			}
		}
		
		private function getDefaultResolver():Class {
			switch (_option.format) {
				case LoaderProxyOption.FORMAT_JSON : 
					return JSONResolver;
					break;
				case LoaderProxyOption.FORMAT_BINARY : 
					return BinaryResolver;
					break;
				case LoaderProxyOption.FORMAT_XML : 
					return XMLResolver;
					break;
			}
			return null;
		}
		
		public function cancel():void {
			if (_retryFlag >= 0) {
				clearTimeout(_retryFlag);
				_retryFlag = -1;
			}
			_retry = RETRY;
			_option.onSuccess = null;
			_option.onFault = null;
		}
		
		public function get option():LoaderProxyOption
		{
			return _option;
		}

		public function set option(value:LoaderProxyOption):void
		{
			_option = value;
		}
		
	}
	
}