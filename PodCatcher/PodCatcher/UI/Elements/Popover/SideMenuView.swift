import UIKit

final class SideMenuView: UIView {
    
    weak var delegate: MenuDelegate?
    
    private var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
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
        setup(backgroundView: backgroundView)
        setupConstraints()
        optionOneView.set(title: "Add To Favorites")
        optionTwoView.set(title: "Tag Podcasts")
        optionThreeView.set(title: "Delete From Phone")
        addSelectors()
        
        DispatchQueue.main.async {
            let lineOne = CALayer()
            lineOne.frame = CGRect(x: 0, y: self.optionOneView.frame.height - 1, width: self.optionOneView.frame.width, height: 1)
            lineOne.backgroundColor = UIColor.white.cgColor
            let lineTwo = CALayer()
            lineTwo.frame = CGRect(x: 0, y: self.optionTwoView.frame.height - 1, width: self.optionTwoView.frame.width, height: 1)
            lineTwo.backgroundColor = UIColor.white.cgColor
            let lineThree = CALayer()
            lineThree.frame = CGRect(x: 0, y: self.optionThreeView.frame.height - 1, width: self.optionThreeView.frame.width, height: 1)
            lineThree.backgroundColor = UIColor.white.cgColor
            self.optionThreeView.layer.addSublayer(lineThree)
            self.optionTwoView.layer.addSublayer(lineTwo)
            self.optionOneView.layer.addSublayer(lineOne)
        }
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
