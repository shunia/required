required
========

An ActionScript3 implementation of common JS require package.(In progress)

2014/06/23:
还只是一个不成熟的想法.
因为真实的require模块在JS中各有不同的实现逻辑.在NodeJS中是异步IO为主,在SeaJS中主要是控制使用了require模块的代码段的运行时序.
在ActionScript3中,不管是异步IO还是代码段的时序控制都很难实现.所以尝试结合三种方式来处理:
1.用loader来异步处理swf模块
2.用include来编译时动态包裹.as文件
3.用类引用在运行时实现伪require