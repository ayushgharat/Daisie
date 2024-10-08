//
//  CustomNavigationBar.swift
//  TestProject
//
//  Created by Ayush Gharat on 9/29/24.
//


import SwiftUI

struct CustomNavigationBar: View {
    var body: some View {
        HStack {
            Button(action: {
                // Action to go back
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
                    .padding()
            }
            
            Spacer()
            
            Text("Chat with Bot")
                .font(.title2.bold())
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: {
                // Action for menu or settings
            }) {
                Image(systemName: "ellipsis")
                    .foregroundColor(.white)
                    .padding()
            }
        }
        .padding(.top)
    }
}