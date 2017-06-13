import UIKit

final class TabBarController: UITabBarController {
    
    var dataSource: BaseMediaControllerDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupTabBar()
    }
    
    // General dimensions and look of tabbar
    
    private func setupTabBar() {
        tabBar.isTranslucent = true
        tabBar.tintColor = UIColor(red:0.92, green:0.32, blue:0.33, alpha:1.0)
    }
    
    func setup(with controllerOne: UIViewController, and controllerTwo: UIViewController) {
        let normalImage = #imageLiteral(resourceName: "lightGrayPodcasts")
        let selectedImage = #imageLiteral(resourceName: "lightGrayPodcasts")
        controllerOne.tabBarItem =  UITabBarItem(title: nil, image: normalImage.withRenderingMode(.alwaysOriginal), selectedImage: selectedImage.withRenderingMode(.alwaysTemplate))
        let tabOne = setupTab(settingsViewController: controllerOne)
        controllerTwo.tabBarItem =  UITabBarItem(title: nil, image: normalImage.withRenderingMode(.alwaysOriginal), selectedImage: selectedImage.withRenderingMode(.alwaysTemplate))
        let tabTwo = setupTab(settingsViewController: controllerTwo)
        setTabTitles(controllers: [tabOne, tabTwo])
    }
    
    func setup(with controllers: [UINavigationController]) {
        setTabTitles(controllers: controllers)
    }
    
    func setTabTitles(controllers: [UINavigationController]) {
        viewControllers = controllers
        tabBar.items?[0].title = "Podcasts"
        tabBar.items?[1].title = "Settings"
        selectedIndex = 0
    }
    
    private func setupTab(settingsViewController: UIViewController) -> UINavigationController {
        return UINavigationController(rootViewController: settingsViewController)
        
    }
}
