//
//  FlickrCollectionViewController.swift
//  RandomFlickerImages
//
//  Created by Rahath cherukuri on 3/5/16.
//  Copyright © 2016 Rahath cherukuri. All rights reserved.
//

import UIKit

class FlickrCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var flickrCollectionView: UICollectionView!
    
    override func viewDidLoad() {
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
//                print("photos: ", photos)
                FlickrClient.sharedInstance().savePhotoData(photos!)
                dispatch_async(dispatch_get_main_queue(), {
                    self.flickrCollectionView.reloadData()
                })
            } else {
                print("Error: ", errorString)
            }
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        flickrCollectionView.reloadData()
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoData.photoArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FlickrCollectionViewCell", forIndexPath: indexPath) as! FlickrCollectionViewCell
        
        let photo = photoData.photoArray[indexPath.row]
        
        let imageUrlString = photo.url
        let imageURL = NSURL(string: imageUrlString)
        if let imageData = NSData(contentsOfURL: imageURL!) {
            dispatch_async(dispatch_get_main_queue(), {
                cell.imageView.image = UIImage(data: imageData)
            })
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
//        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
//        detailController.selectedIndex = indexPath.row
//        navigationController!.pushViewController(detailController, animated: true)
    }
    
    func getRandomPhotoIndex()-> String {
        let cityStates = ["Hyderabad, India", "Norfolk, VA", "Syracuse, NY", "Banglore, India"]
        let randomPhotoIndex = Int(arc4random_uniform(UInt32(cityStates.count)))
        return cityStates[randomPhotoIndex]
    }

}
