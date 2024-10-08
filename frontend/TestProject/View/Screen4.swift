import SwiftUI

struct Screen4: View {
    @Environment(\.presentationMode) var presentationMode // For dismissing current screen
    let serverResponse: String // The part of the second API response shown on Screen3
    
    // Temporarily provided additional info
    let additionalInfo: String = """
    Based on your responses, it seems that you are not currently showing signs of Alzheimer's disease. However, since you mentioned a family history of Alzheimer's, it's important to stay vigilant about any changes in your cognitive health over time.

    I recommend maintaining a healthy lifestyle, which includes regular mental and physical activities, social engagement, and routine check-ups with your healthcare provider. If you ever notice any changes in your memory or cognitive abilities, consider discussing them with a medical professional.

    If you have any further questions or concerns, feel free to ask!
    """

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.green.opacity(0.7)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack {
                // Custom top bar with back button
                HStack {
                    Button(action: {
                        // Navigate back to Screen1
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .padding()
                    }

                    Spacer()

                    Text("Test Results")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .padding()

                    Spacer()

                    // Placeholder for symmetry, can be replaced with menu or additional action
                    Button(action: {
                        // Placeholder action
                    }) {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.white)
                            .padding()
                    }
                }

                // Display the server response and additional info
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Results:")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.bottom, 10)

                        // Display the part of the response from Screen3
                        Text(serverResponse)
                            .font(.body)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        // Display the additional info
                        Text(additionalInfo)
                            .font(.body)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                }

                Spacer()

                // Back to Home button
                Button(action: {
                    // Navigate back to Screen1
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Back to Home")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.8))
                        .cornerRadius(15)
                        .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true) // Hide the default back button
        .toolbar(.hidden, for: .navigationBar) // Hide the navigation bar
    }
}
