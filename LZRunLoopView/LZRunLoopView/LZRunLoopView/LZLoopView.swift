//
//  LZRunLoopView.swift
//  LZRunLoopView
//
//  Created by Artron_LQQ on 2016/11/14.
//  Copyright © 2016年 Artup. All rights reserved.
//

import UIKit

typealias callBack = (_ index: Int) -> Void
class LZLoopView: UIView, UIScrollViewDelegate {

    var interval: TimeInterval = 3.0
    var dataSource: [Any]?
    var isAuto: Bool = true
    
    var ishasTitleBackground: Bool = false
    var titles: [String]? {
        
        didSet {
            
            self.isHasTitle = true
            self.ishasTitleBackground = true
        }
    }
    
    lazy var pageControl: UIPageControl = {
        
        let page = UIPageControl()
        
        page.numberOfPages = (self.dataSource?.count)!
        page.currentPage = 0
        page.currentPageIndicatorTintColor = UIColor.red
        page.pageIndicatorTintColor = UIColor.gray
        return page
    }()
    
    private var didSelected: callBack?
    private var didScrolled: callBack?
    
    // 副标题相关
    private var isHasTitle: Bool = false
    
    private lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white
        return label
    }()
    
    private lazy var titleBackground: UIView = {
        
        let bg = UIView()
        
        bg.backgroundColor = UIColor.black
        bg.alpha = 0.2
        return bg
    }()
    
    private lazy var scroll: UIScrollView = {
        
        let scroll = UIScrollView()
        
        scroll.delegate = self
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.bounces = false
        scroll.isPagingEnabled = true
        
        return scroll
    }()
    
    private var images: [UIImageView] = []
    var timer: Timer? = nil
    private var currentIndex = 0
    
    deinit {
        print("*******************************")
        print("LZRunloopView deinit")
        print("*******************************")
    }
    
    
    // 类方法创建
    static func loopView(withFrame frame: CGRect, dataSource data: [Any], interval: TimeInterval, didSelected: @escaping callBack) -> LZLoopView {
        
        let loop = LZLoopView(frame: frame)
        loop.interval = interval
        
        loop.didSelected = didSelected
        if let arr = loop.dataSource {
            if arr.count > 0 {
                
                loop.dataSource?.removeAll()
            }
        }
        loop.dataSource = data
        
        return loop
    }
    
    static func loopView(withFrame frame: CGRect, dataSource data: [Any], interval: TimeInterval, didSelected: @escaping callBack, didScrolled: @escaping callBack) -> LZLoopView {
        
        let loop = LZLoopView(frame: frame)
        loop.interval = interval
        
        loop.didSelected = didSelected
        loop.didScrolled = didScrolled
        
        if let arr = loop.dataSource {
            if arr.count > 0 {
                
                loop.dataSource?.removeAll()
            }
        }
        loop.dataSource = data
        
        return loop
    }
    
    convenience init(WithDatasource data: [Any], interval: TimeInterval) {
        self.init()
        
        self.interval = interval
        
        if let arr = self.dataSource {
            if arr.count > 0 {
                
                self.dataSource?.removeAll()
            }
        }
        self.dataSource = data
    }
    
    func addDataSource(_ data: [Any], interval: TimeInterval) {
        
        self.interval = interval
        
        if let arr = self.dataSource {
            if arr.count > 0 {
                
                self.dataSource?.removeAll()
            }
        }
        self.dataSource = data
    }
    
    func addSubTitles(_ title: [String], isHasBackground isHas: Bool) {
        
        self.titles = title
        self.ishasTitleBackground = isHas
        self.isHasTitle = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        
        
        for _ in 0..<3 {
            
            let img = UIImageView()
            self.scroll.addSubview(img)
            self.images.append(img)
            
            img.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(imageTapped))
            img.addGestureRecognizer(tap)
        }
    }
    
    func didSelected(_ click: @escaping callBack) {
        
        self.didSelected = click
    }
    
    func didScrolled(_ scroll: @escaping callBack) {
        
        self.didScrolled = scroll
    }
    
    func startAutoRun() {
        
        if self.timer == nil {
            
            self.timer = Timer.scheduledTimer(timeInterval: (self.interval), target: self, selector: #selector(autoRun), userInfo: nil, repeats: true)
            
//            RunLoop.main.add(self.timer!, forMode: RunLoopMode.commonModes)
            
            LZLoopView.addTimer(self)
        }
    }
    
    func stopAutoRun() {
        
        if (timer != nil) {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc private func imageTapped() {
        
        if let callBack = self.didSelected {
            
            callBack(currentIndex)
        }
    }
    
    @objc private func autoRun() {
        
        let offset = CGPoint(x: 2*self.bounds.width, y: 0)
        
        self.scroll.setContentOffset(offset, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func resetImageView() {
        
        if self.currentIndex == 0 {
            // 显示的是第一张
            let rightIndex = (self.dataSource?.count)! > 1 ? 1 : 0
            
            self.setImageAt(left: self.dataSource?.last ?? "", middle: self.dataSource?.first ?? "", right: self.dataSource?[rightIndex] ?? "")
            
        } else if self.currentIndex == (self.dataSource?.count)! - 1 {
            // 显示的是最后一张
            self.setImageAt(left: self.dataSource![self.currentIndex - 1], middle: self.dataSource?.last ?? "", right: self.dataSource?.first ?? "")
        } else {
            // 其他
            self.setImageAt(left: self.dataSource?[self.currentIndex - 1] ?? "", middle: self.dataSource?[self.currentIndex] ?? "", right: self.dataSource?[self.currentIndex+1] ?? "")
        }
    }
    
    private func setSubTitle() {
        
        self.titleLabel.text = self.titles?[currentIndex]
    }
    
    // TODO: 网络加载图片方法
    private func setImageAt(left: Any, middle: Any, right: Any) {
        
        let leftImg = self.images.first! as UIImageView
        let middleImg = self.images[1] as UIImageView
        let rightImg = self.images.last! as UIImageView
        
        leftImg.cancelCurrentRequest()
        middleImg.cancelCurrentRequest()
        rightImg.cancelCurrentRequest()
        
        leftImg.imageFromURL(left as! String, placeholder: UIImage())
        middleImg.imageFromURL(middle as! String, placeholder: UIImage())
        rightImg.imageFromURL(right as! String, placeholder: UIImage())
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.scroll.frame = self.bounds
        self.addSubview(self.scroll)
        self.scroll.contentSize = CGSize(width: 3 * self.bounds.width, height: self.bounds.height)
        scroll.contentOffset = CGPoint(x: self.bounds.width, y: 0)
        
        for i in 0..<3 {
            
            let img = self.images[i]
            img.frame = CGRect(x: self.bounds.width*CGFloat(i), y: 0, width: self.bounds.width, height: self.bounds.height)
        }
        
        self.pageControl.bounds = CGRect(x: 0, y: 0, width: self.bounds.width, height: 14)
        self.pageControl.center = CGPoint(x: self.center.x, y: self.bounds.maxY - self.pageControl.bounds.midY)
        self.addSubview(self.pageControl)
        
        if (self.dataSource?.count)! > 0 {
            self.resetImageView()
        }
        
        if self.isHasTitle {
            
            if let titles = self.titles {
                
                if titles.count > 0 {
                    
                    var titleLabelHeight = self.frame.height*0.2
                    // 限制标题高度 最大30   最小10
                    titleLabelHeight = titleLabelHeight > 30 ? 30: titleLabelHeight
                    
                    titleLabelHeight = titleLabelHeight < 10 ? 10 : titleLabelHeight
                    
                    self.titleLabel.frame = CGRect(x: 10, y: self.pageControl.frame.minY - titleLabelHeight - 2, width: self.frame.width - 20, height: titleLabelHeight)
                    if self.ishasTitleBackground {
                        
                        self.titleBackground.frame = CGRect(x: 0, y: self.pageControl.frame.minY - titleLabelHeight - 4, width: self.frame.width, height: titleLabelHeight + 6 + self.pageControl.frame.height)
                        self.addSubview(self.titleBackground)
                    }
                    
                    self.addSubview(self.titleLabel)
                    
                    self.setSubTitle()
                }
            }
        }
        
        
//        self.scroll.backgroundColor = UIColor.orange
//        self.pageControl.backgroundColor = UIColor.cyan
        
        if self.isAuto {
            
            self.startAutoRun()
        }
    }
    // 这个方法会多次调用, 暂不用
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//        print("scrollViewDidScroll")
//        
//    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        self.resetOffset(scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        self.stopAutoRun()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        self.startAutoRun()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        self.resetOffset(scrollView)
    }
    
    func resetOffset(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.x
        // 向左滑动
        if (self.dataSource?.count)! > 0 {
            
            if offset >= self.bounds.width*2 {
                
                scrollView.contentOffset = CGPoint(x: self.bounds.width, y: 0)
                
                self.currentIndex = self.currentIndex + 1
                if self.currentIndex == self.dataSource?.count {
                    self.currentIndex = 0
                }
            }
            // 向右滑动
            if offset <= 0 {
                
                scrollView.contentOffset = CGPoint(x: self.bounds.width, y: 0)
                
                self.currentIndex = self.currentIndex - 1
                
                if self.currentIndex < 0 {
                    
                    self.currentIndex = (self.dataSource?.count)! - 1
                }
            }
            
            self.resetImageView()
            self.pageControl.currentPage = self.currentIndex
        }
        
        self.setSubTitle()
        // 滚动结束,回调
        if let back = self.didScrolled {
            
            back(self.currentIndex)
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
// ************************************************************************************************************
// MARK: - 销毁定时器的extension

// 手动销毁所有定时器,避免循环引用内存泄露
// 建议在页面有多个LZRunLoopView的情况下使用,例如在UITableViewCell中使用时
// 单个视图可调用stopAutoRun来销毁
var __timers: [Timer?] = []
extension LZLoopView {
    
    static func invalidateAllTimer () {
        
        for timer in __timers {
            
            if timer != nil {
                
                timer?.invalidate()
            }
        }
        
        __timers.removeAll()
    }
    
    static func addTimer (_ timer: LZLoopView) {
        
        __timers.append(timer.timer)
    }
}
