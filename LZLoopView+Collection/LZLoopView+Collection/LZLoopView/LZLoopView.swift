//
//  LZLoopView.swift
//  LZLoopView+Collection
//
//  Created by Artron_LQQ on 2016/11/17.
//  Copyright © 2016年 Artup. All rights reserved.
//


import UIKit

let reuseIdentifier: String = "LZLoopViewCellReuseIdentifier"

typealias loopClosure = (_ index: Int) -> Void
class LZLoopView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // 轮播图片,必传
    var images: [Any]!
    
    var titles: [String]? {
        
        didSet {
            
            guard titles != nil else {
                
                print("ERROR: property titles is nil")
                return
            }
            
            if (titles?.count)! > 0 {
                
                self.isHasTitle = true
            }
        }
    }
    var timeInterval: TimeInterval = 4.0
    var isAutoScroll: Bool = true
    var isChangeAutoScrollDeterectionWithDragging: Bool = true
    
    var pageColor: UIColor = UIColor.white
    var currentPageColor: UIColor = UIColor.gray
    
    private var timer: Timer?
    private var selected: loopClosure?
    private var scrolled: loopClosure?
    
    private var isAutoRunDeterectionLeft: Bool = true
    private var isHasTitle: Bool = false
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout.init()
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collection = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        
        collection.delegate = self
        collection.dataSource = self
        collection.isPagingEnabled = true
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        
        return collection
    }()
    
    private var titleLabel: UILabel = {
       
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white
        
        return label
    }()
    private lazy var pageControl: UIPageControl = {
       
        let page = UIPageControl.init()
        page.pageIndicatorTintColor = UIColor.gray
        page.currentPageIndicatorTintColor = UIColor.white
        page.currentPage = 0
        
        return page
    }()
    
    deinit {
        print("*****************************\n* LZLoopView success deinit *\n*****************************")
        
        self.stopTimer()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.collectionView.register(LZLoopViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 类方法创建LZLoopView实例对象
    ///
    /// - Parameters:
    ///   - view: 需要添加到的父视图, 必传
    ///   - frame: frame ,必传
    ///   - images: 轮播图片, 必传
    ///   - titles: 轮播图标题, 可选 默认为nil
    ///   - select: 选择某个图片的回调方法, 可选
    ///   - scroll: 轮播滚动到某个图片的回调方法, 可选
    /// - Returns: 返回LZLoopView实例对象
    static func loopViewOn(_ view: UIView, frame: CGRect, images: [Any], titles: [String]? = nil, didSelected select: loopClosure? = nil, didScrolled scroll: loopClosure? = nil) -> LZLoopView {
        
        let loop = LZLoopView.init(frame: frame)
        view.addSubview(loop)
        
        loop.images = images
        loop.selected = select
        loop.scrolled = scroll
        if titles != nil {
            
            loop.titles = titles
        }
        return loop
    }
    
    @objc private func autoRun() {
        
        var offset = self.collectionView.contentOffset
        
        if self.isAutoRunDeterectionLeft == true {
            
            offset.x += self.frame.width
            
            if offset.x - CGFloat(Int(offset.x)) != 0.0 {
                
                offset.x += 1
            }
        } else {
            
            offset.x -= self.frame.width
            
            if offset.x - CGFloat(Int(offset.x)) != 0.0 {
                
                offset.x -= 1
            }
        }
        self.collectionView.scrollRectToVisible(CGRect.init(x: offset.x, y: 0, width: self.frame.width, height: self.frame.height), animated: true)
    }
    
    func startTimer() {
        
        if self.timer == nil {
            
            
            self.timer = LZTimer.scheduledTimer(timeInterval: self.timeInterval, target: self, selector: #selector(autoRun), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer() {
        
        if self.timer != nil {
            
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    func didSelected(_ select: @escaping loopClosure) {
        
        self.selected = select
    }
    
    func didScrolled(_ scroll: @escaping loopClosure) {
        
        self.scrolled = scroll
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard self.images != nil else {
            
            print("ERROR: \"The property images must not be nil, please set the images to be displayed\"")
            return
        }
        
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.frame = self.bounds
        self.addSubview(self.collectionView)
        
        self.pageControl.frame = CGRect(x: 0, y: self.frame.height - 16, width: self.frame.width, height: 14)
        
        self.pageControl.numberOfPages = self.images.count
        self.addSubview(self.pageControl)
        
        self.collectionView.scrollToItem(at: IndexPath.init(item: 0, section: 1), at: .centeredHorizontally, animated: false)
        
        if self.isHasTitle {
            
            self.titleLabel.frame = CGRect(x: 10, y: self.pageControl.frame.minY - 16, width: self.frame.width - 20, height: 14)
            self.addSubview(self.titleLabel)
        }
        
        
        if self.isAutoScroll {
            
            self.startTimer()
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LZLoopViewCell
        
        cell.obj = self.images[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let select = self.selected {
            
            select(indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.frame.width, height: self.frame.height)
    }
    
    private func keepInMiddle() {
        
        let temp = self.collectionView.contentOffset.x / self.frame.width
        
        var index: Int = Int(temp)
        
        if temp - CGFloat(index) > 0.0 {
            
            index += 1
        }
        
        self.pageControl.currentPage = index % self.images.count
        
        if self.collectionView.contentOffset.x < self.frame.width*CGFloat(self.images.count) || self.collectionView.contentOffset.x > self.frame.width * CGFloat(self.images.count*2 - 1) {
            
            self.collectionView.scrollToItem(at: IndexPath.init(row: index%self.images.count, section: 1), at: .centeredHorizontally, animated: false)
        }

        if let scroll = self.scrolled {
            
            scroll(self.pageControl.currentPage)
        }
        
        if self.isHasTitle {
            
            guard self.pageControl.currentPage < (self.titles?.count)! else {
                
                return
            }
            
            self.titleLabel.text = self.titles?[self.pageControl.currentPage]
        }
    }
    
    // 手动滑动开始时移除定时器,防止滚动多页
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        self.stopTimer()
    }
    // 手动滑动结束时开启定时器, 自动滚动
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        self.startTimer()
    }
    // 手动滑动结束时, 调整视图位置, 使之一直处在中间一个区
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        self.keepInMiddle()
    }
    // 定时器自动滚动结束时, 调整视图位置, 使之一直处在中间一个区
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        self.keepInMiddle()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if self.isChangeAutoScrollDeterectionWithDragging == false {
            
            return
        }
        
        let point = targetContentOffset.pointee
        
        self.isAutoRunDeterectionLeft = point.x - scrollView.contentOffset.x > 0 ? true : false
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
