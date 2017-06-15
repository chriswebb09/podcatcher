import UIKit

final class SplashViewController: UIViewController {
    
    weak var delegate: SplashViewControllerDelegate?
    
    private let splashView: SplashView!
    
    init(splashView: SplashView = SplashView()) {
        self.splashView = splashView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splashView.delegate = self
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true 
        view.addView(view: splashView, type: .full)
        splashView.zoomAnimation {
            print("animation")
        }
    }
}
