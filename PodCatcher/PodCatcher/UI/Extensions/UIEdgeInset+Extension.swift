import UIKit

extension UIEdgeInsets {
    init(equalInset inset: CGFloat) {
        top = inset
        left = inset
        right = inset
        bottom = inset
    }
}

extension Sequence where Iterator.Element: AnyObject {
    func containsIdenticalObject(to object: AnyObject) -> Bool {
        return contains { $0 === object }
    }
}

extension Array {
    var decomposed: (Iterator.Element, [Iterator.Element])? {
        guard let x = first else { return nil }
        return (x, Array(self[1..<count]))
    }
}
