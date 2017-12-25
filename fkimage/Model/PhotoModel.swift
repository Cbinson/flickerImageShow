//
//  PhotoModel.swift
//  fkimage
//
//  Created by binsonchang on 2017/12/22.
//  Copyright © 2017年 binsonchang. All rights reserved.
//

import UIKit

class PhotoModel: NSObject {
    var farm: Int?
    var id: String?
    var isfamily: Int?
    var isfriend: Int?
    var ispublic: Int?
    var owner: String?
    var secret: String?
    var server: String?
    var title: String?
    
    func setPhotoModel(photo:Any) {
        if let photoDic = photo as? Dictionary<String,Any> {
            self.farm = photoDic["farm"] as? Int
            self.id = photoDic["id"] as? String
            self.isfamily = photoDic["isfamily"] as? Int
            self.isfriend = photoDic["isfriend"] as? Int
            self.ispublic = photoDic["ispublic"] as? Int
            self.owner = photoDic["owner"] as? String
            self.secret = photoDic["secret"] as? String
            self.server = photoDic["server"] as? String
            self.title = photoDic["title"] as? String
        }
    }
}
