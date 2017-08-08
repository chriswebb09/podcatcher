import Foundation

public struct NotificationDescriptor<A> {
    let name: Notification.Name
    let convert: (Notification) -> A
}

public class NotificationToken {
    let token: NSObjectProtocol
    let center: NotificationCenter
    init(token: NSObjectProtocol, center: NotificationCenter) {
        self.token = token
        self.center = center
    }
    deinit {
        center.removeObserver(token)
    }
}

extension NotificationCenter {
    func addObserver<A>(descriptor: NotificationDescriptor<A>, object: Any? = nil, queue: OperationQueue? = nil, using block: @escaping (A) -> ()) -> NotificationToken {
        let token = addObserver(forName: descriptor.name, object: nil, queue: nil, using: { note in
            block(descriptor.convert(note))
        })
        return NotificationToken(token: token, center: self)
    }
}
