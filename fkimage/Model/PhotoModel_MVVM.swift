//
//  PhotoModel_MVVM.swift
//  fkimage
//
//  Created by robinson on 2018/2/23.
//  Copyright © 2018年 binsonchang. All rights reserved.
//

import Foundation

struct FlickrJson:Codable {
    let photos: Photos
    let stat: String
    
}

struct Photos:Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: String
    let photo: [Photo]
}

struct Photo:Codable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let ispublic: Int
    let isfriend: Int
    let isfamily: Int
}
