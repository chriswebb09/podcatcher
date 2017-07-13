import UIKit

class MiniPlayerView: UIView {

    var playButton: UIButton = {
        var play = UIButton()
        play.setImage(#imageLiteral(resourceName: "play-icon"), for: .normal)
        return play
    }()
    
    var pauseButton: UIButton = {
        var pause = UIButton()
        pause.setImage(#imageLiteral(resourceName: "white-bordered-pause"), for: .normal)
        return pause
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup(button: playButton)
        setup(button: pauseButton)
    }
    
    func setup(button: UIButton) {
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        button.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        button.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true
    }
}
