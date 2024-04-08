//
//  SwipeButton.swift
//  Restart
//
//  Created by Gaurav Sharma on 23/03/24.
//

import SwiftUI

struct SwipeButton: View {
    @State private var buttonWidth: Double
    @State private var buttonOffset: CGFloat
    var buttonText: String
    var action: () -> Void
    
    init(buttonWidth: Double = (UIScreen.main.bounds.width - 80), buttonOffset: CGFloat = 0, buttonText: String, action: @escaping () -> Void) {
        self.buttonWidth = buttonWidth
        self.buttonOffset = buttonOffset
        self.buttonText = buttonText
        self.action = action
    }
    
    
    var body: some View {
        ZStack {
            Capsule()
                .fill(.white.opacity(0.2))
            Capsule()
                .fill(.white.opacity(0.2))
                .padding(8)
            
            Text(buttonText)
                .font(.system(.title3, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .offset(x: 20)
            
            HStack {
                Capsule()
                    .fill(Color("ColorRed"))
                    .frame(width: buttonOffset + 80)
                Spacer()
            }
            HStack{
                ZStack {
                    Circle()
                        .fill(Color("ColorRed"))
                    Circle()
                        .fill(.black.opacity(0.15))
                        .padding(8)
                    Image(systemName: "chevron.right.2")
                        .font(.system(size: 24, weight: .bold))
                }
                .foregroundColor(.white)
                .frame(width: 80, height: 80, alignment: .center)
                .offset(x: buttonOffset)
                .gesture(
                    DragGesture()
                        .onChanged({ gesture in
                            if gesture.translation.width > 0 && buttonOffset <= buttonWidth - 80 {
                                buttonOffset = gesture.translation.width
                            }
                        })
                        .onEnded({ _ in
                            withAnimation {
                                if buttonOffset > buttonWidth / 2 {
                                    buttonOffset = buttonWidth - 80
                                    action()
                                    buttonOffset = 0
                                } else {
                                    buttonOffset = 0
                                }
                            }
                        })
                ) // : Gesture
                Spacer()
            }
        }
        .frame(width:buttonWidth, height: 80, alignment: .center)
        .padding()
    }
}

#Preview {
    ZStack {
        Color("ColorBlue")
            .ignoresSafeArea(.all)
        SwipeButton(buttonText: "Hello") {
            print("hello")
        }
    }
}
