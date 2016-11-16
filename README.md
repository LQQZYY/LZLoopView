
# LZLoopView
基于swift3.0的轮播图

图片轮播在很多情况下都会用到,其他也有许多d类似的demo,但或多或少不能满足自己的需求,这是一个基于Swift 3.0编写的轮播图,可以自动加载URL中图片并缓存
其中,缓存的方法摘自**[ImageHelper](https://github.com/melvitax/ImageHelper)**,在此基础上做了调整,增加了取消当前请求的方法,
为了减少文件,此类中的其他方法没有加进去.
>注意:
在使用其他的轮播图时,关于定时器的释放都有问题,在轮播图页面消失后,定时器并没有被销毁,当前视图并没有被释放,造成内存泄露,这里提供了相关的解决方法
<br>
关于造成内存泄露的原因: 有一个说法是当Timer对象添加到RunLoop时,会被RunLoop强引用,同时Timer的对象会对其target对象强引用,从而形成循环引用


#相关属性
```Swift
// 轮播间隔.默认4s
    var interval: TimeInterval = 4.0
    // 轮播图片数组
    var dataSource: [Any]?
    // 是否自动轮播,默认true
    var isAuto: Bool = true
    // 标题是否设置背景, 默认false
    var ishasTitleBackground: Bool = false
    // 轮播图片标题
    var titles: [String]?
```
#创建LZLoopView
关于初始化,这里提供了多种方法:
###方法一:
使用系统的初始化方法,然后配置数据:
```Swift
let run2 = LZLoopView()
// 设置frame
run2.frame = CGRect(x: 0, y: 370, width: self.view.bounds.width, height: 100)
run2.interval = 2.0
// 添加图片
run2.dataSource = arr
// 添加标题文字
run2.addSubTitles(run.titles!, isHasBackground: true)
self.view.addSubview(run2)
```
###方法二:
使用提供的便利构造器创建:
```Swift
let run1 = LZLoopView.init(WithDatasource: arr, interval: 2)
        
run1.frame = CGRect(x: 0, y: 260, width: self.view.bounds.width, height: 100)
// 当点击某个图片时的回调时间
run1.didSelected { (index) in
            
            print("selected: \(index)")
      }
//每次滑动图片时的回调事件  
run1.didScrolled { (index) in
            
            print("scrollEnd: \(index)")
        }
self.view.addSubview(run1)
```
###方法三
使用提供的类方法创建,这里提供了三个:
```Swift
static func loopView(withFrame frame: CGRect, dataSource data: [Any], interval: TimeInterval) -> LZLoopView
static func loopView(withFrame frame: CGRect, dataSource data: [Any], interval: TimeInterval, didSelected: @escaping callBack) -> LZLoopView
static func loopView(withFrame frame: CGRect, dataSource data: [Any], interval: TimeInterval, didSelected: @escaping callBack, didScrolled: @escaping callBack) -> LZLoopView
```
区别只是回调方法的不同;
#关于回调
回调事件,这里提供了两种,一个是当点击图片时的响应事件,一个是每轮播一个图片回调一次事件:
```Swift
func didSelected(_ click: @escaping callBack)
func didScrolled(_ scroll: @escaping callBack)
```
#关于定时器(重要)
这里是最主要的,也是容易忽略的地方:
定时器的开启,默认是自动轮播的,也就是默认开启,也有使用方法开启,一般不需要调用:
```Swift
func startAutoRun()
```
定时器的停止,这里提供了一个方法:
```swift
func stopAutoRun()
```
#####需要注意的是: 在创建LZLoopView的控制器内,当使用结束l后,一定要调用这个方法来释放定时器,否则会引起内存泄露
当一个页面上添加了多个LZLoopView时,例如在tableViewCell中添加,这样再一个个调用这个方法来释放定时器,太麻烦,所以,这里我写了一个扩展,增加了两个方法:
```Swift
// 释放所有的定时器
static func invalidateAllTimer ()
// 添加定时器,参数只需将LZLoopView实例对象传过去即可
static func addTimer (_ loop: LZLoopView)
```
在创建LZLoopView实例的时候,调用addTimer添加,在需要释放定时器的时候调用invalidateAllTimer即可!!
也可以将LZLoopView实例对象的属性isNeedInvalidTimerLast打开,这样就会自动调用addTimer,但是释放的时候,一定要手动调用invalidateAllTimer
#效果图
<br/>
![](https://github.com/LQQZYY/LZLoopView/blob/master/创建文件1.gif)

#(完)
