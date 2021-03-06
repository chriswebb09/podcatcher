import UIKit

final class SplashViewController: BaseViewController {
    
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
        initialize()
    }
    
    func initialize() {
        splashView.delegate = self
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        view.addView(view: splashView, type: .full)
        splashView.zoomAnimation {
            print("animation")
        }
    }
}

// MARK: - SplashViewDelegate

extension SplashViewController: SplashViewDelegate {
    
    func animation(_ isComplete: Bool) {
        animate()
    }
    
    func animate() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            if let strongSelf = self {
                strongSelf.delegate?.splashAnimation(finished: true)
            }
        }
    }
}
