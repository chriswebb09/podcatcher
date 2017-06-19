import UIKit

struct PodcastListConstants {
    static let navFont: [String: Any] = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 16)]
    static let edgeInset = UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)
    static let size = CGSize(width: 50, height: 50)
    static let lineSpace: CGFloat = 0
    static let backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
    static let minimumOffset: CGFloat = 500
    static let topFrameHeight = UIScreen.main.bounds.height / 2
    static let topFrameWidth = UIScreen.main.bounds.width
    static let topFrame = CGRect(x: 0, y: 0, width: PodcastListConstants.topFrameWidth, height: PodcastListConstants.topFrameHeight / 1.2)
    static let emptyCastViewFrame = CGRect(x: PodcastListConstants.topFrame.minX, y: PodcastListConstants.topFrame.maxY, width: PodcastListConstants.topFrameWidth, height: PodcastListConstants.topFrameHeight + 10)
}

