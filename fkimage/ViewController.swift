//
//  ViewController.swift
//  fkimage
//
//  Created by binsonchang on 2017/12/21.
//  Copyright © 2017年 binsonchang. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

let key = "6c33e207751d51ccca4116b40d8b32be"
let privateKey = "86fb7c8eb3b4c13b"
let keyWord = "cat"


class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    var photoMadager: PhotoListModel?
    
    
    let searchApi = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(key)&format=json&text=\(keyWord)"
//    let searchApi = "https://api.flickr.com/services/rest/?"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.registerCustomCell()
        
        let url = URL(string: searchApi)
        
        self.searchImageAPI(url: url!)
    }
    
    private func registerCustomCell() {
        self.mainCollectionView.register(UINib.init(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
    }
    
    private func searchImageAPI(url:URL) {
//        let para:Parameters = ["method":"flickr.photos.search","api_key":key, "text":keyWord]
        
        Alamofire.request(url, method: .post, parameters: nil, encoding: URLEncoding.default).responseString { [unowned self](response) in
            //頭尾字串要去除,才能正常進行字串轉dictionary
            var result:String? = response.result.value
            result = result?.replacingOccurrences(of: "jsonFlickrApi(", with: "")
            result = result?.replacingOccurrences(of: "})", with: "}")
            
            if let responseDic:Dictionary<String,Any> = result?.stringToDictionary() {
//                print("trans Dic success!!")
                let photoList = PhotoListModel()
                photoList.setPhotoList(response: responseDic)
                
                self.photoMadager = photoList
                
                self.mainCollectionView.reloadData()
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension UICollectionViewDelegate {
    
}

extension ViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var itemNums = 0
        
        if (self.photoMadager != nil) && (self.photoMadager?.photos != nil) {
            itemNums = (self.photoMadager?.photos?.photo?.count)!
        }
        
        return itemNums
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        let photo:PhotoModel = self.photoMadager?.photos?.photo![indexPath.row] as! PhotoModel
        
        //exam:https://farm5.staticflickr.com/4725/27414478659_68e8ae855b.jpg
        let imageUrlStr = String(format: "https://farm%d.staticflickr.com/%@/%@_%@.jpg", photo.farm!, photo.server!, photo.id!, photo.secret!)
        
        cell.photoImgV.sd_setImage(with: URL(string: imageUrlStr), completed: nil)
        
        
        return cell
    }
    
    
}

extension ViewController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.size.width / 2 - 1
        let height = UIScreen.main.bounds.size.width / 3 - 3
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.init(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}



extension String {
    func stringToDictionary() -> [String: Any]? {
        
        if let data = self.data(using: String.Encoding.utf8) {
            do{
                return try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any>
            }catch{
                print("stringToDictionary fail")
            }
        }
        return nil
        
    }
}

