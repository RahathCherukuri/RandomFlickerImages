//
//  ViewController.swift
//  RandomFlickerImages
//
//  Created by Rahath cherukuri on 3/5/16.
//  Copyright © 2016 Rahath cherukuri. All rights reserved.
//

import UIKit

let BASE_URL = "https://api.flickr.com/services/rest/"
let METHOD_NAME = "flickr.photos.search"
let API_KEY = "f7789d295e6e0e090c774d52d32e8741"
let EXTRAS = "url_m"
let SAFE_SEARCH = "1"
let DATA_FORMAT = "json"
let NO_JSON_CALLBACK = "1"

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func fetchImagesButtonClicked(sender: UIButton) {
        
        var methodArguments = [
            "method": METHOD_NAME,
            "api_key": API_KEY,
            "safe_search": SAFE_SEARCH,
            "extras": EXTRAS,
            "format": DATA_FORMAT,
            "nojsoncallback": NO_JSON_CALLBACK
        ]
        
        let searchText = getRandomPhotoIndex()
        print("Random Text: ", searchText)
        methodArguments["text"] = searchText
        
        FlickrClient.sharedInstance().getImageFromFlickrBySearch(methodArguments) {(success, photos, errorString) in
            if success {
                print("photos: ", photos)
                let imageURL = FlickrClient.sharedInstance().getImageURL(photos!)
                if let imageData = NSData(contentsOfURL: imageURL!) {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.imageView.image = UIImage(data: imageData)
                    })
                }
            } else {
                print("Error: ", errorString)
            }
        }
    }
    
    func getRandomPhotoIndex()-> String {
        let cityStates = ["Hyderabad, India", "Norfolk, VA", "Syracuse, NY", "Banglore, India"]
        let randomPhotoIndex = Int(arc4random_uniform(UInt32(cityStates.count)))
        return cityStates[randomPhotoIndex]
    }
}

