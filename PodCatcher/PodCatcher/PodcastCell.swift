import UIKit

class PodcastCell: UICollectionViewCell {
   
    static let reuseIdentifier = "Cell"
    
    var podcastImageView: UIImageView = {
        var teamMemberImage = UIImageView()
        teamMemberImage.layer.borderWidth = 2
        teamMemberImage.clipsToBounds = true
        return teamMemberImage
    }()
    
    var teamMemberNameLabel: UILabel = {
        var teamMemberNameLabel = UILabel()
        teamMemberNameLabel.sizeToFit()
        teamMemberNameLabel.font = UIFont(name: "HelveticaNeue", size: 22)
        return teamMemberNameLabel
    }()
    
    var podcastTitleLabel: UILabel = {
        var teamMemberTitleLabel = UILabel()
        teamMemberTitleLabel.sizeToFit()
        teamMemberTitleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        return teamMemberTitleLabel
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        isUserInteractionEnabled = true
        backgroundColor = UIColor.white
        self.contentView.layer.cornerRadius = 2.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true;
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width:0,height: 2.0)
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false;
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.contentView.layer.cornerRadius).cgPath
    }
    
    func configureCell(model: PocastCellModel) {
        layoutSubviews()
        setupConstraints()
        self.layoutIfNeeded()
        podcastImageView.image = model.podcastImage
        teamMemberNameLabel.text = model.item.collectionName
        podcastTitleLabel.text = model.podcastTitle
    }
}

extension PodcastCell: Reusable {
    
    func setupConstraints() {
        contentView.addSubview(podcastTitleLabel)
        podcastTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        podcastTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        podcastTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}


