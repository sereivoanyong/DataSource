//
//  ItemDataSourceCore.swift
//
//  Created by Sereivoan Yong on 10/6/20.
//

import DifferenceKit

struct Item<ItemIdentifierType> {
  
  let differenceIdentifier: ItemIdentifierType
}

extension Item: Equatable where ItemIdentifierType: Equatable { }

extension Item: Differentiable where ItemIdentifierType: Hashable { }

open class ItemDataSourceCore<ItemIdentifierType> {
  
  internal typealias Item = DataSource.Item<ItemIdentifierType>
  
  internal var items: [Item]
  
  public init(itemIdentifiers: [ItemIdentifierType] = []) {
    self.items = itemIdentifiers.map(Item.init(differenceIdentifier:))
  }
  
  open var numberOfItems: Int {
    return items.count
  }
  
  open func index(for itemIdentifier: ItemIdentifierType) -> Int? where ItemIdentifierType: Hashable {
    let indexes: [ItemIdentifierType: Int] = items.enumerated().reduce(into: [:], { $0[$1.element.differenceIdentifier] = $1.offset })
    return indexes[itemIdentifier]
  }
  
  open func itemIdentifier(for index: Int) -> ItemIdentifierType {
    return items[index].differenceIdentifier
  }
}
