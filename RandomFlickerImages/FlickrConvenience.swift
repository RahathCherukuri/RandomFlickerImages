//
//  FlickrConvenience.swift
//  RandomFlickerImages
//
//  Created by Rahath cherukuri on 3/5/16.
//  Copyright © 2016 Rahath cherukuri. All rights reserved.
//

import Foundation
import UIKit

extension FlickrClient {
    
    func getImageFromFlickrBySearch(parameters: [String: AnyObject],completionHandler: (success: Bool, results: [String: AnyObject]?, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let method: String = METHOD_NAME
        /* 2. Make the request */
        taskForGETMethod(method, parameters: parameters) {(JSONResult, error) in
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print("error: ", error)
                completionHandler(success: false, results: nil, errorString: "Please check your internet connection and try again.")
            } else {
                /* GUARD: Is "photos" key in our result? */
                guard let photos = JSONResult[FlickrClient.JSONResponseKeys.Photos] as? [String: AnyObject] else {
                    print("Cannot find keys 'photos'")
                    completionHandler(success: false, results: nil, errorString: "Cannot find keys 'photos'")
                    return
                }
                completionHandler(success: true, results: photos, errorString: nil)
            }
        }
    }
    
    func getImageURL(photos: [String: AnyObject]) -> NSURL? {
        let totalPhotosCount = (photos[FlickrClient.JSONResponseKeys.Totalphotos] as? NSString)?.integerValue
        if (totalPhotosCount > 0) {
        
            /* GUARD: Is the "photo" key in photosDictionary? */
            guard let photosArray = photos[FlickrClient.JSONResponseKeys.Photo] as? [[String: AnyObject]] where photosArray.count > 0 else {
                print("Cannot find key 'photo' in \(photos)")
                return nil
            }
            photoData.photoArray.removeAll()
            for photoDictionary in photosArray {
                /* GUARD: Does our photo have a key for 'url_m'? */
                guard let imageUrlString = photoDictionary[FlickrClient.JSONResponseKeys.Url] as? String,
                    let photoTitle = photoDictionary[FlickrClient.JSONResponseKeys.Title] as? String
                else {
                    print("Cannot find key 'url_m' in \(photoDictionary)")
                    return nil
                }
                photoData(title: photoTitle,url: imageUrlString)
            }
            print("No of elements in photoData.photoArray.count are: ", photoData.photoArray.count)
            if photoData.photoArray.count > 0 {
                let randomPhotoIndex = Int(arc4random_uniform(UInt32(photoData.photoArray.count)))
                let imageUrlString = photoData.photoArray[randomPhotoIndex].url
                let imageURL = NSURL(string: imageUrlString)
                    return imageURL
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

}


            
            
//            let randomPhotoIndex = Int(arc4random_uniform(UInt32(photosArray.count)))
//            let photoDictionary = photosArray[randomPhotoIndex] as [String: AnyObject]
//            
//            /* GUARD: Does our photo have a key for 'url_m'? */
//            guard let imageUrlString = photoDictionary[FlickrClient.JSONResponseKeys.Url] as? String,
//                let photoTitle = photoDictionary[FlickrClient.JSONResponseKeys.Title] as? String
//            else {
//                print("Cannot find key 'url_m' in \(photoDictionary)")
//                return nil
//            }
//            photoData(title: photoTitle,url: imageUrlString)
//            
//            
//            
//            
//            let imageURL = NSURL(string: imageUrlString)
//            return imageURL
//        } else {
//            return nil
//        }
//            return nil
//    }


