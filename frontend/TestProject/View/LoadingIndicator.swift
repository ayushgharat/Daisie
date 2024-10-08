//
//  LoadingIndicator.swift
//  TestProject
//
//  Created by Ayush Gharat on 9/29/24.
//


import SwiftUI

struct LoadingIndicator: View {
    var body: some View {
        VStack {
            Text("Loading...")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
        }
    }
}