//
//  Profile.swift
//  Friendsr
//
//  Created by Pepijn Looije on 11/11/15.
//  Copyright © 2015 Pepijn Looije. All rights reserved.
//

import Foundation
import UIKit

class Profile {
    let shortName: String
    let fullName: String
    let details: String

    var imagePreview: UIImage {
        return UIImage.init(named: "\(shortName.lowercaseString)preview")!
    }

    var image: UIImage {
        return UIImage.init(named: "\(shortName.lowercaseString)")!
    }

    var rating: Int? {
        return NSUserDefaults.standardUserDefaults().valueForKey(fullName) as? Int
    }

    init(shortName: String, fullName: String, details: String) {
        self.shortName = shortName
        self.fullName = fullName
        self.details = details
    }

    func rate(rating: Int) {
        NSUserDefaults.standardUserDefaults().setObject(rating, forKey: fullName)
    }
}