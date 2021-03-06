import UIKit

struct EqualizerConstants {
    static let lineSizeDenominator: CGFloat = 20
    static let xOffsetDenominator: CGFloat =  0.043
    static let yMultiplier: CGFloat = 5.5
    static let pointOffsetMultiplier: CGFloat = 0.8
    static let heightOffsetDenominator: CGFloat = 1.9
    static let xValMultiplier: CGFloat = 1.9
    static let yValMutliplier: CGFloat = 0.45
    static let widthValMultiplier: CGFloat = 2
    static let heightValMultiplier: CGFloat = 0.1
    static let durationMultiplier: Double = 1.1
    static let cornerRadii: CGSize = CGSize(width: 0.0, height: 0.0)
}

struct StartViewConstants {
    static let gradientColors = [UIColor(red:0.94, green:0.31, blue:0.81, alpha:1.0).cgColor,
                                 UIColor(red:0.32, green:0.13, blue:0.70, alpha:1.0).cgColor]
    static let logoCenterOffset = UIScreen.main.bounds.height * -0.15
    static let logoWidthMultiplier: CGFloat = 0.72
    static let logoHeightMultiplier: CGFloat = 0.1
    static let buttonTopOffset: CGFloat = UIScreen.main.bounds.height * 0.12
    static let buttonFont = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
    static let buttonAlpha: CGFloat = 0.8
}

struct CALayerConstants {
    static let shadowWidthMultiplier: CGFloat = 0.0000001
    static let shadowHeightMultiplier: CGFloat = 0.000001
}

struct LogoConstants {
    static let logoImageWidth = CGFloat(0.3)
    static let logoImageHeight = CGFloat(0.1)
    static let startAlpha: CGFloat = 0.7
    static let zoomOutTranform: CGAffineTransform = CGAffineTransform(scaleX: 8, y: 18)
}

struct EntryPopoverConstants {
    static let cornerRadius: CGFloat = 10
    static let borderWidth: CGFloat = 10
    static let popViewFrameX: CGFloat = UIScreen.main.bounds.width * 0.5
    static let popViewFrameY: CGFloat = UIScreen.main.bounds.height * -0.5
    static let popViewFrameWidth: CGFloat = UIScreen.main.bounds.width * 0.9
    static let popViewFrameHeight: CGFloat = UIScreen.main.bounds.height * 0.55
    static let popViewFrameCenterY: CGFloat = UIScreen.main.bounds.height / 2.5
}

struct HomeListTopViewConstants {
    static let podcastImageViewCenterYOffset: CGFloat = UIScreen.main.bounds.height * -0.03
    static let preferencesViewHeightMultiplier: CGFloat = 0.12
    static let tagsViewHeightMultiplier: CGFloat = 0.13
    static let podcastImageViewHeightMultiplier: CGFloat = 0.70
    static let podcastImageViewWidthMultiplier: CGFloat = 0.70
    static let titleLabelHeightMultiplier: CGFloat = 0.3
    static let titleLabelTopOffset: CGFloat = UIScreen.main.bounds.height * 0.0008
}

struct Constants {
    public struct Alert {
        public struct CancelButton {
            public static let cancelButtonWidth: CGFloat = 0.5
          //  public static let cancelButtonColor: UIColor = UIColor(red:0.88, green:0.35, blue:0.35, alpha:1.0)
        }
    }
    
    public struct Font {
        public static let fontNormal = UIFont(name: "HelveticaNeue-Light", size: 18)
        public static let fontSmall = UIFont(name: "HelveticaNeue-Light", size: 12)
        public static let fontMedium = UIFont(name: "HelveticaNeue-Light", size: 16)
        public static let fontLarge = UIFont(name: "HelveticaNeue-Thin", size: 22)
        
        public static let bolderFontSmall = UIFont(name: "HelveticaNeue", size: 12)
        public static let bolderFontMediumSmall = UIFont(name: "HelveticaNeue", size: 14)
        public static let bolderFontMedium = UIFont(name: "HelveticaNeue", size: 16)
        public static let bolderFontMediumLarge = UIFont(name: "HelveticaNeue", size: 20)
        public static let bolderFontLarge = UIFont(name: "HelveticaNeue", size: 22)
        public static let bolderFontNormal = UIFont(name: "HelveticaNeue", size: 18)
    }
    
