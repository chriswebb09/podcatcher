import UIKit

class SectionHeaderView: UICollectionReusableView {
    var titleLabel: UILabel!
    var iconImageView: UIImageView!
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var icon: UIImage? {
        didSet {
            iconImageView.image = icon
        }
    }
}

