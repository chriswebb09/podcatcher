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
    
    func setup(with controllers: [UINavigationController]) {
        setTabTitles(controllers: controllers)
    }
    
    func setTabTitles(controllers: [UINavigationController]) {
        let home = #imageLiteral(resourceName: "home")
        let normalImage = #imageLiteral(resourceName: "lightGrayPodcasts")
        let normalImageTwo = #imageLiteral(resourceName: "heart-gray")
        let normalImageThree = #imageLiteral(resourceName: "search")
        let normalImageFour = #imageLiteral(resourceName: "settings-dark-gray")
        
        viewControllers = controllers
        
        tabBar.items?[0].image = home
        tabBar.items?[1].image = normalImageTwo
        tabBar.items?[2].image = normalImage
        tabBar.items?[3].image = normalImageThree
        tabBar.items?[4].image = normalImageFour
        
        tabBar.items?[0].title = "Home"
        tabBar.items?[1].title = "Podcasts"
        tabBar.items?[2].title = "Browse"
        tabBar.items?[3].title = "Search"
        tabBar.items?[4].title = "Setting"
        
        selectedIndex = 0
        first = true
    }
    
    private func setupTab(settingsViewController: UIViewController) -> UINavigationController {
        return UINavigationController(rootViewController: settingsViewController)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    }
}
