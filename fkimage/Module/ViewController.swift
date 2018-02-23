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


//let key = "6c33e207751d51ccca4116b40d8b32be"
//let privateKey = "86fb7c8eb3b4c13b"
//let keyWord = "lebronjames"


class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var photoMadager: PhotoListModel?
    
    //mvvm test
    lazy var viewModel: ViewModel = {
        return ViewModel()
    }()
    
//    let searchApi = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(key)&format=json&text=\(keyWord)"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("[VC] didload")
        
        //register cell
        self.registerCustomCell()
        
        
        //mvvm test
        self.initVM()
        
        
//        let url = URL(string: searchApi)
//        self.searchImageAPI(url: url!)
        
    }
    
    //mvvm test
    func initVM() {
        viewModel.showAlertClosure = { [weak self]() in
            if let msg = self?.viewModel.alertMessage {
                self?.showAlert(message: msg)
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self]() in
            DispatchQueue.main.async {
                if (self?.viewModel.isLoading)! {
                    self?.activityIndicator.startAnimating()
                    self?.mainCollectionView.alpha = 0.0
                }else{
                    self?.activityIndicator.stopAnimating()
                    self?.mainCollectionView.alpha = 1.0
                }
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self]() in
            DispatchQueue.main.async {
                self?.mainCollectionView.reloadData()
            }
        }
        
        self.viewModel.initFetch()
    }
    
    
    func showAlert(message:String) {
        let alertVC = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
    private func registerCustomCell() {
        self.mainCollectionView.register(UINib.init(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
    }
    
//    private func searchImageAPI(url:URL) {
//        
//        Alamofire.request(url, method: .post, parameters: nil, encoding: URLEncoding.default).responseString { [unowned self](response) in
//            
//            //頭尾字串要去除,才能正常進行字串轉dictionary
//            var result:String? = response.result.value
//            result = result?.replacingOccurrences(of: "jsonFlickrApi(", with: "")
//            result = result?.replacingOccurrences(of: "})", with: "}")
//            
//            if let responseDic:Dictionary<String,Any> = result?.stringToDictionary() {
////                print("trans Dic success!!")
//                let photoList = PhotoListModel()
//                photoList.setPhotoList(response: responseDic)
//                
//                self.photoMadager = photoList
//                
//                self.mainCollectionView.reloadData()
//            }
//            
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension UICollectionViewDelegate {
    
}


/// cellection datasource
extension ViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        var itemNums = 0
//
//        if (self.photoMadager != nil) && (self.photoMadager?.photos != nil) {
//            itemNums = (self.photoMadager?.photos?.photo?.count)!
//        }
//
//        return itemNums
        return self.viewModel.numberOfCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
//        let photo:PhotoModel = self.photoMadager?.photos?.photo![indexPath.row] as! PhotoModel
//
//        //exam:https://farm5.staticflickr.com/4725/27414478659_68e8ae855b.jpg
//        let imageUrlStr = String(format: "https://farm%d.staticflickr.com/%@/%@_%@.jpg", photo.farm!, photo.server!, photo.id!, photo.secret!)
//
//
//        let sd_manager = SDWebImageManager.shared()
//        sd_manager.imageDownloader?.downloadTimeout = 5
//        sd_manager.loadImage(with: URL(string: imageUrlStr), options: SDWebImageOptions.lowPriority, progress: { (receivedSize, expectedSize, targetURL) in
//            //process tracking
//            //set noimage image
//            DispatchQueue.main.async {
//                cell.photoImgV.image = UIImage(named: "if_18.Pictures-Day_290132")
//                cell.title.text = ""
//            }
//        }) { (image, data, error, cacheType, finished, imageURL) in
//            //download done
//            if image != nil {
//                cell.photoImgV.image = image
//                cell.title.text = photo.title!
//            }
//        }
        let cellVM = self.viewModel.getCellViewModel(at: indexPath)
        
        let sd_manager = SDWebImageManager.shared()
        sd_manager.imageDownloader?.downloadTimeout = 5
        sd_manager.loadImage(with: URL(string: cellVM.imageUrl), options: SDWebImageOptions.lowPriority, progress: { (receivedSize, expectedSize, targetURL) in
            //process tracking
            //set noimage image
            DispatchQueue.main.async {
                cell.photoImgV.image = UIImage(named: "if_18.Pictures-Day_290132")
                cell.title.text = ""
            }
        }) { (image, data, error, cacheType, finished, imageURL) in
            //download done
            if image != nil {
                cell.photoImgV.image = image
                cell.title.text = cellVM.title
            }
        }
        
        
        return cell
    }
    
    
}



/// cellection delegate
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