    public struct Dimension {
        static let screenHeight = UIScreen.main.bounds.height
        static let screenWidth = UIScreen.main.bounds.width
        public static let mainWidth:CGFloat = 0.4
        public static let mainOffset:CGFloat = 30
        public static let buttonHeight:CGFloat = 0.07
        public static let cellButtonHeight:CGFloat = 0.03
        public static let saveButtonHeight:CGFloat = 0.05
        // static let buttonHeight = CGFloat(0.009)
        public static let topOffset:CGFloat = 10
        public static let bottomOffset:CGFloat = -10
        public static let settingsOffset:CGFloat = 0.05
        public static let mainHeight:CGFloat = 0.2
        public static let fieldHeight: CGFloat = 0.75
        public static let height: CGFloat = 0.5
        public static let width: CGFloat = 0.85
    }
}

struct PlayerViewConstants {
    static let preferencesViewBackgroundColor = UIColor(red:0.92, green:0.32, blue:0.33, alpha:1.0)
    static let controlsViewBackgroundColor = UIColor(red:0.10, green:0.09, blue:0.12, alpha:1.0)
    static let buttonWidthMultiplier: CGFloat = 0.19
    static let backButtonWidthMultiplier: CGFloat = 0.09
    static let backButtonHeightMultiplier: CGFloat = 0.11
    static let backButtonCenterYOffset: CGFloat = -0.08
    static let progressViewWidthMultiplier: CGFloat = 0.6
    static let progressViewHeightMultiplier: CGFloat = 0.005
    static let playTimeLabelHeightMutliplier: CGFloat = 0.25
    static let trackTitleViewHeightMultiplier: CGFloat = 0.122
    static let trackTitleLabelHeightMultiplier: CGFloat = 1
    static let trackTitleLabelCenterYOffset: CGFloat =  0.5
    static let trackTitleLabelWidthMultiplier: CGFloat =  0.94
    static let artworkViewHeightMultiplier: CGFloat = 0.48
    static let albumWidthMultiplier: CGFloat = 0.3
    static let albumHeightMultiplier: CGFloat = 0.4
    static let preferenceHeightMultiplier: CGFloat = 0.034
    static let thumbsUpLeftOffset: CGFloat = 0.06
    static let artistInfoWidthMultiplier: CGFloat = 0.18
    static let artistInfoHeightMultiplier: CGFloat = 1
    static let artistInfoRightOffset: CGFloat = -0.02
    static let thumbsDownLeftOffset: CGFloat = 0.18
    static let controlsViewHeightMultiplier: CGFloat = 0.299
    static let thumbsHeightMultplier: CGFloat = 0.45
    static let thumbsWidthMultiplier: CGFloat = 0.04
    static let titleViewBackgroundColor = UIColor(red:0.92, green:0.32, blue:0.33, alpha:1.0)
    static let purpleGradientColors: [CGColor] = [UIColor(red:0.20, green:0.06, blue:0.16, alpha:1.0).cgColor,
                                                  UIColor(red:0.48, green:0.08, blue:0.27, alpha:1.0).cgColor]
}

struct DetailPopoverConstants {
    static let cornerRadius: CGFloat = 10
    static let borderWidth: CGFloat = 10
    static let popViewFrameX: CGFloat = UIScreen.main.bounds.width * 0.5
    static let popViewFrameY: CGFloat = UIScreen.main.bounds.height * -0.5
    static let popViewFrameWidth: CGFloat = UIScreen.main.bounds.width * 0.9
    static let popViewFrameHeight: CGFloat = UIScreen.main.bounds.height * 0.5
    static let popViewFrameCenterY: CGFloat = UIScreen.main.bounds.height / 2.5
}

struct LoadingViewConstants {
    static let frameOriginX: CGFloat = 0
    static let frameOriginY: CGFloat = 0
    static let frameWidth: CGFloat = 80
    static let frameHeight: CGFloat = 80
    static let cornerRadius: CGFloat = 10
    static let backgroundColor: UIColor = UIColor(red:0.27, green:0.27, blue:0.27, alpha:0.8)
    
    struct ActivityIndicator {
        static let originXY: CGFloat = 0
        static let width: CGFloat = 40
        static let height: CGFloat = 40
        static let containerCenterX: CGFloat = UIScreen.main.bounds.width / 2
        static let containerCenterY: CGFloat = UIScreen.main.bounds.height / 2.5
    }
}

struct EntryViewConstants {
    static let entryFieldHeightMultiplier: CGFloat = 0.16
    static let borderWidth: CGFloat = 1.5
}

struct EmptyViewConstants {
    static let iconHeightMultiplier: CGFloat = 0.16
    static let iconWidthMutliplier: CGFloat = 0.28
    static let iconCenterYOffset: CGFloat = UIScreen.main.bounds.height * -0.02
}

