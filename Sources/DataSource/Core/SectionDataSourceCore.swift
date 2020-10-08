//
//  SectionDataSourceCore.swift
//
//  Created by Sereivoan Yong on 10/6/20.
//

import DifferenceKit

struct Section<SectionIdentifierType: Hashable, ItemIdentifierType: Hashable>: Equatable, DifferentiableSection {
  
  let differenceIdentifier: SectionIdentifierType
  let elements: [Item<ItemIdentifierType>]
  
  init(differenceIdentifier: SectionIdentifierType, elements: [Item<ItemIdentifierType>]) {
    self.differenceIdentifier = differenceIdentifier
    self.elements = elements
  }
  
  init<C: Swift.Collection>(source: Section, elements: C) where C.Element == Item<ItemIdentifierType> {
    self.differenceIdentifier = source.differenceIdentifier
    self.elements = Collection(elements)
  }
}

import Foundation
import QuartzCore

open class SectionDataSourceCore<SectionIdentifierType: Hashable, ItemIdentifierType: Hashable> {
  
  internal typealias Section = DataSource.Section<SectionIdentifierType, ItemIdentifierType>
  internal typealias Item = DataSource.Item<ItemIdentifierType>
  
  internal var sections: [Section] = []
  
  open var numberOfSections: Int {
    return sections.count
  }
  
  open func numberOfItems(inSection section: Int) -> Int {
    return sections[section].elements.count
  }
  
  open func sectionIdentifier(forSection section: Int) -> SectionIdentifierType {
    return sections[section].differenceIdentifier
  }
  
  open func itemIdentifier(for indexPath: IndexPath) -> ItemIdentifierType {
    return sections[indexPath.section].elements[indexPath.item].differenceIdentifier
  }
  
  internal func performBatchUpdates<View: AnyObject>(
    _ updates: (inout [(SectionIdentifierType, [ItemIdentifierType])]) -> Void,
    view: View?,
    animatingDifferences: Bool,
    reloadHandler: (View, StagedChangeset<[Section]>, ([Section]) -> Void) -> Void,
    completion: (() -> Void)?
  ) {
    var updatedSections = sections.map { ($0.differenceIdentifier, $0.elements.map { $0.differenceIdentifier }) }
    updates(&updatedSections)
    let updatedCoreSections = updatedSections.map { Section(differenceIdentifier: $0.0, elements: $0.1.map { Item(differenceIdentifier: $0) }) }
    guard let view = view else {
      sections = updatedCoreSections
      completion?()
      return
    }
    CATransaction.begin()
    CATransaction.setCompletionBlock(completion)
    if !animatingDifferences {
      CATransaction.setDisableActions(true)
    }
    let changeset = StagedChangeset<[Section]>(source: sections, target: updatedCoreSections)
    reloadHandler(view, changeset, { newSections in
      sections = newSections
    })
    CATransaction.commit()
  }
}
