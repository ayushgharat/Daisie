import SwiftUI

struct Screen1: View {
    @State private var navigationPath = [String]()
    @State private var isAnimated = false
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                // Darker gradient background
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.green.opacity(0.8)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack(alignment: .center, spacing: 20) {
                    
                    // Header: "Daisy"
                    Text("Daisy")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 60)
                        .opacity(isAnimated ? 1 : 0)
                        .offset(y: isAnimated ? 0 : 50)
                        .animation(.easeOut(duration: 0.5), value: isAnimated)
                    
                    // Subheading: "Test for early onset of Alzheimer's and Parkinson's"
                    Text("Test for early onset of Alzheimer's and Parkinson's")
                        .font(.title2.weight(.semibold)) // Bolder subheading
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .opacity(isAnimated ? 1 : 0)
                        .offset(y: isAnimated ? 0 : 50)
                        .animation(.easeOut(duration: 0.5).delay(0.2), value: isAnimated)
                    
                    // Description with increased text size
                    Text("""
                    Using handwriting data and a conversational language model, Daisy aims to detect early signs of Alzheimer's and Parkinson's. This simple test gathers your handwriting samples, which are analyzed to detect subtle changes in motor and cognitive functions that could indicate early onset of these conditions.
                    """)
                    .font(.body.weight(.regular)) // Increased font size by 1 unit (from .callout to .body)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .opacity(isAnimated ? 1 : 0)
                    .offset(y: isAnimated ? 0 : 50)
                    .animation(.easeOut(duration: 0.5).delay(0.3), value: isAnimated)
                    
                    Spacer()
                    
                    // Navigation Link to start the test with enhanced button
                    NavigationLink(destination: Screen2()) {
                        Text("Start the test")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .foregroundColor(Color.green)
                            .cornerRadius(15)
                            .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 10)
                    }
                    .padding(.horizontal, 60)
                    .opacity(isAnimated ? 1 : 0)
                    .offset(y: isAnimated ? 0 : 50)
                    .animation(.easeOut(duration: 0.5).delay(0.4), value: isAnimated)
                    
                    // Disclaimer
                    Text("Disclaimer: The results of this app should not be considered a medical diagnosis.")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                        .padding(.horizontal, 30)
                        .opacity(isAnimated ? 1 : 0)
                        .offset(y: isAnimated ? 0 : 50)
                        .animation(.easeOut(duration: 0.5).delay(0.5), value: isAnimated)
                    
                    Spacer()
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                withAnimation {
                    isAnimated = true
                }
            }
        }
    }
}
