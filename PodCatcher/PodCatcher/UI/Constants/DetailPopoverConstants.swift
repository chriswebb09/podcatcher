import UIKit

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
