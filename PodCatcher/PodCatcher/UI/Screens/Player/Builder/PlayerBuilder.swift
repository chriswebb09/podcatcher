import UIKit

class PlayerBuilder {
    func build(podcast:  CasterSearchResult, user: PodCatcherUser?, delegate: PlayerViewControllerDelegate, index: Int) -> PlayerViewController {
        let playerView = PlayerView()
        CALayer.createGradientLayer(with: [UIColor(red:0.94, green:0.31, blue:0.81, alpha:1.0).cgColor, UIColor(red:0.32, green:0.13, blue:0.70, alpha:1.0).cgColor], layer: playerView.backgroundView.layer, bounds: UIScreen.main.bounds)
        let playerViewController = PlayerViewController(index: index, caster: podcast, user: user, image: nil)
        playerViewController.delegate = delegate
        return playerViewController
    }
}
