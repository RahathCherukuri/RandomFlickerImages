//
//  FlickrConvenience.swift
//  RandomFlickerImages
//
//  Created by Rahath cherukuri on 3/5/16.
//  Copyright © 2016 Rahath cherukuri. All rights reserved.
//

import Foundation
import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


extension FlickrClient {
    
    func getImageFromFlickrBySearch(_ parameters: [String: AnyObject],completionHandler: @escaping (_ success: Bool, _ results: [String: AnyObject]?, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let method: String = METHOD_NAME
        /* 2. Make the request */
        _ = taskForGETMethod(method, parameters: parameters) {(JSONResult, error) in
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print("error: ", error)
                completionHandler(false, nil, "Please check your internet connection and try again.")
            } else {
                /* GUARD: Is "photos" key in our result? */
                guard let photos = JSONResult?[FlickrClient.JSONResponseKeys.Photos] as? [String: AnyObject] else {
                    completionHandler(false, nil, "Cannot find keys 'photos'")
                    return
                }
                completionHandler(true, photos, nil)
            }
        }
    }
    
    func savePhotoData(_ photos: [String: AnyObject], index: Int) {
        let totalPhotosCount = (photos[FlickrClient.JSONResponseKeys.Totalphotos] as? NSString)?.integerValue
        
        if (totalPhotosCount > 0) {
            
            /* GUARD: Is the "photo" key in photosDictionary? */
            guard let photosArray = photos[FlickrClient.JSONResponseKeys.Photo] as? [[String: AnyObject]], photosArray.count > 0 else {
                print("Cannot find key 'photo' in \(photos)")
                return
            }
            
            if index == 0 {
                Data.DataCollectionViewOne.removeAll()
            } else {
                Data.DataCollectionViewTwo.removeAll()
            }
            
            for photoDictionary in photosArray {
                /* GUARD: Does our photo have a key for 'url_m'? */
                guard let imageUrlString = photoDictionary[FlickrClient.JSONResponseKeys.Url] as? String,
                    let photoTitle = photoDictionary[FlickrClient.JSONResponseKeys.Title] as? String
                    else {
                        print("Cannot find key 'url_m' in \(photoDictionary)")
                        return
                }
                _ = photoData(title: photoTitle,url: imageUrlString)
            }
            if index == 0 {
                Data.DataCollectionViewOne = photoData.photoArray
            } else {
                Data.DataCollectionViewTwo = photoData.photoArray
            }
            
            photoData.photoArray.removeAll()
        }
    }

}



