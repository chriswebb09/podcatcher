import UIKit

struct TabbarConstants {
    static let navXYOrigin: CGFloat = 0
    static let navHeightMultiplier: CGFloat = 1.2
}

public struct Tabbar {
    public static let tint = UIColor(red:0.07, green:0.59, blue:1.00, alpha:1.0)
    public static let tabbarFrameHeight: CGFloat = 0.09
}

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

struct PodcastCellConstants {
    static let podcastTitleLabelWidthMultiplier: CGFloat = 0.76
    static let podcastTitleLabelLeftOffset: CGFloat = UIScreen.main.bounds.width * 0.04
    static let playtimeLabelRightOffset: CGFloat = UIScreen.main.bounds.width * -0.045
    static let playtimeLabelWidthMultiplier: CGFloat = 0.2
}

struct PodcastListTopViewConstants {
    static let podcastImageViewCenterYOffset: CGFloat = UIScreen.main.bounds.height * -0.025
    static let preferencesViewHeightMultiplier: CGFloat = 0.12
    static let tagsViewHeightMultiplier: CGFloat = 0.13
    static let podcastImageViewHeightMultiplier: CGFloat = 0.8
    static let podcastImageViewWidthMultiplier: CGFloat = 0.76
    static let titleLabelHeightMultiplier: CGFloat = 0.3
    static let titleLabelTopOffset: CGFloat = UIScreen.main.bounds.height * 0.0008
}

struct BrowseListTopViewConstants {
    static let podcastImageViewCenterYOffset: CGFloat = UIScreen.main.bounds.height * -0.01
    static let preferencesViewHeightMultiplier: CGFloat = 0.12
    static let tagsViewHeightMultiplier: CGFloat = 0.13
    static let podcastImageViewHeightMultiplier: CGFloat = 0.72
    static let podcastImageViewWidthMultiplier: CGFloat = 0.82
    static let titleLabelHeightMultiplier: CGFloat = 0.3
    static let titleLabelTopOffset: CGFloat = UIScreen.main.bounds.height * 0.0008
}
