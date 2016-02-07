//
//  ViewController.swift
//  InstagramFeed
//
//  Created by Aditya Balwani on 1/28/16.
//  Copyright © 2016 Aditya Balwani. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var instaImageView: UIView!
    @IBOutlet weak var instaImage: UIImageView!
    var responseArray:[NSDictionary]?
    @IBOutlet weak var tableView: UITableView!
    
    var page = 0
    
    var loadingMoreView:InfiniteScrollActivityView?
    
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.rowHeight = 320;
        tableView.dataSource = self
        tableView.delegate = self
        
        page = 1
        
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        loadData()
    }
    
    func loadData() {
        isMoreDataLoading = true
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            if(self.responseArray == nil) {
                                self.responseArray = responseDictionary["data"] as? [NSDictionary]
                            } else {
                                self.responseArray! += (responseDictionary["data"] as? [NSDictionary])!
                            }
                            self.loadingMoreView!.stopAnimating()
                            self.tableView.reloadData()
                            print(self.responseArray!.count)
                            self.refreshControl.endRefreshing()
                    }
                    self.isMoreDataLoading = false
                }
        });
        task.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("cell made")
        let cell = tableView.dequeueReusableCellWithIdentifier("InstaTableViewCell", forIndexPath: indexPath) as! InstaTableViewCell
        let photo = responseArray?[indexPath.row]
        let photourl = photo?["images"]!["low_resolution"]!!["url"] as? String
        let userName = photo?["user"]!["full_name"]! as? String
        let proPicUrl = photo?["user"]!["profile_picture"] as? String
        
        if let imageUrl = photourl {
            cell.instaImage.setImageWithURL(NSURL(string: imageUrl)!)
        }
        
        if let username = userName {
            cell.nameLabel.text = username
        }
        
        if let profilePic = proPicUrl {
            cell.profileImageView.setImageWithURL(NSURL(string: profilePic)!)
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width / 2
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if responseArray != nil{
            return responseArray!.count
        }
        return 0
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! PhotosDetailsViewController
        let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        let photo = responseArray?[indexPath!.row]
        vc.profilePictureURL = photo?["user"]!["profile_picture"] as? String
        vc.name = photo?["user"]!["full_name"]! as? String
        vc.photoURL = photo?["images"]!["low_resolution"]!!["url"] as? String
    }
    
    func tableView(tableView:UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    var isMoreDataLoading = false
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if(!isMoreDataLoading){
//            isMoreDataLoading = true
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
//                isMoreDataLoading = true
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                loadData()
            }
        }
    }
    
    func refreshControlAction(refreshControl : UIRefreshControl) {
        self.responseArray = nil
        loadData()
    }

}

