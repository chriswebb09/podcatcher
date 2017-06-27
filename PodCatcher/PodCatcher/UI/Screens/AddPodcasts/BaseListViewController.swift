import UIKit

class BaseListViewController: UIViewController {
    
    var dataSource: ListControllerDataSource
    
    weak var delegate: SearchViewControllerDelegate?
    
    init(dataSource: ListControllerDataSource) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var contentState: TrackContentState = .none {
        didSet {
            switch contentState {
            case .none:
                self.view.bringSubview(toFront: emptyView)
                print("None")
            case .results:
                self.view.bringSubview(toFront: collectionView)
            case.loaded:
                self.view.bringSubview(toFront: collectionView)
            case .loading:
                return
            }
        }
    }
    
    var emptyView = EmptyView() {
        didSet {
            emptyView.configure()
        }
    }
    
    lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        #if CLEAR_CACHES
            let cachesFolderItems = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
            for item in cachesFolderItems {
                try? FileManager.default.removeItem(atPath: item)
            }
        #endif
        edgesForExtendedLayout = []
        setupCollectionView(collectionView: collectionView, view: view, newLayout: TrackItemsFlowLayout())
        collectionView.isHidden = true
        setupDefaultUI()
    }
}

extension BaseListViewController: TrackCellCollectionProtocol {
    
    func setupCollectionView(collectionView: UICollectionView, view: UIView, newLayout: TrackItemsFlowLayout) {
        collectionView.setup(with: newLayout)
        guard let tabbarHeight = self.tabBarController?.tabBar.frame.height else { return }
        collectionView.contentInset =  UIEdgeInsets(top: 0, left: 0, bottom: tabbarHeight + 20, right: 0)
        view.addSubview(collectionView)
        view.sendSubview(toBack: collectionView)
        view.bringSubview(toFront: emptyView)
    }
}

extension BaseListViewController: UICollectionViewDelegate, OpenPlayerProtocol {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.didSelect(at: indexPath.row)
//        let destinationViewController = UIViewController()
//        
//        navigationController?.pushViewController(destinationViewController, animated: false)
    }
}

extension BaseListViewController:  UICollectionViewDataSource  {
    
    @objc(collectionView:cellForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource.cellInstance(collectionView: collectionView, indexPath: indexPath)
    }
}

