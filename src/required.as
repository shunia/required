package
{
	import io.shunia.core.required.RequiredCore;
	import io.shunia.core.required.RequiredModule;
	
	/**
	 * 基于actionsctip3的通用模块加载器,概念上借鉴nodejs的require库.
	 * 加载同步返回代理对象,可以直接操作set和function.<br/>
	 * 
	 * 支持as类引用/.as文件/swf文件.<br/>
	 * 当支持swf文件时:
	 * 	路径默认支持绝对路径,提供相对路径将不会做特殊处理,也可用,但是不建议使用.比如 "http://www.foo.com/bar.swf".
	 * 	将会触发跨域请求,所以请确保域下有正确的crossdomain定义.
	 * 当支持as类引用时:
	 * 	提供的是类引用,比如 DisplayObject (非字符串,而是实际的类定义)
	 * 当支持.as文件时:
	 *  必须是提供的as文件相对于src目录的路径如"com/adobe/util/StringUtil.as"
	 * 
	 * @param resource 要被请求的文件(swf,as文件,类)
	 * @param id 可选参数.假设重复调用同一个resource,并且被调用的两个resource,在实例上需要区分开,可以通过传入此id来避免取出来的是同一个实例.<br/>
	 * 对于required库来说,每一次默认require,都会返回一个RequiredModule对象.该对象在不指定id的情况下,应该只允许存在一个.但是想像这样一种情况:<br/>
	 * 在同一个时序里,对同一个模块进行两次require,这时假如返回同一个RequiredModule对象,并且都注册了onComplete回调,那么后一个时序的回调方法会覆盖前一个,从而导致前一个回调无法触发.<br/>
	 * 这个问题可以通过在RequiredModule的onComplete注册里提供一个数组进行缓存就可以解决.但是这种缓存方式因为RequiredModule不会清理回调方法的原因(为了保障多次调用的异步回调有效被触发),有可能导致不能正确的gc回调方法.<br/>
	 * id参数的存在就是为了提供另外一种策略,即通过提供显式的id定义,让required库返回一个新的RequiredModule.这样依然可以依赖于核心的最简缓存策略,同时也可以在更高的层面(核心)增加gc策略.
	 */	
	public function required(resource:*, id:String = null):RequiredModule {
		var m:RequiredModule = null;
		
		try {
			m = RequiredCore.init(resource);
		} catch (e:Error) {
			trace("Error occured: " + e.message);
		}
		
		if (m && m.exists) {
			trace("Required module: [" + resource + "] as a [" + 
				["SWF File", "Class", "ActionScript File"][
					[requiredType.SWF, requiredType.CLASS, requiredType.AS].indexOf(m.type)
				] +"]!");
		} else {
			trace("Required resource [" + resource + "] not avalible!");
		}
		
		return m;
	}
	
}