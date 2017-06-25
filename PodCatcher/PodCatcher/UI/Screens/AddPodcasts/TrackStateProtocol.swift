import Foundation

protocol TrackStateProtocol {
    func getState(for count: Int) -> TrackContentState
}

extension TrackStateProtocol {
    func getState(for count: Int) -> TrackContentState {
        if count > 0 {
            return .results
        } else {
            return .none
        }
    }
}
