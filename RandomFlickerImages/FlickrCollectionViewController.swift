//
//  FlickrCollectionViewController.swift
//  RandomFlickerImages
//
//  Created by Rahath cherukuri on 3/5/16.
//  Copyright © 2016 Rahath cherukuri. All rights reserved.
//

import UIKit

class FlickrCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var methodArguments = [
        "method": METHOD_NAME,
        "api_key": API_KEY,
        "safe_search": SAFE_SEARCH,
        "extras": EXTRAS,
        "format": DATA_FORMAT,
        "nojsoncallback": NO_JSON_CALLBACK
    ]
    
    @IBOutlet weak var flickrCollectionViewOne: UICollectionView!
    
    @IBOutlet weak var flickrCollectionViewTwo: UICollectionView!
    
    override func viewDidLoad() {
        setFirstCollectionView()
        setSecondCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setFirstCollectionView() {
        
        let searchText = "NewYork, NY"
        print("Random Text: ", searchText)
        methodArguments["text"] = searchText
        
        FlickrClient.sharedInstance().getImageFromFlickrBySearch(methodArguments as [String : AnyObject]) {(success, photos, errorString) in
            if success {
                FlickrClient.sharedInstance().savePhotoData(photos!, index: 0)
                DispatchQueue.main.async(execute: {
                    self.flickrCollectionViewOne.reloadData()
                })
            } else {
                print("Error: ", errorString ?? "")
            }
        }
    }
    
    func setSecondCollectionView() {
        let searchText = "yosemite national park, california"
        print("Random Text: ", searchText)
        methodArguments["text"] = searchText
        
        FlickrClient.sharedInstance().getImageFromFlickrBySearch(methodArguments as [String : AnyObject]) {(success, photos, errorString) in
            if success {
                FlickrClient.sharedInstance().savePhotoData(photos!,index: 1)
                DispatchQueue.main.async(execute: {
                    self.flickrCollectionViewTwo.reloadData()
                })
            } else {
                print("Error: ", errorString ?? "")
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let tag = collectionView.tag
        if tag == 0 {
            return Data.DataCollectionViewOne.count
        } else {
            return Data.DataCollectionViewTwo.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tag = collectionView.tag
        
        if tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlickrCollectionViewCellOne", for: indexPath) as! FlickrCollectionViewCell
            
            if Data.DataCollectionViewOne.count > 0 {
                let photo = Data.DataCollectionViewOne[indexPath.row]
                
                let imageUrlString = photo.url
                let imageURL = URL(string: imageUrlString)
                if let imageData = try? Foundation.Data(contentsOf: imageURL!) {
                    DispatchQueue.main.async(execute: {
                        cell.imageViewOne.image = UIImage(data: imageData)
                    })
                }
                return cell
            } else {
                return cell
            }
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlickrCollectionViewCellTwo", for: indexPath) as! FlickrCollectionViewCell
            
            if Data.DataCollectionViewTwo.count > 0 {
                let photo = Data.DataCollectionViewTwo[indexPath.row]
                
                let imageUrlString = photo.url
                let imageURL = URL(string: imageUrlString)
                if let imageData = try? Foundation.Data(contentsOf: imageURL!) {
                    DispatchQueue.main.async(execute: {
                        cell.imageViewTwo.image = UIImage(data: imageData)
                    })
                }
                return cell
            } else {
                return cell
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
//        detailController.selectedIndex = indexPath.row
//        navigationController!.pushViewController(detailController, animated: true)
    }
    
    func getRandomPhotoIndex()-> String {
        let cityStates = ["Hyderabad, India", "Norfolk, VA", "Syracuse, NY", "Banglore, India", "Chennai, India", "Rochester, NY", "NewYork, NY"]
        let randomPhotoIndex = Int(arc4random_uniform(UInt32(cityStates.count)))
        return cityStates[randomPhotoIndex]
    }

}
