//
//  StoryboardIdentifiable.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 1/4/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

// MARK: - Storyboard Identifiable

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

// MARK: - View Controller

extension StoryboardIdentifiable where Self: UIViewController {
    
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIStoryboard {
    // Enumeration of all storyboard names used in the app
    
    enum Storyboard: String {
        case splash, tutorial, authentication, start, login, signup, itemlist, profile, listItem
        
        // The name of the storyboard's file, returned with capitalization applied
        
        var filename: String {
            return rawValue.capitalized
        }
    }
    
    convenience init(_ storyboard: Storyboard, bundle: Bundle? = nil) throws {
        self.init(name: storyboard.filename, bundle: bundle)
    }
    
    func instantiateViewController<T: UIViewController>() throws -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            let error = StoryboardIdentifiableError.unrecognizedIdentifier
            print("\(error.localizedDescription): \(T.storyboardIdentifier)")
            throw error
        }
        return viewController
    }
}

// MARK: - Storyboard Identifiable Error

enum StoryboardIdentifiableError: Error {
    case unrecognizedIdentifier, unrecognizedType
}

extension UIViewController: StoryboardIdentifiable { }

