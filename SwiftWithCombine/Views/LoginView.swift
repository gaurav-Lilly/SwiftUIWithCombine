//
//  LoginView.swift
//  SwiftWithCombine
//
//  Created by Gaurav Sharma on 23/03/24.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    @State var userNameText: String
    @State var passswordText: String
    
    init(userNameText: String = "", passswordText: String = "") {
        self.userNameText = userNameText
        self.passswordText = passswordText
    }
    
    var body: some View {
        ZStack {
            Color("ColorBlue")
                .edgesIgnoringSafeArea(.all)
           // CircleGroupView(ShapeColor: .white, ShapeOpacity: 0.2)
            
            VStack {
                
                VStack {
                    VStack(spacing: 20) {
                        Text("Combine.")
                            .font(.system(size: 60))
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                        Text("Power of reactive programming")
                        .font(.title3)
                        .fontWeight(.light)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .multilineTextAlignment(.center)
                    }
                }
                
                Spacer()
                VStack(spacing: 20) {
                    TextField("", text: $userNameText, prompt: Text("Phone, email or username").foregroundColor(.white))
                        .frame(width: 300, height: 60, alignment: .center)
                        .background(Color.clear)
                        .foregroundColor(.white)
                        .border(Color.white)
                    TextField("", text: $passswordText, prompt: Text("password").foregroundColor(.white))
                        .frame(width: 300, height: 60, alignment: .center)
                        .foregroundColor(.white)
                        .background(Color.clear)
                        .border(Color.white)
                }
                
                Spacer()
                
                SwipeButton(buttonText: "Login") {
                    if !(userNameText.isEmpty && passswordText.isEmpty) {
                       dismiss()
                    }
                }
            }
            .padding(40)
        }
    }
}

#Preview {
    LoginView(userNameText: "name", passswordText: "password")
}
