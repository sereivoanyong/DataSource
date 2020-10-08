//
//  DTPhotoViewerStaticDataSource.swift
//
//  Created by Sereivoan Yong on 10/8/20.
//

import UIKit
import DataSource
import DTPhotoViewerController

open class DTPhotoViewerStaticDataSource<ItemIdentifierType>: NSObject, DTPhotoViewerControllerDataSource {
  
  public typealias PhotoConfigurationHandler = (DTPhotoViewerController, Int, ItemIdentifierType, UIImageView) -> Void
  public typealias CellConfigurationHandler = (DTPhotoViewerController, DTPhotoCollectionViewCell, Int, ItemIdentifierType) -> Void
  
  weak private var photoViewerController: DTPhotoViewerController?
  private let core: ItemDataSourceCore<ItemIdentifierType>
  
  public let photoConfigurationHandler: PhotoConfigurationHandler
  public var cellConfigurationHandler: CellConfigurationHandler?
  public var referencedViewProvider: ((Int, ItemIdentifierType) -> UIView?)?
  
  public init(photoViewerController: DTPhotoViewerController, itemIdentifiers: [ItemIdentifierType], photoConfigurationHandler: @escaping PhotoConfigurationHandler) {
    self.photoViewerController = photoViewerController
    self.core = .init(itemIdentifiers: itemIdentifiers)
    self.photoConfigurationHandler = photoConfigurationHandler
    super.init()
    
    photoViewerController.dataSource = self
  }
  
  // MARK: DTPhotoViewerControllerDataSource
  
  open func numberOfItems(in photoViewerController: DTPhotoViewerController) -> Int {
    return core.numberOfItems
  }
  
  open func photoViewerController(_ photoViewerController: DTPhotoViewerController, configurePhotoAt index: Int, withImageView imageView: UIImageView) {
    photoConfigurationHandler(photoViewerController, index, core.itemIdentifier(for: index), imageView)
  }
  
  open func photoViewerController(_ photoViewerController: DTPhotoViewerController, configureCell cell: DTPhotoCollectionViewCell, forPhotoAt index: Int) {
    cellConfigurationHandler?(photoViewerController, cell, index, core.itemIdentifier(for: index))
  }
  
  open func photoViewerController(_ photoViewerController: DTPhotoViewerController, referencedViewForPhotoAt index: Int) -> UIView? {
    return referencedViewProvider?(index, core.itemIdentifier(for: index))
  }
}
