import UIKit

struct PlayerViewModel {
    let title: String
    var timer: Timer?
    var progressIncrementer: Float = 0
    var time: Int = 0
    var progress: Float = 0
    let imageUrl: UIImage
}
