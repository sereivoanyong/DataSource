//
//  CollectionViewDataSource.swift
//
//  Created by Sereivoan Yong on 10/2/20.
//

import UIKit

open class CollectionViewDataSource<SectionIdentifierType: Hashable, ItemIdentifierType: Hashable>: NSObject, UICollectionViewDataSource {
  
  public typealias CellProvider = (UICollectionView, IndexPath, ItemIdentifierType) -> UICollectionViewCell?
  public typealias SupplementaryViewProvider = (UICollectionView, String, IndexPath, SectionIdentifierType) -> UICollectionReusableView?
  
  weak private var collectionView: UICollectionView?
  private let core = SectionDataSourceCore<SectionIdentifierType, ItemIdentifierType>()
  
  public let cellProvider: CellProvider
  public var supplementaryViewProvider: SupplementaryViewProvider?
  
  public init(collectionView: UICollectionView, cellProvider: @escaping CellProvider) {
    self.collectionView = collectionView
    self.cellProvider = cellProvider
    super.init()
    
    collectionView.dataSource = self
  }
  
  // MARK: UICollectionViewDataSource
  
  open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return core.numberOfItems(inSection: section)
  }
  
  open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return cellProvider(collectionView, indexPath, core.itemIdentifier(for: indexPath))!
  }
  
  open func numberOfSections(in collectionView: UICollectionView) -> Int {
    return core.numberOfSections
  }
  
  open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    return supplementaryViewProvider!(collectionView, kind, indexPath, core.sectionIdentifier(forSection: indexPath.section))!
  }
  
  open func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
    return false
  }
  
  open func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    
  }
}

extension CollectionViewDataSource {
  
  open func performBatchUpdates(_ updates: (inout [(SectionIdentifierType, [ItemIdentifierType])]) -> Void, animatingDifferences: Bool, completion: (() -> Void)?) {
    core.performBatchUpdates(updates, view: collectionView, animatingDifferences: animatingDifferences, reloadHandler: { collectionView, changeset, setData in
      collectionView.reload(using: changeset, interrupt: nil, setData: setData)
    }, completion: completion)
  }
}

/*
extension CollectionViewDataSource where Item: Equatable {
  
  /// Adds the items to the data source.
  /// - Parameter items: The items to add to the data source.
  public func appendItems(_ items: [Item]) {
    self.items.append(contentsOf: items)
    collectionView?.reloadData()
  }
  
  /// Inserts the provided items immediately before the item in the data source.
  /// - Parameters:
  ///   - items: The items to add to the data source.
  ///   - beforeItem: The item before which to insert the new items.
  public func insertItems(_ items: [Item], beforeItem: Item) {
    guard let beforeIndex = items.firstIndex(of: beforeItem) else {
      return
    }
    self.items.insert(contentsOf: items, at: beforeIndex)
  }
  
  /// Inserts the provided items immediately after the item in the data source.
  /// - Parameters:
  ///   - items: The items to add to the data source.
  ///   - afterItem: The item after which to insert the new items.
  public func insertItems(_ items: [Item], afterItem: Item) {
    guard let afterIndex = items.firstIndex(of: afterItem) else {
      return
    }
    self.items.insert(contentsOf: items, at: afterIndex + 1)
  }
  
  /// Deletes the items from the data source.
  /// - Parameter items: The items to delete from the data source.
  public func deleteItems(_ items: [Item]) {
    var itemsToRemoved = items
    for (index, item) in self.items.enumerated().reversed() {
      if let indexToRemove = itemsToRemoved.firstIndex(of: item) {
        self.items.remove(at: index)
        itemsToRemoved.remove(at: indexToRemove)
      }
    }
  }
  
  /// Deletes all of the items from the data source.
  public func deleteAllItems() {
    items.removeAll(keepingCapacity: false)
  }
  
  /// Moves the item from its current position in the data source to the position immediately before the specified item.
  /// - Parameters:
  ///   - item: The item to move in the data source.
  ///   - toItem: The item before which to move the specified item.
  @available(*, deprecated, message: "To be implemented")
  public func moveItem(_ item: Item, beforeItem toItem: Item) {
    
  }
  
  /// Moves the item from its current position in the data source to the position immediately after the specified item.
  /// - Parameters:
  ///   - item: The item to move in the data source.
  ///   - toItem: The item after which to move the specified item.
  @available(*, deprecated, message: "To be implemented")
  public func moveItem(_ item: Item, afterItem toItem: Item) {
    
  }
}
 */

extension UICollectionView {
  
  final public func performBatchUpdates(
    insertions: [IndexPath],
    deletions: [IndexPath],
    modifications: [IndexPath],
    movements: [(source: IndexPath, destination: IndexPath)],
    completion: ((Bool) -> Void)? = nil
  ) {
    performBatchUpdates({
      insertItems(at: insertions)
      deleteItems(at: deletions)
      reloadItems(at: modifications)
      for movement in movements {
        moveItem(at: movement.source, to: movement.destination)
      }
    }, completion: completion)
  }
}
