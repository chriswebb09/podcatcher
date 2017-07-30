import UIKit
import CoreData

protocol CollectionCellPopulator {
    associatedtype DataType
    func populate(_ collectionView: UICollectionView, for indexPath: IndexPath, from data: DataType) -> UICollectionViewCell
}

protocol DataManager {
    
    associatedtype DataType
    
    func itemCount() -> Int
    func itemCount(_ section: Int) -> Int?
    func sectionCount() -> Int
    func itemAtIndexPath(_ indexPath: IndexPath) -> DataType
    func append(newData: [DataType], to Section: Int)
    func clearData()
}

final class FlatArrayDataManager<T>: DataManager {
    
    private var data: [T]
    
    init(data: [T]) {
        self.data = data
    }
    
    convenience init() {
        self.init(data: [T]())
    }
    
    func itemCount() -> Int {
        return data.count
    }
    
    func itemCount(_ section: Int) -> Int? {
        guard section < 1 else {
            return nil
        }
        
        return itemCount()
    }
    
    func itemAtIndexPath(_ indexPath: IndexPath) -> T {
        return data[indexPath.row]
    }
    
    func append(newData: [T], to toSection: Int) {
        data.append(contentsOf: newData)
    }
    
    func clearData() {
        data.removeAll(keepingCapacity: true)
    }
    
    func sectionCount() -> Int {
        return 1
    }
}


final class DataSource<T: DataManager, U: CollectionCellPopulator>: NSObject, UICollectionViewDataSource where U.DataType == T.DataType {
   
    internal let dataManager: T
    private let cellPopulator: U
    
    init(dataManager: T, cellPopulator: U) {
        self.dataManager = dataManager
        self.cellPopulator = cellPopulator
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(dataManager.itemCount())
        return dataManager.itemCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        dump(collectionView)
        return cellPopulator.populate(collectionView, for: indexPath, from: dataManager.itemAtIndexPath(indexPath))
    }
}

