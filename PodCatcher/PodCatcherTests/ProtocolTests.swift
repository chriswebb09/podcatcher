
import XCTest
@testable import PodCatcher

class UIKitExtensionsTests: XCTestCase {
    

}

class ProtocolTests: XCTestCase {
    
    var window: UIWindow!
   
    var appCoordinator: MainCoordinator!
    
    override func setUp() {
        super.setUp()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let startCoord = StartCoordinator(navigationController: UINavigationController(), window: window)
        self.appCoordinator = MainCoordinator(window: window, coordinator: startCoord)
    }
    
    override func tearDown() {
        appCoordinator = nil
        window = nil
        super.tearDown()
    }
}
