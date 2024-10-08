import SwiftUI

struct Screen3: View {
    let drawingsForQuestions: [DrawingForQuestion] // Accept drawingsForQuestions as input
    @State private var messages: [ChatMessage] = [] // Chat messages
    @State private var userMessage = ""
    @State private var isLoading: Bool = false // Loading state
    @State private var navigateToScreen4 = false // Navigation to Screen4
    @State private var serverResponse: String = "" // Server response from the first API call (model_output_alz)
    @State private var responseAfterFullStop: String = "" // Part of the 2nd API response after the full stop
    @State private var isMessageVisible: [Bool] = [] // Track visibility of each message for animation
    @State private var currentQuestionIndex: Int = 0 // Track the current question index
    @State private var userResponses: [String] = [] // Store user responses

    let questions = [
        "Thank you for your responses. One last question: How do you feel about your ability to manage daily tasks, such as cooking, cleaning, or making decisions? Have you noticed any difficulties?",
        "Thank you for your answer. Do you take any medications regularly, and have you experienced any mood changes recently?",
        "AI: Thank you for your response. Do you engage in any regular mental activities, such as puzzles, reading, or learning new skills?",
        "AI: Thank you for sharing that. Have you noticed any changes in your memory or cognitive abilities, such as forgetting recent events or having trouble concentrating?",
        "Thanks for taking the test and answering my questions. Based on your responses and the model's result indicating no signs of Alzheimer's, it seems you are currently not showing early indicators of the disease. However, it's important to stay vigilant about any changes in your cognitive health over time.\n -If you have any concerns or notice changes in your memory or daily functioning in the future, I recommend consulting a healthcare professional for further evaluation. Additionally, engaging in regular mental activities and maintaining a healthy lifestyle can be beneficial for cognitive health. If you have any more questions or need further assistance, feel free to ask!"
    ] // Array of questions to ask

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.green.opacity(0.7)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack {
                CustomNavigationBar() // Navigation bar component

                ScrollView {
                    ChatWindow(messages: $messages, isMessageVisible: $isMessageVisible) // Chat messages
                }

                MessageInputView(userMessage: $userMessage, sendMessage: sendMessage) // Message input and send button

                if isLoading {
                    LoadingIndicator() // Loading view
                }
            }
            .padding()
            .navigationDestination(isPresented: $navigateToScreen4) {
                Screen4(serverResponse: "") // Navigate to Screen4 with the additional part of the API response
            }
        }
        .toolbar(.hidden, for: .navigationBar) // Hide navigation bar
        .onAppear {
            askNextQuestion() // Ask the first question when the view appears
        }
    }

    // Handle sending a message and moving to the next question
    func sendMessage() {
        let trimmedMessage = userMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedMessage.isEmpty {
            withAnimation {
                messages.append(ChatMessage(text: trimmedMessage, isUser: true)) // Add user's response
                isMessageVisible.append(false)
            }
            userResponses.append(trimmedMessage) // Store user's response
            userMessage = ""

            // Check if there are more questions to ask
            if currentQuestionIndex < questions.count - 1 {
                currentQuestionIndex += 1
                askNextQuestion()
            } else {
                // All questions have been answered, navigate to results page
                isLoading = true
                handleFinalSubmission()
            }
        }
    }

    // Ask the next question from the array
    func askNextQuestion() {
        let question = questions[currentQuestionIndex]
        withAnimation {
            messages.append(ChatMessage(text: question, isUser: false)) // Display next question
            isMessageVisible.append(false)
        }
    }

    // Handle final submission after all questions have been answered
    func handleFinalSubmission() {
        // Prepare data to pass to the results page
        let combinedResponses = userResponses.joined(separator: ", ")
        let resultMessage = "Thank you for your responses. Based on your answers: \(combinedResponses)"
        responseAfterFullStop = resultMessage

        // Simulate API call or delay before navigating to results
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
            navigateToScreen4 = true // Navigate to the results page
        }
    }
}
