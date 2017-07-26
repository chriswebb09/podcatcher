import UIKit

enum MenuActive {
    case none, active, hidden
}

protocol MenuDelegate: class {
    func optionOne(tapped: Bool)
    func optionTwo(tapped: Bool)
    func optionThree(tapped: Bool)
    func cancel(tapped: Bool)
}

final class MenuOptionView: UIView {
    
    private var optionLabel: UILabel = {
        let option = UILabel()
        option.textColor = .white
        option.backgroundColor = .clear
        option.font = UIFont(name: "AvenirNext-Medium", size: 15)
        option.textAlignment = .center
        return option
    }()
    
    private var iconView: UIImageView = {
        var icon = UIImageView()
        icon.isHidden = true
        return icon
    }()
    
    func set(with text: String, and icon: UIImage) {
        optionLabel.text = text
        iconView.image = icon
        alpha = 1
    }
    
    func set(title: String) {
        optionLabel.text = title
    }
    
    func set(textColor: UIColor) {
        optionLabel.textColor = textColor
    }
    
    private func setup(label: UILabel) {
        addSubview(optionLabel)
        optionLabel.translatesAutoresizingMaskIntoConstraints = false
        optionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        optionLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: MenuOptionViewConstants.optionLabelCenterXOffset).isActive = true
        optionLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: MenuOptionViewConstants.optionLabelHeightMultiplier).isActive = true
        optionLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: MenuOptionViewConstants.optionLabelWidthMultiplier).isActive = true
    }
    
    private func setup(iconView: UIImageView) {
        addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: MenuOptionViewConstants.iconViewCenterXOffset).isActive = true
        iconView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: MenuOptionViewConstants.iconViewHeightAnchor).isActive = true
        iconView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: MenuOptionViewConstants.iconViewWidthAnchor).isActive = true
    }
    
    func setupConstraints() {
        backgroundColor = .clear
        setup(label: optionLabel)
        setup(iconView: iconView)
    }
}

final class MenuView: UIView {
    
    weak var delegate: MenuDelegate?
    
    private var optionOneView: MenuOptionView = {
        let optionOne = MenuOptionView()
        optionOne.setupConstraints()
        optionOne.isUserInteractionEnabled = true
        optionOne.layer.borderWidth = MenuViewConstants.optionBorderWidth
        return optionOne
    }()
    
    private var optionTwoView: MenuOptionView = {
        let optionTwo = MenuOptionView()
        optionTwo.setupConstraints()
        optionTwo.isUserInteractionEnabled = true
        optionTwo.layer.borderWidth = MenuViewConstants.optionBorderWidth
        return optionTwo
    }()
    
    private var optionThreeView: MenuOptionView = {
        let optionThree = MenuOptionView()
        optionThree.setupConstraints()
        // optionThree.isUserInteractionEnabled = true
        optionThree.backgroundColor = .clear
        //optionThree.layer.borderWidth = MenuViewConstants.optionBorderWidth
        return optionThree
    }()
    
    private var optionCancelView: MenuOptionView = {
        let optionCancel = MenuOptionView()
        optionCancel.setupConstraints()
        optionCancel.isUserInteractionEnabled = true
        optionCancel.layer.borderWidth = MenuViewConstants.optionBorderWidth
        return optionCancel
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        isUserInteractionEnabled = true
    }
    
    private func addSelectors() {
        let optionOneTapped = UITapGestureRecognizer(target: self, action: #selector(optionOneViewTapped))
        optionOneView.addGestureRecognizer(optionOneTapped)
        let optionTwoTapped = UITapGestureRecognizer(target: self, action: #selector(optionTwoViewTapped))
        optionTwoView.addGestureRecognizer(optionTwoTapped)
        //        let optionThreeTapped = UITapGestureRecognizer(target: self, action: #selector(optionThreeViewTapped))
        //        optionThreeView.addGestureRecognizer(optionThreeTapped)
        let cancelTapped = UITapGestureRecognizer(target: self, action: #selector(cancelViewTapped))
        optionCancelView.addGestureRecognizer(cancelTapped)
    }
    
    @objc private func optionOneViewTapped() {
        optionOneView.isUserInteractionEnabled = false
        delegate?.optionOne(tapped: true)
    }
    
    @objc private func optionTwoViewTapped() {
        delegate?.optionTwo(tapped: true)
    }
    
    @objc private func optionThreeViewTapped() {
        delegate?.optionThree(tapped: true)
    }
    
    @objc private func cancelViewTapped() {
        print("cancelViewTapped() ")
        delegate?.cancel(tapped: true)
    }
    
    func configureView() {
        layoutSubviews()
        setupConstraints()
        optionOneView.set(with: "Add To Playlist", and: #imageLiteral(resourceName: "cloud-circle-white"))
        optionTwoView.set(with: "Download", and: #imageLiteral(resourceName: "circle-x-white"))
        //        optionThreeView.set(with: "Delete From Phone", and: #imageLiteral(resourceName: "dot-circle-icon-white"))
        optionCancelView.set(with: "Cancel", and: #imageLiteral(resourceName: "circle-x-white"))
        addSelectors()
    }
    
    func setOptionOneTitle(string: String) {
        optionOneView.set(with: string, and: #imageLiteral(resourceName: "cloud-circle-white"))
    }
    
    func setupOptionTwoTitle(title: String) {
         optionTwoView.set(with: title, and: #imageLiteral(resourceName: "circle-x-white"))
    }
    
    func setMenuColor(backgroundColor: UIColor, borderColor: UIColor, labelTextColor: UIColor) {
        let optionViews = [optionOneView, optionTwoView, optionCancelView]
        optionViews.forEach {
            $0.backgroundColor = backgroundColor
            $0.layer.borderColor = borderColor.cgColor
            $0.set(textColor: labelTextColor)
        }
    }
    
    private func sharedLayout(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        view.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        view.heightAnchor.constraint(equalTo: heightAnchor, multiplier: MenuViewConstants.sharedHeightMultiplier).isActive = true
    }
    
    private func setupConstraints() {
        sharedLayout(view: optionOneView)
        optionOneView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        sharedLayout(view: optionTwoView)
        optionTwoView.topAnchor.constraint(equalTo: optionOneView.bottomAnchor, constant: UIScreen.main.bounds.height * 0.006).isActive = true
        sharedLayout(view: optionCancelView)
        optionCancelView.topAnchor.constraint(equalTo: optionTwoView.bottomAnchor, constant: UIScreen.main.bounds.height * 0.006).isActive = true
        //sharedLayout(view: optionThreeView)
        //optionThreeView.topAnchor.constraint(equalTo: optionTwoView.bottomAnchor, constant: UIScreen.main.bounds.height * 0.006).isActive = true
        //sharedLayout(view: optionCancelView)
        // optionCancelView.topAnchor.constraint(equalTo: optionThreeView.bottomAnchor, constant: UIScreen.main.bounds.height * 0.01).isActive = true
    }
}
