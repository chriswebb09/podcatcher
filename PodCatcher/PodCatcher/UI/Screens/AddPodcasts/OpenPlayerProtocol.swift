import Foundation

protocol OpenPlayerProtocol {
    func setup(caster: Caster, index: Int, user: PodCatcherUser?) -> PlayerViewController
}

extension OpenPlayerProtocol {
    func setup(caster: Caster, index: Int, user: PodCatcherUser?) -> PlayerViewController {
        var trackPlayer = AudioFilePlayer()
        let destination = PlayerViewController(index: index, caster: caster , user: user)
        return destination
    }
}
