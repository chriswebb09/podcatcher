import UIKit

final class TabBarController: UITabBarController {
    
    var dataSource: BaseMediaControllerDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupTabBar(tabBar: tabBar, view: view)
    }
    
    // General dimensions and look of tabbar
    
    private func setupTabBar(tabBar: UITabBar, view: UIView) {
        var tabFrame = tabBar.frame
        let tabBarHeight = view.frame.height * Tabbar.tabbarFrameHeight
        tabFrame.size.height = tabBarHeight
        tabFrame.origin.y = view.frame.size.height - tabBarHeight
        tabBar.frame = tabFrame
        tabBar.isTranslucent = true
        tabBar.tintColor = UIColor(red:0.92, green:0.32, blue:0.33, alpha:1.0)
    }
    
    func setup(with controllerOne: UIViewController, and controllerTwo: UIViewController) {
        let tabOne = setupTab(settingsViewController: controllerOne)
        let tabTwo = setupTab(settingsViewController: controllerTwo)
        setTabTitles(controllers: [tabOne, tabTwo])
    }
    
    func setup(with controllers: [UINavigationController]) {
        setTabTitles(controllers: controllers)
    }
    
    
    func setTabTitles(controllers: [UINavigationController]) {
        viewControllers = controllers
        tabBar.items?[0].title = "Tracks"
        tabBar.items?[1].title = "Playlist"
        selectedIndex = 0
    }
    
    private func setupTab(settingsViewController: UIViewController) -> UINavigationController {
        let tab = UINavigationController(rootViewController: settingsViewController)
        return tab
    }
}
