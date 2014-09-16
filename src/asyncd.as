package
{
	import io.shunia.core.required.RequiredModule;
	
	/**
	 * required的异步加载方式,不会同步返回代理类,而只能通过回调方法进行使用.<br/>
	 * 跟required方式的调用本质上是一样的,只是手法不同,适合不想污染全局的异步使用情况. 
	 */	
	public function asyncd(resource:*, onComplete:Function, id:String = null):void {
		var m:RequiredModule = required(resource, id);
		m.onComplete = onComplete;
	}
	
}