//
//  TestDataListViewModel.swift
//  SwiftWithCombine
//
//  Created by Gaurav Sharma on 24/03/24.
//

import Foundation
import SwiftUI
import Combine


class TestDataListViewModel: ObservableObject {
    @Published var dataList =  [UserDataModel]()
    
    // This should be injected via dependency
    let netWorkManager = NetworkManager()
    //private var subscription = Set<AnyCancellable>()
    
    //var subscription: <AnyCancellable>?
    
    func getDataFromNetworkManager(completion: @escaping (_ isCompleted: Bool) -> Void)  {
        netWorkManager.fetchDataFromTypicalNetworkManager {[weak self] (result: Result<[UserDataModel], Error>) in
            switch result {
            case .success(let userModel):
                guard let _self = self  else { return }
                _self.dataList = userModel
                completion(true)
            case .failure(let error):
                print("The error received is == \(error.localizedDescription)")
            }
        }
    }

    func fetchDataList()  {
       let _ =  netWorkManager.fetchDataList()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                switch value {
                case .failure:
                    self?.dataList = []
                case .finished:
                    break
                }
            } receiveValue: { [weak self] dataResponse in
                self?.dataList = dataResponse
            }
           // .store(in: &subscription)
     //   subscription?.cancel()
    }
}
