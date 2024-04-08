//
//  TestDataView.swift
//  SwiftWithCombine
//
//  Created by Gaurav Sharma on 24/03/24.
//

import SwiftUI
import Combine

struct TestDataView: View {
    @AppStorage("isUserLogged") var isUserLogged: Bool = false
    @State private var showingSheet = false
    
    // Model can be infused as Dependency as well.
    @StateObject private var model = TestDataListViewModel()
    @State var isLoadingData = true
    
    var cancellable: AnyCancellable?
    
    var subscription : AnyCancellable?
    
    var body: some View {
        ZStack {
            Color("ColorBlue")
                .edgesIgnoringSafeArea(.all)
            VStack {
                if isLoadingData {
                    ProgressView("Loading Data...")
                        .font(.title3)
                }
                List(model.dataList) { data in
                    Text(data.title)
                        .font(.title2)
                        .fontWeight(.light)
                        .foregroundStyle(.black)
                }
                .scrollContentBackground(.hidden)
                .onChange(of: model.dataList) {
                    isLoadingData = false
                }
            }
            .fullScreenCover(isPresented: $showingSheet, onDismiss: {
                // 1) Typical way to get data
                    
                /*
                    model.getDataFromNetworkManager { isCompleted in
                        if isCompleted {
                        isLoadingData = false
                        }
                    }
                */
                    
                
                // 2) Combine at Work
                       // self.getCombineData()
                
                // 3) Make a combine Call to fetch data
                model.fetchDataList()
            }, content: {
                LoginView()
            })
            .onAppear(perform: {
                if !isUserLogged {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                        showingSheet.toggle()
                    })
                }
            })
        }
    }
    
    func getCombineData() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        let dataPublisher = URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .map { $0.data }
            .decode(type: [UserDataModel].self, decoder: JSONDecoder())
        DispatchQueue.main.async {
            let _ = dataPublisher
                .sink { completionHandler in
                    print(completionHandler)
                } receiveValue: { dataArray in
                    print(dataArray)
                }
        }
    }
}

#Preview {
    TestDataView()
}
