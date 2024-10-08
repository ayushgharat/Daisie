//
//  MessageInputView.swift
//  TestProject
//
//  Created by Ayush Gharat on 9/29/24.
//


import SwiftUI

struct MessageInputView: View {
    @Binding var userMessage: String
    var sendMessage: () -> Void
    
    var body: some View {
        HStack {
            TextField("Enter message...", text: $userMessage)
                .padding()
                .background(Color.white)
                .cornerRadius(30)
                .font(.system(size: 20)) // Increase font size
                .padding(.leading)
                .frame(height: 100) // Make the input box larger
            
            Button(action: sendMessage) {
                Image(systemName: "paperplane.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.purple)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
            .offset(x: -50) // Overlay the button on the right side of the input box
        }
        .padding(.bottom)
    }
}