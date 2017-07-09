import UIKit
import CoreData

class CoreDataStack {
    
    private let modelName: String
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    func saveContext () {
        guard managedContext.hasChanges else { return }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
}

class BaseDataStore: NSObject {
    
    static func userSignIn(username: String, password: String, completion: @escaping (PodCatcherUser?, Error?) -> Void) {
        AuthClient.loginToAccount(email: username, password: password) { user, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error)
                return
            }
            PullData.pullFromDatabase { pulled in
                guard let user = user else { return }
                pulled.username = user.uid
                pulled.userId = user.uid
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    completion(pulled, nil)
                }
            }
        }
    }
}
