import UIKit

final class SubscribedPodcastCell: UICollectionViewCell {
    
    fileprivate var viewModel: SubscribedPodcastCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            albumArtView.image = viewModel.albumImageUrl
        }
    }
    
    // MARK: - UI Element Properties
    
    var cellState: SubscriptionCellState = .done {
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
    
   var albumArtView: UIImageView = {
        var album = UIImageView()
        return album
    }()
    
    var overlayView: UIView = {
        let overlay = UIView()
        overlay.backgroundColor = .black
        return overlay
    }()
    
    var deleteImageView: UIImageView = {
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
    
    func configureCell(with model: SubscribedPodcastCellViewModel, withTime: Double, mode: SubscriptionCellState) {
        self.viewModel  = model
        self.albumArtView.image = model.albumImageUrl
        self.layoutSubviews()
        cellState = mode
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
        albumArtView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        albumArtView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        albumArtView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumArtView.image = nil
    }
    
    func setup(deleteImageView: UIImageView) {
        overlayView.addSubview(deleteImageView)
        deleteImageView.translatesAutoresizingMaskIntoConstraints = false
        deleteImageView.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: overlayView.frame.height * 0.02).isActive = true
        deleteImageView.leftAnchor.constraint(equalTo: overlayView.leftAnchor, constant: overlayView.frame.width * 0.02).isActive = true
        deleteImageView.heightAnchor.constraint(equalTo: overlayView.heightAnchor, multiplier: 0.18).isActive = true
        deleteImageView.widthAnchor.constraint(equalTo: overlayView.widthAnchor, multiplier: 0.18).isActive = true
    }
}
