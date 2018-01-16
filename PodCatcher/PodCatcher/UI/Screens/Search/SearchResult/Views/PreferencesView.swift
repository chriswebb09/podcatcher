import UIKit

final class PreferencesView: UIView {
    
    weak var delegate: PreferencesViewDelegate?
    
    // MARK: - UI Properties
    
    var moreMenuButton: UIButton = {
        var moreMenuButton = UIButton()
        moreMenuButton.alpha = 0.6
        return moreMenuButton
    }()
    
    
    var infoButton: UIButton = {
        var infoButton = UIButton()
        let infoImage = #imageLiteral(resourceName: "info-icon").withRenderingMode(.alwaysTemplate)
        
        infoButton.setImage(infoImage, for: .normal)
        infoButton.imageView?.tintColor = .white
        return infoButton
    }()
    
    var placeHolderView: UIView = {
        var view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - Configuration Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        moreMenuButton.addTarget(self, action: #selector(moreButton(tapped:)), for: .touchUpInside)
        backgroundColor = UIColor(red:0.79, green:0.83, blue:0.87, alpha:1.0)
        infoButton.addTarget(self, action: #selector(infoButton(tapped:)), for: .touchUpInside)
    }
    
    func setupConstraints() {
        setup(moreButton: moreMenuButton)
        setup(placeholder: placeHolderView)
        setup(infoButton: infoButton)
    }
    
    func setup(moreButton: UIButton) {
        addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        moreButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8).isActive = true
        moreButton.rightAnchor.constraint(equalTo: rightAnchor, constant: UIScreen.main.bounds.width * -0.04).isActive = true
        moreMenuButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.22).isActive = true
    }
    
    func setup(infoButton: UIButton) {
        addSubview(infoButton)
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        infoButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        infoButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.55).isActive = true
        infoButton.leftAnchor.constraint(equalTo: leftAnchor, constant: UIScreen.main.bounds.width * 0.04).isActive = true
        infoButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.06).isActive = true
    }
    
    func setup(placeholder: UIView) {
        addSubview(placeholder)
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        placeholder.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        placeholder.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8).isActive = true
        placeholder.leftAnchor.constraint(equalTo: leftAnchor, constant: UIScreen.main.bounds.width * 0.04).isActive = true
        placeholder.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.22).isActive = true
    }
    
    @objc func moreButton(tapped: Bool) {
        delegate?.moreButton(tapped: tapped)
    }
    
    @objc func infoButton(tapped: Bool) {
        delegate?.infoButton(tapped: true)
    }
    
    func addTagButton(tapped: Bool) {
        delegate?.addTagButton(tapped: tapped)
    }
}
