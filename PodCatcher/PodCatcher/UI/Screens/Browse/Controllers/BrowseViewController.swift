import UIKit

final class BrowseViewController: BaseCollectionViewController {
    
    weak var delegate: BrowseViewControllerDelegate?
    
    var currentPlaylistId: String = ""
    var topItems = [CasterSearchResult]()
    var topView = BrowseTopView()
    var tap: UITapGestureRecognizer!
    let loadingPop = LoadingPopover()
    
    var dataSource: HomeCollectionDataSource! {
        didSet {
            viewShown = dataSource.viewShown
        }
    }
    
    var viewShown: ShowView = .empty {
        didSet {
            switch viewShown {
            case .empty:
                view.addSubview(emptyView)
                changeView(forView: emptyView, withView: collectionView)
            case .collection:
                changeView(forView: collectionView, withView: emptyView)
                emptyView.removeFromSuperview()
            }
        }
    }
    
    init(index: Int, dataSource: BaseMediaControllerDataSource) {
        self.dataSource = HomeCollectionDataSource()
        super.init(nibName: nil, bundle: nil)
        //showLoadingView(loadingPop: loadingPop)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let topFrameHeight = UIScreen.main.bounds.height / 2
        let topFrameWidth = UIScreen.main.bounds.width
        let topFrame = CGRect(x: 0, y: 0, width: topFrameWidth, height: topFrameHeight + 40)
        topView.frame = topFrame
        
        view.addSubview(topView)
        view.backgroundColor = .clear
        topView.backgroundColor = .clear
        view.addSubview(collectionView)
        collectionViewConfiguration()
        collectionView.register(TopPodcastCell.self)
        collectionView.backgroundColor = .darkGray
        tap = UITapGestureRecognizer(target: self, action: #selector(selectAt))
        topItems = dataSource.items
        DispatchQueue.main.async {
            self.view.bringSubview(toFront: self.collectionView)
             self.collectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        topView.addGestureRecognizer(tap)
        UIView.animate(withDuration: 0.15) {
            self.view.alpha = 1
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func selectAt() {
        switch dataSource.dataType {
        case .local:
            delegate?.didSelect(at: 0)
            topView.removeGestureRecognizer(tap)
        case .network:
            delegate?.didSelect(at: 0, with: dataSource.items[0])
            topView.removeGestureRecognizer(tap)
        }
    }
}
