//
//  APIService.swift
//  fkimage
//
//  Created by robinson on 2018/2/23.
//  Copyright © 2018年 binsonchang. All rights reserved.
//

import Foundation
import Alamofire

protocol APIServiceProtocol {
    func fetchImage (success:@escaping (_ success:Bool, _ photos:[Photo])->(),fail:@escaping (_ error:String)->())
}

class APIService:APIServiceProtocol {
    let key = "6c33e207751d51ccca4116b40d8b32be"
    let privateKey = "86fb7c8eb3b4c13b"
    let keyWord = "lebronjames"
    var searchApi:String {
        return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(key)&format=json&text=\(keyWord)"
    }
    
    func fetchImage (success:@escaping (_ success:Bool, _ photos:[Photo])->(),fail:@escaping (_ error:String)->()) {
        let url = URL(string: searchApi)
        Alamofire.request(url!, method: .post, parameters: nil, encoding: URLEncoding.default).responseString { (response) in
            //頭尾字串要去除,才能正常進行字串轉dictionary
            var result:String? = response.result.value
            result = result?.replacingOccurrences(of: "jsonFlickrApi(", with: "")
            result = result?.replacingOccurrences(of: "})", with: "}")

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let data:Data = result!.data(using: String.Encoding.utf8)!
            
            let flickerAPI = try! decoder.decode(FlickrJson.self, from: data)
            
            success(true, flickerAPI.photos.photo)
        }
    }
}
