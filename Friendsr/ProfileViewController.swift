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

    var profile: Profile?

    override func viewDidLoad() {
        super.viewDidLoad()

//        for index in 1...5 {
//            let buttonView = UIButton.init()
//            buttonView.setTitle("\(index) star", forState: .Normal)
//            ratingButtonContainer.addArrangedSubview(buttonView)
//        }

        profileImage.image = profile!.image
        name.text = profile!.fullName
        details.text = profile!.details
    }

    @IBAction func popView(sender: UIButton) {
        dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
}
