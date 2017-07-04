import UIKit

class BaseCollectionViewController: BaseViewController {
    
    lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var emptyView = EmptyView(frame: UIScreen.main.bounds)
    var background = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        background.frame = view.frame
        view.addSubview(background)
        view.sendSubview(toBack: background)
        view.addSubview(collectionView)
        view.addSubview(emptyView)
        edgesForExtendedLayout = []
        collectionView.setupBackground(frame: view.bounds)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleTopMargin, .flexibleBottomMargin]
        guard let frame = tabBarController?.tabBar.frame else { return }
        collectionView.frame = CGRect(x: view.bounds.minX, y: view.frame.minY, width: view.frame.width, height: view.frame.height - frame.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.alpha = 1
    }
}


