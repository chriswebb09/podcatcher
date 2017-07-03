import UIKit

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
        optionOneView.set(with: "Download Podcast", and: #imageLiteral(resourceName: "cloud-circle-white"))
        optionTwoView.set(with: "Tag Podcast", and: #imageLiteral(resourceName: "circle-x-white"))
//        optionThreeView.set(with: "Delete From Phone", and: #imageLiteral(resourceName: "dot-circle-icon-white"))
        optionCancelView.set(with: "Cancel", and: #imageLiteral(resourceName: "circle-x-white"))
        addSelectors()
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
