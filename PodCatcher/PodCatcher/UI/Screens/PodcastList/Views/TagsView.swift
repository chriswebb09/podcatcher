import UIKit

class TagsView: UIView {
    
    var pillViews: [PillView]!
    
    func configure(pills: [PillView]) {
        for index in 0..<pills.count {
            if index == 0 {
                setup(firstPill: pills[index])
            }  else if index > 0 && index <  pills.count {
                let previousPill = pills[index - 1]
                setup(with: pills[index], and: previousPill)
            }
        }
    }
    
    func sharedLayout(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        view.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.14).isActive = true
        view.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func setup(with currentPill: PillView, and previousPill: PillView) {
        sharedLayout(view: currentPill)
        currentPill.leftAnchor.constraint(equalTo: previousPill.rightAnchor, constant: frame.width * 0.08).isActive = true
    }
    
    func setup(firstPill: PillView) {
        sharedLayout(view: firstPill)
        firstPill.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    }
}
