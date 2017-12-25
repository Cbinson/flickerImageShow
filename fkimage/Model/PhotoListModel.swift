//
//  PhotoListModel.swift
//  fkimage
//
//  Created by binsonchang on 2017/12/22.
//  Copyright © 2017年 binsonchang. All rights reserved.
//

import UIKit

class PhotoListModel: NSObject {

    var stat: String?
    var photos: PhotosModel?//Dictionary<String,Any>?
    
    
    func setPhotoList(response:Any) {
        if let responseDic:Dictionary<String,Any> = response as? Dictionary<String, Any> {
            self.stat = responseDic["stat"] as? String
            
            if let photosDic = responseDic["photos"] {
//                print("photos:\(photosDic)")
                let photos = PhotosModel()
                photos.setPhotosModel(photos:photosDic)
                self.photos = photos
            }
        }
    }
}
