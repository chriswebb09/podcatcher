import UIKit

final class MenuView: UIView {
    
    weak var delegate: MenuDelegate?
    
    private var optionOneView: MenuOptionView = {
        let optionOne = MenuOptionView()
        optionOne.setupConstraints()
        optionOne.isUserInteractionEnabled = true
        optionOne.layer.borderColor = UIColor.white.cgColor
        optionOne.layer.borderWidth = 1
        return optionOne
    }()
    
    private var optionTwoView: MenuOptionView = {
        let optionTwo = MenuOptionView()
        optionTwo.setupConstraints()
        optionTwo.isUserInteractionEnabled = true
        optionTwo.layer.borderColor = UIColor.white.cgColor
        optionTwo.layer.borderWidth = 1
        return optionTwo
    }()
    
    private var optionThreeView: MenuOptionView = {
        let optionThree = MenuOptionView()
        optionThree.setupConstraints()
        optionThree.isUserInteractionEnabled = true
        optionThree.layer.borderColor = UIColor.white.cgColor
        optionThree.layer.borderWidth = 1
        return optionThree
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor(red:0.09, green:0.14, blue:0.31, alpha:1.0)
        alpha = 0.98
        isUserInteractionEnabled = true
        layer.cornerRadius = DetailViewConstants.cornerRadius
        layer.borderWidth = DetailViewConstants.borderWidth
        layer.borderColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowRadius = DetailViewConstants.borderWidth
        layer.shadowOpacity = DetailViewConstants.shadowOpacity
        layer.masksToBounds = true
        layer.shadowPath = UIBezierPath(roundedRect:bounds, cornerRadius:layer.cornerRadius).cgPath
    }
    
    private func addSelectors() {
        let optionOneTapped = UITapGestureRecognizer(target: self, action: #selector(optionOneViewTapped))
        optionOneView.addGestureRecognizer(optionOneTapped)
        let optionTwoTapped = UITapGestureRecognizer(target: self, action: #selector(optionTwoViewTapped))
        optionTwoView.addGestureRecognizer(optionTwoTapped)
        let optionThreeTapped = UITapGestureRecognizer(target: self, action: #selector(optionThreeViewTapped))
        optionThreeView.addGestureRecognizer(optionThreeTapped)
    }
    
    @objc private func optionOneViewTapped() {
        delegate?.optionOneTapped()
    }
    
    @objc private func optionTwoViewTapped() {
        delegate?.optionTwoTapped()
    }
    
    @objc private func optionThreeViewTapped() {
        delegate?.optionThreeTapped()
    }
    
    func configureView() {
        layoutSubviews()
        setupConstraints()
        optionOneView.set(with: "Download To Phone", and: #imageLiteral(resourceName: "cloud-circle-white"))
        optionTwoView.set(with: "Remove From Playlist", and: #imageLiteral(resourceName: "circle-x-white"))
        optionThreeView.set(with: "Delete From Phone", and: #imageLiteral(resourceName: "dot-circle-icon-white"))
        addSelectors()
    }
    
    
    private func setSharedConstraintProperties(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        view.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3).isActive = true
    }
    
    private func setupConstraints() {
        setSharedConstraintProperties(view: optionOneView)
        optionOneView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        setSharedConstraintProperties(view: optionTwoView)
        optionTwoView.topAnchor.constraint(equalTo: optionOneView.bottomAnchor).isActive = true
        setSharedConstraintProperties(view: optionThreeView)
        optionThreeView.topAnchor.constraint(equalTo: optionTwoView.bottomAnchor).isActive = true
    }
}
