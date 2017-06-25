import UIKit

final class Playlist {
    
    var head: PlaylistItem?
    
    var id: String? = ""
    var name: String? = ""
    var current: Bool = false
    
    var itemCount: Int = 0
    
    var isEmpty: Bool? {
        return head == nil
    }
    
    private var last: PlaylistItem? {
        if var track = head {
            while case let next? = track.next {
                track = next
            }
            return track
        } else {
            return nil
        }
    }
    
    func append(newPlaylistItem: PlaylistItem?) {
        itemCount += 1
        
        guard head != nil else {
            head = newPlaylistItem
            return
        }
        if let lastItem = last {
            newPlaylistItem?.previous = lastItem
            lastItem.next = newPlaylistItem
        }
    }
    
    func printAllKeys() {
        var current: PlaylistItem! = head
        var index = 1
        while current != nil {
            index += 1
            current = current.next
        }
    }
    
    func playlistItem(at index: Int) -> PlaylistItem? {
        if index >= 0 {
            var trackItem = head
            var index = index
            while let trackAt = trackItem, trackItem != nil {
                if index == 0 {
                    return trackAt
                }
                index -= 1
                trackItem = trackAt.next
            }
        }
        return nil
    }
    
    func reverse() {
        var track = head
        while let currentTrack = track {
            track = currentTrack.next
            swap(&currentTrack.next, &currentTrack.previous)
            head = currentTrack
        }
    }
}
