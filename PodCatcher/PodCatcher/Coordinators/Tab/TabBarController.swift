import UIKit

final class TabBarController: UITabBarController {
    
    var dataSource: BaseMediaControllerDataSource!
    
    var first: Bool  = false
    
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
        tabBar.backgroundImage = #imageLiteral(resourceName: "button-background")
        tabBar.autoresizesSubviews = false
        tabBar.clipsToBounds = true
    }
    
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = tabBar.bounds
        blurEffectView.alpha = 0.1
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tabBar.backgroundImage = UIImage.getImageWithColor(color: .clear, size: tabBar.frame.size)
        tabBar.insertSubview(blurEffectView, at: 0)
    }
    
    func setup(with controllerOne: UIViewController, and controllerTwo: UIViewController) {
        let normalImage = #imageLiteral(resourceName: "lightGrayPodcasts")
        let selectedImage = #imageLiteral(resourceName: "sound-waves-red")
        
        let normalImageTwo = #imageLiteral(resourceName: "settings-dark-gray")
        let selectedImageTwo = #imageLiteral(resourceName: "settings-red")
        
        controllerOne.tabBarItem = UITabBarItem(title: nil, image: normalImage.withRenderingMode(.alwaysOriginal), selectedImage: selectedImage.withRenderingMode(.alwaysTemplate))
        let tabOne = setupTab(settingsViewController: controllerOne)
 
        controllerTwo.tabBarItem = UITabBarItem(title: nil, image: normalImageTwo.withRenderingMode(.alwaysOriginal), selectedImage: selectedImageTwo.withRenderingMode(.alwaysTemplate))
        let tabTwo = setupTab(settingsViewController: controllerTwo)
        
        setTabTitles(controllers: [tabOne, tabTwo])
    }
    
    func setup(with controllers: [UINavigationController]) {
        setTabTitles(controllers: controllers)
    }
    
    func setTabTitles(controllers: [UINavigationController]) {
        let normalImage = #imageLiteral(resourceName: "lightGrayPodcasts")
        let normalImageThree = #imageLiteral(resourceName: "settings-dark-gray")
        
        viewControllers = controllers
        tabBar.items?[0].image = normalImage
        tabBar.items?[1].image = normalImageThree
        
        tabBar.items?[0].title = "Podcasts"
        tabBar.items?[1].title = "Settings"
        selectedIndex = 0
        first = true
    }
    
    private func setupTab(settingsViewController: UIViewController) -> UINavigationController {
        return UINavigationController(rootViewController: settingsViewController)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let nav = viewControllers?[0] as! UINavigationController
        let med = nav.viewControllers[0] as! MediaCollectionViewController
        if item == tabBar.items?[1] {
            med.searchController.isActive = false
        }
    }
}
