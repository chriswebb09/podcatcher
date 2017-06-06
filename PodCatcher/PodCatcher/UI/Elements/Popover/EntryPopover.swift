import UIKit

struct PlaylistViewControllerConstants {
    static let itemSize =  CGSize(width: UIScreen.main.bounds.width, height: 150)
    static let mainColor = UIColor(red:0.13, green:0.21, blue:0.44, alpha:1.0)
    static let backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)
    static let edgeInset = UIEdgeInsets(top:10, left: 0, bottom: 60, right: 0)
    static let collectionViewEdge = UIEdgeInsets(top:0, left: 0, bottom: 60, right: 0)
    static let minimumSpace: CGFloat = 20
    static let collectionItemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
}

final class EntryView: UIView {
    
    // Input for playlist name
    
    var entryField: TextFieldExtension = {
        var entryField = TextFieldExtension()
        entryField.layer.borderColor = DetailViewConstants.mainColor.cgColor
        entryField.layer.cornerRadius = DetailViewConstants.largeCornerRadius
        entryField.layer.borderWidth = DetailViewConstants.borderWidth
        entryField.placeholder = "Add a new tag!"
        entryField.font = UIFont(name: "Avenir-Book", size: 20)!
        return entryField
    }()
    
    private var titleLabel: UILabel = {
        var titleLabel = UILabel()
        titleLabel.backgroundColor = DetailViewConstants.mainColor
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = DetailViewConstants.titleFont
        return titleLabel
    }()
    
    private var detailsTextView: UITextView = {
        var detailsTextView = UITextView()
        detailsTextView.sizeToFit()
        detailsTextView.textAlignment = .center
        detailsTextView.isScrollEnabled = true
        return detailsTextView
    }()
    
    let doneButton: UIButton = {
        var button = UIButton()
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(PlaylistViewControllerConstants.mainColor, for: .normal)
        button.setTitle("Done", for: .normal)
        button.layer.borderColor = PlaylistViewControllerConstants.mainColor.cgColor
        button.layer.borderWidth = 1.5
        if let popTitle = button.titleLabel, let font = UIFont(name: "Avenir-Book", size: 20) {
            popTitle.font = font
        }
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        isUserInteractionEnabled = true
        backgroundColor = UIColor.white
        configureShadow(for: layer)
        layer.borderWidth = 1.5
        layer.borderColor = PlaylistViewControllerConstants.mainColor.cgColor
    }
    
    private func configureShadow(for layer: CALayer) {
        layer.cornerRadius = DetailViewConstants.cornerRadius
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = DetailViewConstants.shadowOpacity
        layer.masksToBounds = true
        layer.shadowPath = UIBezierPath(roundedRect:bounds, cornerRadius:layer.cornerRadius).cgPath
    }
    
    func configureView() {
        titleLabel.text = "Create Playlist"
        layoutSubviews()
        setupConstraints()
    }
    
    private func setup(entryField: UITextField) {
        addSubview(entryField)
        entryField.translatesAutoresizingMaskIntoConstraints = false
        entryField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        entryField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        entryField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.14).isActive = true
        entryField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: DetailViewConstants.fieldWidth).isActive = true
    }
    
    private func setup(titleLabel: UILabel) {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: DetailViewConstants.heightMultiplier).isActive = true
    }
    
    private func setup(doneButton: UIButton) {
        addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: DetailViewConstants.heightMultiplier).isActive = true
        doneButton.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    private func setupConstraints() {
        setup(entryField: entryField)
        setup(titleLabel: titleLabel)
        setup(doneButton: doneButton)
    }
}

final class NewPlaylistPopover: BasePopoverAlert {
    
 //   var popoverState: PlaylistCreatorState = .hidden
    
    var popView: EntryView = {
        let popView = EntryView()
        popView.layer.cornerRadius = DetailPopoverConstants.cornerRadius
        popView.backgroundColor = .white
        popView.layer.borderColor = UIColor.black.cgColor
        popView.layer.borderWidth = DetailPopoverConstants.borderWidth
        popView.isUserInteractionEnabled = true
        return popView
    }()
    
    public override func showPopView(viewController: UIViewController) {
        super.showPopView(viewController: viewController)
        setupPop()
       // popoverState = .enabled
        popView.frame = CGRect(x: DetailPopoverConstants.popViewFrameX,
                               y: DetailPopoverConstants.popViewFrameY,
                               width: DetailPopoverConstants.popViewFrameWidth,
                               height: DetailPopoverConstants.popViewFrameHeight)
        popView.center = CGPoint(x: UIScreen.main.bounds.midX, y: DetailPopoverConstants.popViewFrameCenterY)
        popView.clipsToBounds = true
        viewController.view.addSubview(popView)
        viewController.view.bringSubview(toFront: popView)
        popView.isHidden = true
    }
}

extension NewPlaylistPopover {
    
    
    func setupPop() {
        popView.configureView()
    }
    
    override func hidePopView(viewController: UIViewController) {
        guard let listname = popView.entryField.text else { return }
       // popoverState = .hidden
      //  delegate?.userDidEnterPlaylistName(name: listname)
        super.hidePopView(viewController: viewController)
        popView.isHidden = true
        viewController.view.sendSubview(toBack: popView)
    }
}

