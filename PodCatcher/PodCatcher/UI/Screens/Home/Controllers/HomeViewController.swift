import UIKit

final class SubscribedPodcastCellViewModel {
    
    var trackName: String
    var albumImageUrl: UIImage
    
    init(trackName: String, albumImageURL: UIImage) {
        self.trackName = trackName
        self.albumImageUrl = albumImageURL
    }
}

final class SubscribedPodcastCell: UICollectionViewCell {
    
    fileprivate var viewModel: SubscribedPodcastCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            albumArtView.image = viewModel.albumImageUrl
        }
    }
    
    // MARK: - UI Element Properties
    
    fileprivate var albumArtView: UIImageView = {
        var album = UIImageView()
        return album
    }()
    
    private func setShadow() {
        layer.setCellShadow(contentView: contentView)
        let path =  UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius)
        layer.shadowPath = path.cgPath
    }
    
    func configureCell(with model: SubscribedPodcastCellViewModel, withTime: Double) {
        alpha = 0
        self.viewModel  = model
        self.albumArtView.image = model.albumImageUrl
        self.layoutSubviews()
        UIView.animate(withDuration: withTime) {
            self.alpha = 1
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewConfigurations()
    }
    
    private func viewConfigurations() {
        setShadow()
        setup(albumArtView: albumArtView)
    }
    
    private func setup(albumArtView: UIImageView) {
        contentView.addSubview(albumArtView)
        albumArtView.translatesAutoresizingMaskIntoConstraints = false
        albumArtView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: MediaCellConstants.albumHeightMultiplier).isActive = true
        albumArtView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        albumArtView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumArtView.image = nil
    }
}



class MediaCollectionDataSource: BaseMediaControllerDataSource {
    
}

extension MediaCollectionDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as SubscribedPodcastCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
}



class HomeViewController: BaseCollectionViewController {
    
    // MARK: - Properties
    
    weak var delegate: HomeViewControllerDelegate?
    var dataSource: MediaCollectionDataSource
    
    // MARK: - UI Properties
    
    var buttonItem: UIBarButtonItem!
    
    var viewShown: ShowView {
        didSet {
            switch viewShown {
            case .empty:
                changeView(forView: emptyView, withView: collectionView)
            case .collection:
                changeView(forView: collectionView, withView: emptyView)
            }
        }
    }
    
    init(dataSource: BaseMediaControllerDataSource) {
        let mediaDataSource = MediaCollectionDataSource()
        self.dataSource = mediaDataSource
        self.viewShown = .empty
        super.init(nibName: nil, bundle: nil)
   
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(collectionView: UICollectionView, dataSource: BaseMediaControllerDataSource) {
        self.init(dataSource: dataSource)
        self.collectionView = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //collectionViewConfiguration()
        title = "Podcasts"
        collectionView.setupBackground(frame: view.bounds)
        guard let background = collectionView.backgroundView else { return }
        CALayer.createGradientLayer(with: [UIColor.gray.cgColor, UIColor.darkGray.cgColor],
                                    layer: background.layer,
                                    bounds: collectionView.bounds)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}
