import UIKit

final class AlertView: UIView {
    
    var headBanner: UIView = {
        let banner = UIView()
        banner.backgroundColor = .lightGray
        return banner
    }()
    
    var cancelButton: UIButton = {
        var button = ButtonType.system(title: "Cancel", color: .white).newButton
        button.backgroundColor = Constants.Alert.CancelButton.cancelButtonColor
        button.layer.cornerRadius = 0
        return button
    }()
    
    var doneButton: UIButton = {
        var button = ButtonType.system(title: "Add", color: .white).newButton
        button.backgroundColor = Constants.Color.mainColor.setColor
        button.layer.cornerRadius = 0
        return button
    }()
    
    var resultLabel: UILabel = {
        let searchLabel = UILabel()
        searchLabel.text = "Results"
        searchLabel.textColor = .black
        searchLabel.textAlignment = .center
        searchLabel.font = Constants.Font.fontNormal
        return searchLabel
    }()
    
    var alertLabel: UILabel = {
        let searchLabel = UILabel()
        searchLabel.textColor = .black
        searchLabel.textAlignment = .center
        searchLabel.text = "Find Your Friends"
        searchLabel.font = Constants.Font.fontNormal
        return searchLabel
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        backgroundColor = .white
    }
    
}

extension AlertView {
    
    fileprivate func configureConstaints(label: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        label.heightAnchor.constraint(equalTo: heightAnchor, multiplier: Constants.Dimension.mainHeight).isActive = true
    }
    
    fileprivate func addSubviews() {
        addSubview(doneButton)
        addSubview(alertLabel)
        addSubview(headBanner)
        addSubview(resultLabel)
        addSubview(cancelButton)
    }
    
    fileprivate func configs() {
        configureConstaints(label: alertLabel)
        configureConstaints(label: resultLabel)
    }
    
    private func addHeaderBanner() {
        headBanner.translatesAutoresizingMaskIntoConstraints = false
        headBanner.topAnchor.constraint(equalTo: topAnchor).isActive = true
        headBanner.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        headBanner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        headBanner.heightAnchor.constraint(equalTo: heightAnchor, multiplier: Constants.Dimension.mainHeight).isActive = true
    }
    
    private func addDoneButton() {
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: Constants.Dimension.mainHeight).isActive = true
        doneButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.Alert.CancelButton.cancelButtonWidth).isActive = true
    }
    
    private func addCancelButton() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: Constants.Dimension.mainHeight).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.Alert.CancelButton.cancelButtonWidth).isActive = true
    }
    
    private func addResultLabel() {
        resultLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        resultLabel.topAnchor.constraint(equalTo: topAnchor, constant: bounds.height / 3).isActive = true
    }
    
    private func addAlertLabel() {
        alertLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        alertLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    fileprivate func setupConstraints() {
        addSubviews()
        configs()
        addHeaderBanner()
        addAlertLabel()
        addResultLabel()
        addCancelButton()
        addDoneButton()
    }
}
