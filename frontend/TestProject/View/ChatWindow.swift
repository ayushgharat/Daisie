//
//  ChatWindow.swift
//  TestProject
//
//  Created by Ayush Gharat on 9/29/24.
//


import SwiftUI

struct ChatWindow: View {
    @Binding var messages: [ChatMessage]
    @Binding var isMessageVisible: [Bool]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(Array(messages.enumerated()), id: \.element.id) { index, message in
                HStack {
                    if message.isUser {
                        Spacer()
                        Text(message.text)
                            .padding()
                            .background(Color.blue.opacity(0.9))
                            .cornerRadius(20)
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .opacity(isMessageVisible[safe: index] ?? false ? 1 : 0)
                            .offset(y: isMessageVisible[safe: index] ?? false ? 0 : 50)
                            .animation(.easeIn(duration: 0.5).delay(Double(index) * 0.1), value: isMessageVisible[safe: index] ?? false)
                            .onAppear {
                                if isMessageVisible.indices.contains(index) {
                                    isMessageVisible[index] = true
                                }
                            }
                    } else {
                        Text(message.text)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(20)
                            .foregroundColor(.black)
                            .font(.system(size: 18))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .opacity(isMessageVisible[safe: index] ?? false ? 1 : 0)
                            .offset(y: isMessageVisible[safe: index] ?? false ? 0 : 50)
                            .animation(.easeIn(duration: 0.5).delay(Double(index) * 0.1), value: isMessageVisible[safe: index] ?? false)
                            .onAppear {
                                if isMessageVisible.indices.contains(index) {
                                    isMessageVisible[index] = true
                                }
                            }
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .background(Color.clear)
        .cornerRadius(12)
        .padding(.bottom)
        .shadow(radius: 5)
    }
}