import Foundation

protocol PopDelegate: class { }

protocol EntryPopoverDelegate: PopDelegate {
    func userDidEnterPlaylistName(name: String)
}

