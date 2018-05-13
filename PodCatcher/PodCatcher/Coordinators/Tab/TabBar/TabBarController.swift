import UIKit

final class TabBarController: UITabBarController {
    
    var dataSource: BaseMediaControllerDataSource!
    
    var miniPlayer = MiniPlayerViewController()
    
  //  var first: Bool  = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        view.backgroundColor = .black
        tabBar.alpha = 1
            //Style.Color.Charcoal.darkCharcoal
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
    
    func setup(with controllers: [UINavigationController]) {
        setTabTitles(controllers: controllers)
    }
    
    func setTabTitles(controllers: [UINavigationController]) {
        let home = #imageLiteral(resourceName: "home").withRenderingMode(.alwaysTemplate)
        // let normalImage = #imageLiteral(resourceName: "podcasts-icon-black").withRenderingMode(.alwaysTemplate)
        //let normalImageTwo = #imageLiteral(resourceName: "heart-icon-black").withRenderingMode(.alwaysTemplate)
        let normalImageThree = #imageLiteral(resourceName: "search").withRenderingMode(.alwaysTemplate)
        let normalImageFour = #imageLiteral(resourceName: "settings").withRenderingMode(.alwaysTemplate)
        
        viewControllers = controllers
        
        tabBar.items?[0].image = home
        tabBar.items?[1].image = normalImageThree
        tabBar.items?[2].image = normalImageFour
        
        tabBar.items?[0].title = "Home"
        tabBar.items?[1].title = "Search"
        tabBar.items?[2].title = "Setting"
        
       // selectedIndex = 0
     //   first = true
        
        if let items = self.tabBar.items {
            for item in items {
                if let image = item.image {
                    item.image = image.withRenderingMode(.alwaysTemplate)
                    //withRenderingMode(.alwaysOriginal)
                    item.selectedImage = item.selectedImage?.withRenderingMode(.alwaysTemplate)
                    //UIImage(named: "(Imagename)-a")?.withRenderingMode(.alwaysOriginal)
                }
            }
        }
    }
    
    private func setupTab(settingsViewController: UIViewController) -> UINavigationController {
        return UINavigationController(rootViewController: settingsViewController)
    }
}

