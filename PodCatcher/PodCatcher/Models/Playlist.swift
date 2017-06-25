import UIKit


final class PlaylistItem {
    //var track: Track?
    var next: PlaylistItem?
    weak var previous: PlaylistItem?
}


final class Playlist {
    
    private var head: PlaylistItem?
    
    dynamic var id: String? = ""
    dynamic var name: String? = ""
    dynamic var current: Bool = false
    
    dynamic var itemCount: Int = 0
    
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
        //        else if head == nil {
        //            head = newPlaylistItem
        //        }
    }
    
    func printAllKeys() {
        var current: PlaylistItem! = head
        var index = 1
        while current != nil {
           // print(current.track?.previewUrl ?? "track does not have preview url")
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
    
//    func removeFromPlaylist(for playlistItem: PlaylistItem?) -> Track? {
//        let previous = playlistItem?.previous
//        let next = playlistItem?.next
//        
//        if let previous = previous {
//            previous.next = next
//        } else {
//            head = next
//        }
//        next?.previous = previous
//        
//        playlistItem?.previous = nil
//        playlistItem?.next = nil
//        guard let trackItem = playlistItem?.track else { return nil }
//        return trackItem
//    }
//    
//    func removeAll() {
//        var track = head
//        
//        while let next = track?.next {
//            track?.previous = nil
//            track = nil
//            track = next
//        }
//        head = nil
//        itemCount = 0
//    }
//    
//    
//    func contains(playlistItem item: PlaylistItem) -> Bool {
//        guard let currentTrack = head else { return false }
//        while currentTrack != item && currentTrack.next != nil {
//            guard let currentTrack = currentTrack.next else { return false }
//            if currentTrack == item {
//                return true
//            }
//        }
//        return false
//    }
}
