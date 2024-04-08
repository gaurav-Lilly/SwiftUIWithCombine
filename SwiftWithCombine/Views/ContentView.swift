//
//  ContentView.swift
//  SwiftWithCombine
//
//  Created by Gaurav Sharma on 23/03/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isUserLogged") var isUserLogged: Bool = false
    var body: some View {
        TestDataView()
    }
    
//    func getRootView() -> some View {
//        let testDataViewModel = TestDataListViewModel()
//        return TestDataView(model: testDataViewModel)
//    }
}

#Preview {
    ContentView()
}
