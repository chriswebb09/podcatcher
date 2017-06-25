import Foundation

class PodCatcherUserDataStore {
    
    static func userSignIn(username: String, password: String, completion: @escaping (PodCatcherUser?, Error?) -> Void) {
        UserDataAPIClient.loginToAccount(email: username, password: password) { user, error in
            print("here")
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error)
                return
            }
            PullData.pullFromDatabase { pulled in
                dump(pulled)
                guard let user = user else { return }
                pulled.username = user.uid
                pulled.userId = user.uid
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    completion(pulled, nil)
                }
            }
        }
    }
}
