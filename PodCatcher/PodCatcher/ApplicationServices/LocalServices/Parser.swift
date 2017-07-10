import Foundation

protocol Parser: class {
    
    var recordKey: String { get set }
    var dictionaryKeys: [String] { get set }
    var currentDictionary: [String: String]! { get set }
    var currentValue: String? { get set }
    var results: [[String: String]] { get set }
    
    func parseResponse(_ data: Data, completion: @escaping ([[String: String]]) -> Void)
}
