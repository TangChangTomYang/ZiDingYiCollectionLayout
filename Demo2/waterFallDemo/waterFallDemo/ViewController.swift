//
//  ViewController.swift
//  10-瀑布流的布局
//
//  Created by 小码哥 on 2016/12/4.
//  Copyright © 2016年 xmg. All rights reserved.
//

import UIKit

private let kContentCellID = "kContentCellID"

class ViewController: UIViewController {
    
    fileprivate lazy var collectionView : UICollectionView = {
        let layout = HYWaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        layout.dataSource = self
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    fileprivate var cellCount : Int = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
    }
    
}


extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        
        cell.backgroundColor = UIColor.randomColor()
        if indexPath.item == cellCount - 1 {
            cellCount += 30
            collectionView.reloadData()
        }
        
        return cell
    }
}


extension ViewController : HYWaterfallLayoutDataSource {
    func numberOfCols(_ waterfall: HYWaterfallLayout) -> Int {
        return 3
    }
    
    func waterfall(_ waterfall: HYWaterfallLayout, item: Int) -> CGFloat {
        return item % 2 == 0 ? view.bounds.width * 2 / 3 : view.bounds.width * 0.5
    }
}

