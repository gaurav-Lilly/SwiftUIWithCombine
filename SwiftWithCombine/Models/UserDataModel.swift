//
//  UserDataModel.swift
//  SwiftWithCombine
//
//  Created by Gaurav Sharma on 24/03/24.
//

import Foundation


struct UserDataModel: Codable, Identifiable, Equatable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
