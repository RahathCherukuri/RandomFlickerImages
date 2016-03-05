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
                guard let photos = JSONResult["photos"] as? [String: AnyObject] else {
                    print("Cannot find keys 'photos'")
                    completionHandler(success: false, results: nil, errorString: "Cannot find keys 'photos'")
                    return
                }
                completionHandler(success: true, results: photos, errorString: nil)
            }
        }
    }
    
    func getImageURL(photos: [String: AnyObject]) -> NSURL? {
        let totalPhotosCount = (photos["total"] as? NSString)?.integerValue
        if (totalPhotosCount > 0) {
        
            /* GUARD: Is the "photo" key in photosDictionary? */
            guard let photosArray = photos["photo"] as? [[String: AnyObject]] where photosArray.count > 0 else {
                print("Cannot find key 'photo' in \(photos)")
                return nil
            }
            
            let randomPhotoIndex = Int(arc4random_uniform(UInt32(photosArray.count)))
            let photoDictionary = photosArray[randomPhotoIndex] as [String: AnyObject]
            let photoTitle = photoDictionary["title"] as? String /* non-fatal */
            
            /* GUARD: Does our photo have a key for 'url_m'? */
            guard let imageUrlString = photoDictionary["url_m"] as? String else {
                print("Cannot find key 'url_m' in \(photoDictionary)")
                return nil
            }
            let imageURL = NSURL(string: imageUrlString)
            return imageURL
        } else {
            return nil
        }
    }
    
    
}
