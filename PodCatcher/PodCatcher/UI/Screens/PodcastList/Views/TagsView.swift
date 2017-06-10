import UIKit

class TagsView: UIView {
    
    var pillViews: [PillView]!
    
    func configure(pills: [PillView]) {
        for (index, pill) in pills.enumerated() {
            if index > 0 && index <  pills.count {
                let previousPill = pills[index - 1]
                setup(with: pill, and: previousPill)
            }
        }
    }
    
    
    func sharedLayout(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        view.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.01).isActive = true
        view.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func setup(with currentPill: PillView, and previousPill: PillView) {
        sharedLayout(view: currentPill)
        currentPill.leftAnchor.constraint(equalTo: previousPill.rightAnchor, constant: frame.width * 0.1).isActive = true
    }
}
