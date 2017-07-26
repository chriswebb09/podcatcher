import UIKit

protocol PopDelegate: class { }

protocol EntryPopoverDelegate: PopDelegate {
    func userDidEnterPlaylistName(name: String)
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

final class EntryPopover: BasePopoverAlert {
    
    var state: EntryState = .hidden
    
    weak var delegate: EntryPopoverDelegate?
    
    var popView: EntryView = {
        let popView = EntryView()
        popView.layer.cornerRadius = DetailPopoverConstants.cornerRadius
        popView.backgroundColor = .white
        popView.layer.borderColor = UIColor.black.cgColor
        popView.layer.borderWidth = DetailPopoverConstants.borderWidth
        popView.isUserInteractionEnabled = true
        return popView
    }()
    
    public override func showPopView(viewController: UIViewController) {
        super.showPopView(viewController: viewController)
        setupPop()
        state = .enabled
        popView.frame = CGRect(x: DetailPopoverConstants.popViewFrameX,
                               y: DetailPopoverConstants.popViewFrameY,
                               width: DetailPopoverConstants.popViewFrameWidth,
                               height: EntryPopoverConstants.popViewFrameHeight)
        popView.center = CGPoint(x: UIScreen.main.bounds.midX, y: DetailPopoverConstants.popViewFrameCenterY)
        popView.clipsToBounds = true
        viewController.view.addSubview(popView)
        viewController.view.bringSubview(toFront: popView)
        popView.isHidden = true
    }
    
    override func hidePopView(viewController: UIViewController) {
        guard let listname = popView.entryField.text else { return }
        state = .hidden
        delegate?.userDidEnterPlaylistName(name: listname)
        popView.entryField.text = "" 
        super.hidePopView(viewController: viewController)
        popView.isHidden = true
        viewController.view.sendSubview(toBack: popView)
    }
    
    func setupPop() {
        popView.configureView()
    }
}
