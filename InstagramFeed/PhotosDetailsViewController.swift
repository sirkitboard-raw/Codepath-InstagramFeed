//
//  PhotosDetailsViewController.swift
//  InstagramFeed
//
//  Created by Aditya Balwani on 2/4/16.
//  Copyright © 2016 Aditya Balwani. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosDetailsViewController: UIViewController {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var instaImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    
    var photoURL: String!
    var profilePictureURL: String!
    var name: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let imageUrl = self.photoURL {
            self.instaImageView.setImageWithURL(NSURL(string: imageUrl)!)
        }
        
        if let username = self.name {
            self.profileNameLabel.text = username
        }
        
        if let profilePic = self.profilePictureURL {
            self.profilePic.setImageWithURL(NSURL(string: profilePic)!)
            self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2
        }

        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
