import UIKit

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
