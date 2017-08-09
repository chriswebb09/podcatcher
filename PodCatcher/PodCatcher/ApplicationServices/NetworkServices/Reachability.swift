import Foundation
import SystemConfiguration

//class Reachable {
//
//    private var networkReachability: SCNetworkReachability?
//    private let queue = DispatchQueue.main
//    let ReachabilityDidChangeNotificationName = "ReachabilityDidChangeNotification"
//
//    private var notifying: Bool = false
//     private var currentReachabilityFlags: SCNetworkReachabilityFlags?
//    enum ReachabilityStatus {
//        case notReachable
//        case reachableViaWiFi
//        case reachableViaWWAN
//    }
//
//    static func isInternetAvailable() -> Bool {
//        var zeroAddress = sockaddr_in()
//        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
//        zeroAddress.sin_family = sa_family_t(AF_INET)
//
//        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
//            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
//                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
//            }
//        }
//
//        var flags = SCNetworkReachabilityFlags()
//        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
//            return false
//        }
//        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
//        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
//        return (isReachable && !needsConnection)
//    }
//
//
//
//    func start() {
//        // Checks if we are already listening
//        guard !notifying else { return }
//
//        // Optional binding since `SCNetworkReachabilityCreateWithName` returns an optional object
//        guard let reachability = networkReachability else { return }
//
//        // Creates a context
//        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
//        // Sets `self` as listener object
//        context.info = UnsafeMutableRawPointer(Unmanaged<Reachable>.passUnretained(self).toOpaque())
//
//        let callbackClosure: SCNetworkReachabilityCallBack? = {
//            (reachability: SCNetworkReachability, flags: SCNetworkReachabilityFlags, info: UnsafeMutableRawPointer?) in
//            guard let info = info else { return }
//
//            // Gets the `Handler` object from the context info
//            let handler = Unmanaged<Reachable>.fromOpaque(info).takeUnretainedValue()
//
//            DispatchQueue.main.async {
//                self.checkReachability(flags: flags)
//            }
//        }
//
//        // Registers the callback. `callbackClosure` is the closure where we manage the callback implementation
//        if !SCNetworkReachabilitySetCallback(reachability, callbackClosure, &context) {
//            // Not able to set the callback
//        }
//
//        // Sets the dispatch queue which is `DispatchQueue.main` for this example. It can be also a background queue
//        if !SCNetworkReachabilitySetDispatchQueue(reachability, queue) {
//            // Not able to set the queue
//        }
//
//        // Runs the first time to set the current flags
//        queue.async {
//            // Resets the flags stored, in this way `checkReachability` will set the new ones
//            self.currentReachabilityFlags = nil
//
//            // Reads the new flags
//            var flags = SCNetworkReachabilityFlags()
//            SCNetworkReachabilityGetFlags(reachability, &flags)
//
//            self.checkReachability(flags: flags)
//        }
//
//        notifying = true
//    }
//
//    private func checkReachability(flags: SCNetworkReachabilityFlags) {
//        if currentReachabilityFlags != flags {
//            // 🚨 Network state is changed 🚨
//
//            // Stores the new flags
//            currentReachabilityFlags = flags
//        }
//    }
//
//
//    //    func startNotifier() -> Bool {
//    //
//    //        guard notifying == false else {
//    //            return false
//    //        }
//    //
//    //        var context = SCNetworkReachabilityContext()
//    //        context.info = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
//    //
//    ////        guard let reachability = networkReachability, SCNetworkReachabilitySetCallback(reachability, { (target: SCNetworkReachability, flags: SCNetworkReachabilityFlags, info: UnsafeMutableRawPointer?) in
//    ////            if let currentInfo = info {
//    ////                let infoObject = Unmanaged<AnyObject>.fromOpaque(currentInfo).takeUnretainedValue()
//    ////                if infoObject is Reachable {
//    ////                    let networkReachability = infoObject as! Reachable
//    ////                    NotificationCenter.default.post(name: Notification.Name(rawValue: self.ReachabilityDidChangeNotificationName), object: networkReachability)
//    ////                }
//    ////            }
//    ////        }, &context) == true else { return false }
//    //
//    //        guard SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue) == true else { return false }
//    //
//    //        notifying = true
//    //        return notifying
//    //    }
//
//}
//

