import UIKit

class PodCatcherUser {
    
    var userId: String = ""
    var username: String
    var emailAddress: String
    var totalTimeListening: Double = 0 
    var customGenres: [String] = []
    var favoriteEpisodes: [String] = []
    var favoriteCasts: [String : Caster] = [:]
    var casts: [Caster]
    
    init(username: String, emailAddress: String) {
        self.username = username
        self.emailAddress = emailAddress
        self.casts = []
    }
}
