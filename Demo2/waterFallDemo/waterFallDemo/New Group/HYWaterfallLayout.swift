//
//  HYWaterfallLayout.swift
//  waterFallDemo
//
//  Created by yangrui on 2018/8/30.
//  Copyright © 2018年 yangrui. All rights reserved.
//

import UIKit


protocol HYWaterfallLayoutDataSource : class {
    func numberOfCols(_ waterfall : HYWaterfallLayout) -> Int
    func waterfall(_ waterfall : HYWaterfallLayout, item : Int) -> CGFloat
}

class HYWaterfallLayout: UICollectionViewFlowLayout {
    
    weak var dataSource : HYWaterfallLayoutDataSource?
    
    fileprivate lazy var cellAttrs : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    fileprivate lazy var cols : Int = {
        return self.dataSource?.numberOfCols(self) ?? 2
    }()
    fileprivate lazy var totalHeights : [CGFloat] = Array(repeating: self.sectionInset.top, count: self.cols)
}

// MARK:- 准备布局
extension HYWaterfallLayout {
    override func prepare() {
        super.prepare()
        
        // Cell --> UICollectionViewLayoutAttributes
        // 1.获取cell的个数
        let itemCount = collectionView!.numberOfItems(inSection: 0)
        
        // 2.给每一个Cell创建一个UICollectionViewLayoutAttributes
        let cellW : CGFloat = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - CGFloat(cols - 1) * minimumInteritemSpacing) / CGFloat(cols)
        for i in cellAttrs.count..<itemCount {
            // 1.根据i创建indexPath
            let indexPath = IndexPath(item: i, section: 0)
            
            // 2.根据indexPath创建对应的UICollectionViewLayoutAttributes
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            // 3.设置attr中的frame
            guard let cellH : CGFloat = dataSource?.waterfall(self, item: i) else {
                fatalError("请实现对应的数据源方法,并且返回Cell高度")
            }
            let minH = totalHeights.min()!
            let minIndex = totalHeights.index(of: minH)!
            let cellX : CGFloat = sectionInset.left + (minimumInteritemSpacing + cellW) * CGFloat(minIndex)
            let cellY : CGFloat = minH
            attr.frame = CGRect(x: cellX, y: cellY, width: cellW, height: cellH)
            
            // 4.保存attr
            cellAttrs.append(attr)
            
            // 5.添加当前的高度
            totalHeights[minIndex] = minH + minimumLineSpacing + cellH
        }
    }
}


// MARK:- 返回准备好所有布局
extension HYWaterfallLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        print(cellAttrs.count)
        return cellAttrs
    }
}


// MARK:- 设置contentSize
extension HYWaterfallLayout {
    override var collectionViewContentSize: CGSize {
        return CGSize(width: 0, height: totalHeights.max()! + sectionInset.bottom - minimumLineSpacing)
    }
}

