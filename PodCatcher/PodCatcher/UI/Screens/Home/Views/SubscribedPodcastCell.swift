import UIKit

final class SubscribedPodcastCell: UICollectionViewCell {
    
    fileprivate var viewModel: SubsciptionCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            albumArtView.image = viewModel.albumImageUrl
        }
    }
    
    // MARK: - UI Element Properties
    
    private var cellState: SubscriptionCellState = .done {
        didSet {
            switch cellState {
            case .edit:
                overlayView.alpha = 0.5
                deleteImageView.alpha = 0.8
            case .done:
                overlayView.alpha = 0
            }
        }
    }
    
    private var albumArtView: UIImageView = {
        var album = UIImageView()
        return album
    }()
    
    private var overlayView: UIView = {
        let overlay = UIView()
        overlay.backgroundColor = .black
        return overlay
    }()
    
    private var deleteImageView: UIImageView = {
        let delete = UIImageView()
        let image = #imageLiteral(resourceName: "circle-x").withRenderingMode(.alwaysTemplate)
        delete.image = image
        delete.tintColor = .white
        return delete
    }()
    
    convenience init() {
        self.init(frame: CGRect.zero)
        cellState = .done
        overlayView.alpha = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setShadow() {
        layer.setCellShadow(contentView: contentView)
        let path =  UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius)
        layer.shadowPath = path.cgPath
    }
    
    func configureCell(with model: SubsciptionCellViewModel, withTime: Double, mode: SubscriptionCellState) {
        self.viewModel  = model
        self.albumArtView.image = model.albumImageUrl
        self.layoutSubviews()
        cellState = mode
        dump(cellState)
        if cellState == .done {
            print("done")
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewConfigurations()
        
    }
    
    private func viewConfigurations() {
        setShadow()
        setup(albumArtView: albumArtView)
        overlayView.frame = contentView.frame
        contentView.addSubview(overlayView)
        setup(deleteImageView: deleteImageView)
        switch cellState {
        case .edit:
            overlayView.alpha = 0.6
            deleteImageView.alpha = 1
        case .done:
            overlayView.alpha = 0
        }
        bringSubview(toFront: deleteImageView)
    }
    
    private func setup(albumArtView: UIImageView) {
        contentView.addSubview(albumArtView)
        albumArtView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            albumArtView.heightAnchor.constraint(equalTo: heightAnchor),
            albumArtView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            albumArtView.topAnchor.constraint(equalTo: contentView.topAnchor)
            ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumArtView.image = nil
    }
    
    func getAlbumImageView() -> UIImageView {
        return albumArtView
    }
    
    func showOverlay() {
        bringSubview(toFront: overlayView)
    }
    
    func setup(deleteImageView: UIImageView) {
        overlayView.addSubview(deleteImageView)
        deleteImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteImageView.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: overlayView.frame.height * 0.02),
            deleteImageView.leftAnchor.constraint(equalTo: overlayView.leftAnchor, constant: overlayView.frame.width * 0.02),
            deleteImageView.heightAnchor.constraint(equalTo: overlayView.heightAnchor, multiplier: 0.21),
            deleteImageView.widthAnchor.constraint(equalTo: overlayView.widthAnchor, multiplier: 0.18)
            ])
    }
}
