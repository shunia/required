package
{
	import com.shunia.core.required.RequiredCore;
	import com.shunia.core.required.RequiredModule;
	
	/**
	 * 参照js的require模块实现的基于actionsctip的require模块.
	 * 
	 * 支持as类引用/.as文件/swf文件.
	 * 
	 * @param resource 要被请求的文件(swf,as文件,类)
	 * @param target 指向的目标,此参数的目的是将代码段所在的逻辑暂时冻结,以便之后异步调用
	 * @param id 可选参数.假设重复调用同一个resource,并且被调用的两个resource,在实例上需要区分开,可以通过传入此id来避免取出来的是同一个实例
	 */	
	public function required(resource:String, target:*, id:String = null):Object {
		var m:RequiredModule = RequiredCore.init(resource);
		
		if (m && m.exists) {
			trace("Requiring module: [" + resource + "] as a [" + 
				["SWF File", "Class", "ActionScript File"][
					[requiredType.SWF, requiredType.CLASS, requiredType.AS].indexOf(m.type)
				] +"]!");
		} else {
			trace("Required resource [" + resource + "] not avalible!");
		}
		
		return m;
	}
	
}