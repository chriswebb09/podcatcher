import UIKit

protocol BottomMenuViewable {
    
    var bottomMenu: BottomMenu { get set }
    
    func hidePopMenu(_ view: UIView)
    func showPopMenu(_ view: UIView)
    func moreButton(tapped: Bool)
}

extension BottomMenuViewable {
    
    func hidePopMenu(_ view: UIView) {
        bottomMenu.hideFrom(view)
    }
    
    func showPopMenu(_ view: UIView){
        bottomMenu.showOn(view)
    }    
}
