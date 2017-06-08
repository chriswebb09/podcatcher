import UIKit

class SettingsView: UIView {
    
    weak var delegate: SettingsViewDelegate?
    
    // MARK: - UI Element Properties
    
    var settingOneView: SettingsOptionView = {
        let settingOne = SettingsOptionView()
        return settingOne
    }()
    
    var settingTwoView: SettingsOptionView = {
        let settingTwo = SettingsOptionView()
        return settingTwo
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        settingOneView.set(settingName: "Setting One")
        settingTwoView.set(settingName: "Setting Two")
        setup(settingOptionOne: settingOneView)
        setup(settingOptionTwo: settingTwoView)
        addSelectors()
    }
    
    private func addSelectors() {
        let settingOneTapped = UITapGestureRecognizer(target: self, action: #selector(settingsOneTapped))
        settingOneView.addGestureRecognizer(settingOneTapped)
        let settingTwoTapped = UITapGestureRecognizer(target: self, action: #selector(settingsTwoTapped))
        settingTwoView.addGestureRecognizer(settingTwoTapped)
    }
    
    func sharedLayout(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: heightAnchor, multiplier: SettingsViewConstants.sharedHeightMultiplier).isActive = true
        view.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    func setup(settingOptionOne: SettingsOptionView) {
        sharedLayout(view: settingOptionOne)
        settingOptionOne.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
    func setup(settingOptionTwo: SettingsOptionView) {
        sharedLayout(view: settingOptionTwo)
        settingOptionTwo.topAnchor.constraint(equalTo: settingOneView.bottomAnchor).isActive = true
    }
    
    func settingsOneTapped() {
        delegate?.settingOneTapped()
    }
    
    func settingsTwoTapped() {
        delegate?.settingTwoTapped()
    }
}
