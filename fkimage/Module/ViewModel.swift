//
//  ViewModel.swift
//  fkimage
//
//  Created by robinson on 2018/2/23.
//  Copyright © 2018年 binsonchang. All rights reserved.
//

import Foundation

class ViewModel {
    let apiService: APIServiceProtocol
    
    private var photos:[Photo] = [Photo]()
    
    var cellModel:[CellViewModel] = [CellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    var numberOfCell: Int {
        return self.cellModel.count
    }
    
    
    var isLoading:Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    
    
    init(apiService:APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func initFetch() {
        self.isLoading = true
        self.apiService.fetchImage(success: { (success, photos) in
            self.isLoading = false
            self.processFetchedPhoto(photos: photos)
        }) { (error) in
            self.isLoading = false
        }
    }
    
    private func processFetchedPhoto(photos:[Photo]) {
        self.photos = photos
        var cellViewModels:[CellViewModel] = [CellViewModel]()
        for photo in photos {
            let cellViewModel = self.createCellViewModel(photo: photo)
            cellViewModels.append(cellViewModel)
        }
        self.cellModel = cellViewModels
    }
    
    func createCellViewModel(photo:Photo) -> CellViewModel {
        let imageUrl = String(format: "https://farm%d.staticflickr.com/%@/%@_%@.jpg", photo.farm, photo.server, photo.id, photo.secret)
        return CellViewModel(title: photo.title, imageUrl: imageUrl)
    }
    
    func getCellViewModel(at indexPath:IndexPath) -> CellViewModel {
        return self.cellModel[indexPath.row]
    }
}
