//
//  PhotosModel.swift
//  fkimage
//
//  Created by binsonchang on 2017/12/22.
//  Copyright © 2017年 binsonchang. All rights reserved.
//

import UIKit

class PhotosModel: NSObject {
    var page: Int?
    var pages: Int?
    var perpage: Int?
    var photo: Array<Any>?
    var total: Int?
    
    
    func setPhotosModel(photos:Any) {
        if let photosDic = photos as? Dictionary<String, Any> {
            self.page = photosDic["page"] as? Int
            self.pages = photosDic["pages"] as? Int
            self.perpage = photosDic["perpage"] as? Int
            
            if let photoArry = photosDic["photo"] {
                let tmpArry = NSMutableArray()
                
                for photoDic in photoArry as! Array<Any> {
                    let photo = PhotoModel()
                    photo.setPhotoModel(photo: photoDic)
                    tmpArry.add(photo)
                }
                self.photo = tmpArry as? Array<Any>
            }
            
            
            self.total = photosDic["total"] as? Int
        }
    }
}
