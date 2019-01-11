//
//  VideoThumbnailCache.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 1/11/19.
//  Copyright © 2019 Majd Ajaj. All rights reserved.
//

import Foundation
import AVFoundation

struct VideoThumbnailCache{
    
    static let imageCache = NSCache<AnyObject, AnyObject>()
    
    static func getThumbnailImage(forUrl url: URL) -> UIImage{
        if let data = UserDefaults.standard.data(forKey: "Video/"+url.absoluteString), let image = UIImage(data: data) {
            return image
        }
        else{
            let asset: AVAsset = AVAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            let thumbnailImage = try? imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            if thumbnailImage != nil{
                let image = UIImage(cgImage: thumbnailImage!)
                if let data = image.jpegData(compressionQuality: 1){
                    UserDefaults.standard.set(data, forKey: "Video/"+url.absoluteString)
                }
                else if let data = image.pngData(){
                    UserDefaults.standard.set(data, forKey: "Video/"+url.absoluteString)
                }
                return image
            }
        }
        return UIImage()
    }
    
    static func getThumbnailImage(forUrl url: URL, completionHandler: @escaping (UIImage?, URL)->()) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = UserDefaults.standard.data(forKey: "Video/"+url.absoluteString), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completionHandler(image, url)
                }
            }
            else{
                let asset: AVAsset = AVAsset(url: url)
                let imageGenerator = AVAssetImageGenerator(asset: asset)
                let thumbnailImage = try? imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
                if thumbnailImage != nil{
                    let image = UIImage(cgImage: thumbnailImage!)
                    if let data = image.jpegData(compressionQuality: 1){
                        UserDefaults.standard.set(data, forKey: "Video/"+url.absoluteString)
                    }
                    else if let data = image.pngData(){
                        UserDefaults.standard.set(data, forKey: "Video/"+url.absoluteString)
                    }
                    DispatchQueue.main.async {
                        completionHandler(image, url)
                    }
                }
                else{
                    DispatchQueue.main.async {
                        completionHandler(nil, url)
                    }
                }
            }
        }
    }
}
