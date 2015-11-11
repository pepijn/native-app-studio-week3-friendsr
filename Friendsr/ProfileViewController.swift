//
//  ProfileViewController.swift
//  Friendsr
//
//  Created by Pepijn Looije on 11/11/15.
//  Copyright © 2015 Pepijn Looije. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var ratingButtonContainer: UIStackView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var details: UITextView!
    @IBOutlet weak var ratingControl: UISegmentedControl!

    var profile: Profile?

    override func viewDidLoad() {
        super.viewDidLoad()

        profileImage.image = profile!.image
        name.text = profile!.fullName
        details.text = profile!.details

        let rating = profile?.rating

        if rating != nil {
            ratingControl.selectedSegmentIndex = rating! - 1
        }
    }

    @IBAction func popView(sender: AnyObject) {
        dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    @IBAction func rate(sender: UISegmentedControl) {
        profile?.rate(sender.selectedSegmentIndex + 1)
        popView(sender)
    }
}
