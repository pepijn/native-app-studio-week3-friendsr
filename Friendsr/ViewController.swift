//
//  ViewController.swift
//  Friendsr
//
//  Created by Pepijn Looije on 11/11/15.
//  Copyright © 2015 Pepijn Looije. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, NSXMLParserDelegate {
    @IBOutlet weak var leftColumn: UIStackView!
    @IBOutlet weak var rightColumn: UIStackView!
    @IBOutlet weak var profileView: UIView!

    var profiles = [Profile]() {
        didSet {
            leftColumn.subviews.forEach({
                if !$0.hidden {
                    $0.removeFromSuperview()
                }
            })
            rightColumn.subviews.forEach({ $0.removeFromSuperview() })

            for (index, profile) in profiles.enumerate() {
                let view = NSKeyedUnarchiver.unarchiveObjectWithData(NSKeyedArchiver.archivedDataWithRootObject(profileView)) as! UIView

                let imageView = view.subviews[0] as! UIImageView
                imageView.image = profile.imagePreview

                let button = view.subviews[1] as! UIButton
                button.setTitle(profile.shortName, forState: .Normal)
                button.addTarget(self, action: "pickProfile:", forControlEvents: .TouchDown)

                if profile.rating != nil {
                    let rating = view.subviews[2] as! UILabel
                    rating.text = "\(profile.rating!) ★"
                }

                var parentView: UIStackView
                if index < 3 {
                    parentView = leftColumn
                } else {
                    parentView = rightColumn
                }
                view.hidden = false
                parentView.addArrangedSubview(view)
            }
        }
    }

    func pickProfile(button: UIButton) {
        let shortName = button.titleLabel!.text as String!

        for profile in profiles {
            if (profile.shortName != shortName) {
                continue
            }
            performSegueWithIdentifier("detailView", sender: profile)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController as! ProfileViewController
        destinationViewController.profile = sender as? Profile
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let path = NSBundle.mainBundle().pathForResource("friends", ofType: "xml")
        let parser = NSXMLParser.init(contentsOfURL: NSURL.init(fileURLWithPath: path!))!
        parser.delegate = self
        parser.parse()
        profileView.hidden = true

        let soundFilePath = NSBundle.mainBundle().pathForResource("friends_theme", ofType: "mp3")
        let soundFileURL = NSURL(fileURLWithPath: soundFilePath!)
        do {
            let player = try AVAudioPlayer(contentsOfURL: soundFileURL)
            player.numberOfLoops = -1 //infinite
            player.play()
        } catch {
            print("fail")
        }
    }

    override func viewWillAppear(animated: Bool) {
        var profiles = [Profile]()
        for (i, _) in shortNames.enumerate() {
            let profile = Profile(shortName: shortNames[i], fullName: fullNames[i], details: details[i])
            profiles.append(profile)
        }
        self.profiles = profiles
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var lastElementName = String()
    var lastAttributeDict = [String : String]()

    var parentElementName = String()
    var parentAttributeDict = [String : String]()

    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName != lastElementName {
            self.parentElementName = lastElementName
            self.parentAttributeDict = lastAttributeDict
        }
        self.lastElementName = elementName
        self.lastAttributeDict = attributeDict
    }

    var shortNames = [String]()
    var fullNames = [String]()
    var details = [String]()

    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if lastElementName != "item" {
            return
        }

        let string = (string as NSString).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if string.characters.count == 0 {
            return
        }

        switch parentAttributeDict["name"] as String! {
        case "friend_names":
            shortNames.append(string)
        case "friend_full_names":
            fullNames.append(string)
        case "friend_details":
            details.append(string)
        default:
            return
        }
    }
}

