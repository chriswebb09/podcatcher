import UIKit

final class SideMenuView: UIView {
    
    weak var delegate: SideMenuDelegate?
    
    private var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0.8
        return backgroundView
    }()
    
    private var optionOneView: SideMenuOptionView = {
        let optionOne = SideMenuOptionView()
        optionOne.setupConstraints()
        optionOne.isUserInteractionEnabled = true
        return optionOne
    }()
    
    private var optionTwoView: SideMenuOptionView = {
        let optionTwo = SideMenuOptionView()
        optionTwo.setupConstraints()
        optionTwo.isUserInteractionEnabled = true
        return optionTwo
    }()
    
    private var optionThreeView: SideMenuOptionView = {
        let optionThree = SideMenuOptionView()
        optionThree.setupConstraints()
        optionThree.isUserInteractionEnabled = true
        return optionThree
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        alpha = MenuViewConstants.alpha
        isUserInteractionEnabled = true
        layer.cornerRadius = DetailViewConstants.cornerRadius
        layer.borderWidth = DetailViewConstants.borderWidth
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
        print("one")
        delegate?.optionOne(tapped: true)
    }
    
    @objc private func optionTwoViewTapped() {
        print("two")
        delegate?.optionOne(tapped: true)
    }
    
    @objc private func optionThreeViewTapped() {
        print("three")
        delegate?.optionThree(tapped: true)
    }
    
    func configureView() {
        isUserInteractionEnabled = true
        layoutSubviews()
        setup(backgroundView: backgroundView)
        setupConstraints()
        optionOneView.set(title: "Log Out")
        optionTwoView.set(title: "Tag Podcasts")
        optionThreeView.set(title: "Delete From Phone")
        addSelectors()
    }
    
    func setup(backgroundView: UIView) {
        addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        backgroundView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        backgroundView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    private func sharedLayout(view: UIView) {
        backgroundView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rightAnchor.constraint(equalTo: backgroundView.rightAnchor).isActive = true
        view.widthAnchor.constraint(equalTo: backgroundView.widthAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: MenuViewConstants.sharedHeightMultiplier).isActive = true
    }
    
    private func setupConstraints() {
        sharedLayout(view: optionOneView)
        optionOneView.topAnchor.constraint(equalTo: topAnchor, constant: UIScreen.main.bounds.height * 0.001).isActive = true
        sharedLayout(view: optionTwoView)
        optionTwoView.topAnchor.constraint(equalTo: optionOneView.bottomAnchor, constant: UIScreen.main.bounds.height * 0.000).isActive = true
        sharedLayout(view: optionThreeView)
        optionThreeView.topAnchor.constraint(equalTo: optionTwoView.bottomAnchor, constant: UIScreen.main.bounds.height * 0.000).isActive = true
    }
}