struct TabbarConstants {
    static let navXYOrigin: CGFloat = 0
    static let navHeightMultiplier: CGFloat = 1.2
}

public struct Tabbar {
    public static let tint = UIColor(red:0.07, green:0.59, blue:1.00, alpha:1.0)
    public static let tabbarFrameHeight: CGFloat = 0.09
}

struct PodcastListConstants {
    static let navFont: [String: Any] = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white, NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-Thin", size: 16) as Any]
    static let edgeInset = UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)
    static let size = CGSize(width: 50, height: 50)
    static let lineSpace: CGFloat = 0
    static let backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
    static let minimumOffset: CGFloat = 800
    static let topFrameHeight = UIScreen.main.bounds.height / 2
    static let topFrameWidth = UIScreen.main.bounds.width
    static let topFrame = CGRect(x: 0, y: 0, width: PodcastListConstants.topFrameWidth, height: PodcastListConstants.topFrameHeight / 1.2)
    static let emptyCastViewFrame = CGRect(x: PodcastListConstants.topFrame.minX, y: PodcastListConstants.topFrame.maxY, width: PodcastListConstants.topFrameWidth, height: PodcastListConstants.topFrameHeight + 10)
}

struct PodcastCellConstants {
    static let podcastTitleLabelWidthMultiplier: CGFloat = 0.78
    static let podcastTitleLabelLeftOffset: CGFloat = UIScreen.main.bounds.width * 0.04
    static let playtimeLabelRightOffset: CGFloat = UIScreen.main.bounds.width * -0.045
    static let playtimeLabelWidthMultiplier: CGFloat = 0.2
}

//struct PodcastListTopViewConstants {
//    static let podcastImageViewCenterYOffset: CGFloat = UIScreen.main.bounds.height * -0.022
//    static let preferencesViewHeightMultiplier: CGFloat = 0.1
//    static let tagsViewHeightMultiplier: CGFloat = 0.13
//    static let podcastImageViewHeightMultiplier: CGFloat = 0.87
//    static let podcastImageViewWidthMultiplier: CGFloat = 0.76
//    static let titleLabelHeightMultiplier: CGFloat = 0.3
//    static let titleLabelTopOffset: CGFloat = UIScreen.main.bounds.height * 0.0008
//}

//struct BrowseListTopViewConstants {
//    static let podcastImageViewCenterYOffset: CGFloat = UIScreen.main.bounds.height * -0.01
//    static let preferencesViewHeightMultiplier: CGFloat = 0.12
//    static let tagsViewHeightMultiplier: CGFloat = 0.13
//    static let podcastImageViewHeightMultiplier: CGFloat = 0.74
//    static let podcastImageViewWidthMultiplier: CGFloat = 0.9
//    static let titleLabelHeightMultiplier: CGFloat = 0.3
//    static let titleLabelTopOffset: CGFloat = UIScreen.main.bounds.height * 0.0008
//}

struct BasePopoverAlertConstants {
    static let popViewX = UIScreen.main.bounds.width / 2
    static let popViewY = UIScreen.main.bounds.height / 2
    static let containerOpacity: Float = 0.4
}

struct DetailViewConstants {
    static let heightMultiplier: CGFloat = 0.2
    static let fieldWidth: CGFloat = 0.9
    static let borderWidth: CGFloat = 2
    static let largeCornerRadius: CGFloat = 5
    static let cornerRadius: CGFloat = 2
    static let shadowOpacity: Float = 0.5
    static let shadowOffset = CGSize(width: 0, height: 2)
    static let mainColor: UIColor = UIColor(red:0.13, green:0.21, blue:0.44, alpha:1.0)
    static let titleFont: UIFont = UIFont(name: "AvenirNext-Regular", size: 18)!
}

struct ConfirmLoadingViewConstants {
    static let frameOriginX: CGFloat = 0
    static let frameOriginY: CGFloat = 0
    static let frameWidth: CGFloat = 150
    static let frameHeight: CGFloat = 140
    static let cornerRadius: CGFloat = 10
    static let backgroundColor: UIColor = UIColor(red:0.27, green:0.27, blue:0.27, alpha:0.8)
    
    struct ActivityIndicator {
        static let originXY: CGFloat = 0
        static let width: CGFloat = 100
        static let height: CGFloat = 100
        static let containerCenterX: CGFloat = UIScreen.main.bounds.width / 2
        static let containerCenterY: CGFloat = UIScreen.main.bounds.height / 2.5
    }
}
