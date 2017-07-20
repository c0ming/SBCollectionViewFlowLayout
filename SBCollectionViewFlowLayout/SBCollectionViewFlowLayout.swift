//
//  SectionFlowLayout.swift
//  SuperView
//
//  Created by L on 16/8/16.
//  Copyright © 2016年 c0ming. All rights reserved.
//

import UIKit

// SB = Section Background

private let SectionBackground = "SBCollectionReusableView"

protocol SBCollectionViewDelegateFlowLayout: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor
}

extension SBCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        return UIColor.clear
    }
}

private class SBCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    var backgroundColor = UIColor.clear
}

private class SBCollectionReusableView: UICollectionReusableView {
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        guard let attr = layoutAttributes as? SBCollectionViewLayoutAttributes else {
            return
        }
        
        self.backgroundColor = attr.backgroundColor
    }
}

class SBCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private var decorationViewAttrs: [UICollectionViewLayoutAttributes] = []
    
    // MARK: - Init
    override init() {
        super.init()
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    // MARK: - Setup
    
    func setup() {
        // 1、注册
        self.register(SBCollectionReusableView.classForCoder(), forDecorationViewOfKind: SectionBackground)
    }
    
    // MARK: -
    
    override func prepare() {
        super.prepare()
        
        guard let numberOfSections = self.collectionView?.numberOfSections,
            let delegate = self.collectionView?.delegate as? SBCollectionViewDelegateFlowLayout
            else {
            return
        }
        
        self.decorationViewAttrs.removeAll()
        for section in 0..<numberOfSections {
            guard let numberOfItems = self.collectionView?.numberOfItems(inSection: section),
                numberOfItems > 0,
                let firstItem = self.layoutAttributesForItem(at: IndexPath(item: 0, section: section)),
                let lastItem = self.layoutAttributesForItem(at: IndexPath(item: numberOfItems - 1, section: section)) else {
                continue
            }
            
            var sectionInset = self.sectionInset
            if let inset = delegate.collectionView?(self.collectionView!, layout: self, insetForSectionAt: section) {
                sectionInset = inset
            }
            
            var sectionFrame = firstItem.frame.union(lastItem.frame)
            sectionFrame.origin.x = 0
            sectionFrame.origin.y -= sectionInset.top
            
            if self.scrollDirection == .horizontal {
                sectionFrame.size.width += sectionInset.left + sectionInset.right
                sectionFrame.size.height = self.collectionView!.frame.height
            } else {
                sectionFrame.size.width = self.collectionView!.frame.width
                sectionFrame.size.height += sectionInset.top + sectionInset.bottom
            }
            
            // 2、定义
            let attr = SBCollectionViewLayoutAttributes(forDecorationViewOfKind: SectionBackground, with: IndexPath(item: 0, section: section))
            attr.frame = sectionFrame
            attr.zIndex = -1
            attr.backgroundColor = delegate.collectionView(self.collectionView!, layout: self, backgroundColorForSectionAt: section)
            self.decorationViewAttrs.append(attr)
        }
    }
    
    override func initialLayoutAttributesForAppearingDecorationElement(ofKind elementKind: String,
                                                                       at decorationIndexPath: IndexPath)
        -> UICollectionViewLayoutAttributes?
    {
        if elementKind == SectionBackground {
            let attrs = self.decorationViewAttrs[decorationIndexPath.section]
            attrs.zIndex = -1
            return attrs
        } else {
            return super.initialLayoutAttributesForAppearingDecorationElement(
                ofKind: elementKind,
                at: decorationIndexPath
            )
        }
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath)
        -> UICollectionViewLayoutAttributes?
    {
        if let attrs = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath) {
            attrs.zIndex = 1 // 设为0时还有可能被覆盖
            return attrs
        } else {
            return nil
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attrs = super.layoutAttributesForElements(in: rect)
        attrs?.append(contentsOf: self.decorationViewAttrs.filter {
            return rect.intersects($0.frame)
        })
        return attrs // 3、返回
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes?
    {
        if elementKind == SectionBackground {
            return self.decorationViewAttrs[indexPath.section]
        } else {
            return super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)
        }
    }
    
}
