//
//  Extensions.swift
//  MemphisGardens
//
//  Created by Kareem Dasilva on 2/25/23.
//

import UIKit
let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView{
    func loadImageUsingCacheWithUrlString(urlString: String){
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
            print("is cached")
            self.image = cachedImage
            return
        }
        
        guard let url = NSURL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url as URL, completionHandler: { (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: {
                print("is not cache")
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
            })
        }).resume()
    }
}