class Reachable: NSObject {
    let ReachabilityDidChangeNotificationName = "ReachabilityDidChangeNotification"
    private let reachable = SCNetworkReachabilityCreateWithName(nil, "www.google.com")
    
    // Queue where the `SCNetworkReachability` callbacks run
    private let queue = DispatchQueue.main
    private var networkReachability: SCNetworkReachability?
    // We use it to keep a backup of the last flags read.
    private var currentReachabilityFlags: SCNetworkReachabilityFlags?
    
    // Flag used to avoid starting listening if we are already listening
    private var isListening = false
    
   
    init?(hostAddress: sockaddr_in) {
        var address = hostAddress
        
        guard let defaultRouteReachability = withUnsafePointer(to: &address, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, $0)
            }
        }) else {
            return nil
        }
        
        networkReachability = defaultRouteReachability
        
        super.init()
        if networkReachability == nil {
            return nil
        }
    }
    
    
    static func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
   
    static func networkReachabilityForInternetConnection() -> Reachable? {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        return Reachable(hostAddress: zeroAddress)
    }
 
    func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
    
    // Starts listening
    func start() {
        // Checks if we are already listening
        guard !isListening else { return }
        
        // Optional binding since `SCNetworkReachabilityCreateWithName` returns an optional object
        guard let reachability = reachable else { return }
        
        // Creates a context
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        // Sets `self` as listener object
        context.info = UnsafeMutableRawPointer(Unmanaged<Reachable>.passUnretained(self).toOpaque())
        
        let callbackClosure: SCNetworkReachabilityCallBack? = {
            (reachability:SCNetworkReachability, flags: SCNetworkReachabilityFlags, info: UnsafeMutableRawPointer?) in
            guard let info = info else { return }
            
            // Gets the `Handler` object from the context info
            let handler = Unmanaged<Reachable>.fromOpaque(info).takeUnretainedValue()
            
            DispatchQueue.main.async {
                handler.checkReachability(flags: flags)
            }
        }
        
        // Registers the callback. `callbackClosure` is the closure where we manage the callback implementation
        
        if !SCNetworkReachabilitySetCallback(reachability, callbackClosure, &context) {
            //  let infoObject = Unmanaged<AnyObject>.fromOpaque(currentInfo).takeUnretainedValue()
            // if reachabl  is Reachability {
           // reachability.
            //let networkReachability = infoObject as! Reachability
            NotificationCenter.default.post(name: Notification.Name(rawValue: ReachabilityDidChangeNotificationName), object: reachability)
            // }
            // Not able to set the callback
        }
        
        // Sets the dispatch queue which is `DispatchQueue.main` for this example. It can be also a background queue
        if !SCNetworkReachabilitySetDispatchQueue(reachability, queue) {
            // Not able to set the queue
        }
        
        // Runs the first time to set the current flags
        queue.async {
            // Resets the flags stored, in this way `checkReachability` will set the new ones
            self.currentReachabilityFlags = nil
            
            // Reads the new flags
            var flags = SCNetworkReachabilityFlags()
            SCNetworkReachabilityGetFlags(reachability, &flags)
            
            self.checkReachability(flags: flags)
        }
        
        isListening = true
    }
    
    // Called inside `callbackClosure`
    private func checkReachability(flags: SCNetworkReachabilityFlags) {
        if currentReachabilityFlags != flags {
            // 🚨 Network state is changed 🚨
            
            // Stores the new flags
            currentReachabilityFlags = flags
        }
    }
    
    // Stops listening
    func stop() {
        // Skips if we are not listening
        // Optional binding since `SCNetworkReachabilityCreateWithName` returns an optional object
        guard isListening,
            let reachability = reachable
            else { return }
        
        // Remove callback and dispatch queue
        SCNetworkReachabilitySetCallback(reachability, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(reachability, nil)
        
        isListening = false
    }
}


