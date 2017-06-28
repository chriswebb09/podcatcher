import UIKit

class DataLoadOperation: Operation {
    
    var test: String?
    
    var loadingCompletion: ((String) -> Void)?
    
    private let _test:  String
    
    init(_ test: String) {
        _test = test
    }
    
    override func main() {
        if isCancelled { return }
        self.test = _test
        if let loadingCompletion = loadingCompletion {
            DispatchQueue.main.async {
                loadingCompletion(self._test)
            }
        }
    }
}
