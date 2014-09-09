package
{
	import com.shunia.core.required.RequiredCore;
	import com.shunia.core.required.RequiredModule;
	
	/**
	 * 参照js的require模块实现的基于actionsctip的require模块.
	 * 
	 * 支持as类引用/.as文件/swf文件.
	 * 
	 * 当支持swf文件时:
	 * 	路径默认支持绝对路径,提供相对路径将不会做特殊处理,也可用,但是不建议使用.比如 "http://www.foo.com/bar.swf".
	 * 	将会触发跨域请求,所以请确保域下有正确的crossdomain定义.
	 * 当支持as类引用时:
	 * 	提供的是类引用,比如"DisplayObject"
	 * 当支持.as文件时:
	 *  必须是提供的as文件相对于src目录的路径如"com/adobe/util/StringUtil.as"
	 * 
	 * @param resource 要被请求的文件(swf,as文件,类)
	 * @param target 指向的目标,此参数的目的是将代码段所在的逻辑暂时冻结,以便之后异步调用
	 * @param id 可选参数.假设重复调用同一个resource,并且被调用的两个resource,在实例上需要区分开,可以通过传入此id来避免取出来的是同一个实例
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