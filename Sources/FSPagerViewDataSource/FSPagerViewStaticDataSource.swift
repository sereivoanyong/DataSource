//
//  FSPagerViewStaticDataSource.swift
//
//  Created by Sereivoan Yong on 10/2/20.
//

import UIKit
import DataSource
import FSPagerView

open class FSPagerViewStaticDataSource<ItemIdentifierType>: NSObject, FSPagerViewDataSource {
  
  public typealias CellProvider = (FSPagerView, Int, ItemIdentifierType) -> FSPagerViewCell?
  
  weak private var pagerView: FSPagerView?
  private let core: ItemDataSourceCore<ItemIdentifierType>
  
  public let cellProvider: CellProvider
  
  public init(pagerView: FSPagerView, itemIdentifiers: [ItemIdentifierType], cellProvider: @escaping CellProvider) {
    self.pagerView = pagerView
    self.core = .init(itemIdentifiers: itemIdentifiers)
    self.cellProvider = cellProvider
    super.init()
    
    pagerView.dataSource = self
  }
  
  // MARK: FSPagerViewDataSource
  
  open func numberOfItems(in pagerView: FSPagerView) -> Int {
    return core.numberOfItems
  }
  
  open func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
    return cellProvider(pagerView, index, core.itemIdentifier(for: index))!
  }
}
