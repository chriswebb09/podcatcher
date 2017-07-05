import Foundation

protocol DataSourceProtocol {
    var count: Int { get }
    var store: SearchResultsFetcher { get }
}
