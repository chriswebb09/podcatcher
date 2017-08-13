import UIKit

final class StartViewController: UIViewController, LoadingPresenting {
    
    var loadingPop = LoadingPopover()
    var startView: StartView = StartView()
    weak var delegate: StartViewControllerDelegate?
    
    init(startView: StartView = StartView()) {
        self.startView = startView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) h   Kas not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true 
        startView.tag = 0
        view.addView(view: startView, type: .full)
        startView.delegate = self
    }
}

// MARK: - StartViewDelegate

extension StartViewController: StartViewDelegate {
    
    func continueAsGuestTapped() {
        showLoadingView(loadingPop: loadingPop)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.delegate?.continueAsGuestSelected()
        }
    }
}
