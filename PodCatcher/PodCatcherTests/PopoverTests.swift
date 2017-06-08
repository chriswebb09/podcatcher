import XCTest
@testable import PodCatcher

class PopoverTests: XCTestCase {
    
    var loadingPop: LoadingPopover!
    var entryPop: EntryPopover!
    
    override func setUp() {
        super.setUp()
        entryPop = EntryPopover()
        loadingPop = LoadingPopover()
    }
    
    override func tearDown() {
        loadingPop = nil
        entryPop = nil
        super.tearDown()
    }
    
    func testShowLoadingPop() {
        let startView = StartView()
        let testVC = StartViewController(startView: startView)
        showLoadingView(loadingPop: loadingPop, viewController: testVC)
        guard let ball = loadingPop.popView.ball else { return }
        XCTAssertTrue(ball.isAnimating)
    }
    
    func testHideLoadingPop() {
        let startView = StartView()
        let testVC = StartViewController(startView: startView)
        showLoadingView(loadingPop: loadingPop, viewController: testVC)
        guard let ball = loadingPop.popView.ball else { return }
        XCTAssertTrue(ball.isAnimating)
        hideLoadingView(viewController: testVC)
        XCTAssertFalse(ball.isAnimating)
    }
    
    func showLoadingView(loadingPop: LoadingPopover, viewController: UIViewController) {
        loadingPop.setupPop(popView: loadingPop.popView)
        loadingPop.showPopView(viewController: viewController)
        loadingPop.popView.isHidden = false
    }
    
    func hideLoadingView(viewController: UIViewController) {
        loadingPop.popView.removeFromSuperview()
        loadingPop.removeFromSuperview()
        loadingPop.hidePopView(viewController: viewController)
        viewController.view.sendSubview(toBack: loadingPop)
    }

}

