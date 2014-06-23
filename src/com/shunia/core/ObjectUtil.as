package com.shunia.core
{
	public class ObjectUtil
	{
		
		/**
		 * 复制复杂对象属性.
		 * 
		 * 对于Object或者Dictionary,这种复制可以成功复制所有属性.
		 * 对于其他复杂对象来说,只能复制公开的可访问的属性.在这种情况下慎用,因为有可能会导致赋予属性的对象和被复制的对象持有同一引用.
		 * 
		 * 此方法不支持ByteArray.
		 *  
		 * @param target
		 * @param to
		 * @param props 限制可被复制的属性.如果定义该属性,当isInclude为false时,target上的属性只有在这个数组中才会被复制,反之当isInclude为true时,target上的属性如果在该数组中存在,则不会被复制.
		 */		
		public static function cloneTo(target:*, to:*, props:Array = null, isInclude:Boolean = true):void {
			//为空肯定不复制
			if (!target || !to) return;
			//简单类型不予复制
			if (isSimpleType(target) || isSimpleType(to)) return;
			
			var isSkip:Boolean = false;
			for (var k:* in target) {
				if (!k) continue;
				//定义了限制属性并且当前属性在限制属性里,则跳过
				if ((isInclude == false && props && props.indexOf(k) != -1) ||
					(isInclude == true && props && props.indexOf(k))) {
					isSkip = true;
				}
				if (!isSkip) {
					to[k] = target[k];
				}
			}
		}
		
		/**
		 * 判断对象是否为简单类型.
		 * 
		 * int, number, uint
		 * string
		 *  
		 * @param o
		 * @return 
		 */		
		public static function isSimpleType(o:*):Boolean {
			return ["number", "string"].indexOf(typeof(o)) != -1;
		}
		
		
	}
}