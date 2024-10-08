import SwiftUI
import PencilKit
import AVFoundation

struct Screen2: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var currentQuestionIndex = 0
    @State private var drawingsForQuestions: [DrawingForQuestion] = questions.map {
        DrawingForQuestion(question: $0.text, strokes: [], questionNo: $0.questionNo)
    }
    
    @State private var currentDrawing: PKDrawing = PKDrawing()
    @State private var lastSavedDrawing: PKDrawing = PKDrawing()
    @State private var navigateToScreen3 = false
    
    @State private var timer: Timer?
    @State private var currentTime: CGFloat = 0
    
    @State private var showMemorizationText = false
    @State private var memorizationTimeRemaining = 7
    @State private var memorizationButtonDisabled = false
    
    @State private var speechSynthesizer: AVSpeechSynthesizer?
    @State private var animateText = false

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea() // A minimal light or dark background
            
            VStack(spacing: 20) {
                
                // Simplified back navigation button at the top of the screen
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16))
                            .foregroundColor(.primary)
                    }
                    Spacer()
                }
                .padding(.leading, 20)
                .padding(.top, 40)
                
                // Display the current question at the top with a clean font style
                Text(questions[currentQuestionIndex].text)
                    .font(.system(size: 28, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .padding(.horizontal)
                    .offset(x: animateText ? 0 : UIScreen.main.bounds.width) // Move from right
                    .animation(.easeInOut(duration: 0.6), value: animateText) // Ease-in and ease-out animation
                    .onAppear {
                        animateText = true
                    }
                    .onChange(of: currentQuestionIndex) { _ in
                        animateText = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            animateText = true
                        }
                    }
                
                Spacer(minLength: 20) // Minimal spacing
                
                // Display image if imageLink is not nil
                if let imageLink = questions[currentQuestionIndex].imageLink,
                   let url = URL(string: imageLink) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 200)
                        case .failure:
                            Text("Image Unavailable")
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .padding(.bottom, 10)
                }
                
                if questions[currentQuestionIndex].type == .dictation {
                    Button {
                        playDictation(text: questions[currentQuestionIndex].dictationText ?? "")
                    } label: {
                        Label("Play Dictation", systemImage: "speaker.wave.2")
                            .foregroundColor(.primary)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                }
                
                if questions[currentQuestionIndex].type == .memorization {
                    VStack {
                        if showMemorizationText {
                            Text("\(questions[currentQuestionIndex].dictationText ?? "")")
                                .font(.body)
                                .padding()
                            
                            Text("Time remaining: \(memorizationTimeRemaining)")
                                .font(.subheadline)
                                .padding()
                        }
                        
                        Button {
                            startMemorizationCountdown()
                        } label: {
                            Label("Start Memorization", systemImage: "timer")
                                .foregroundColor(.primary)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        .disabled(memorizationButtonDisabled)
                    }
                }
                
                ZStack {
                    Color(.systemGray6)
                        .cornerRadius(12)
                    
                    DrawingView(
                        drawing: $currentDrawing,
                        currentQuestionIndex: $currentQuestionIndex,
                        drawingsForQuestions: $drawingsForQuestions,
                        currentTime: $currentTime,
                        lastSavedDrawing: $lastSavedDrawing,
                        questions: questions
                    )
                    .padding()
                }
                .frame(width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height / 2)
                
                // Navigation buttons with simpler, minimalistic design
                HStack(spacing: 40) {
                    if currentQuestionIndex == questions.count - 1 {
                        Button {
                            stopTimer()
                            navigateToScreen3 = true
                        } label: {
                            Label("Complete Test", systemImage: "checkmark")
                                .foregroundColor(.primary)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                    } else {
                        Button {
                            stopTimer()
                            DispatchQueue.main.async {
                                withAnimation {
                                    currentQuestionIndex += 1
                                    currentDrawing = PKDrawing()
                                    lastSavedDrawing = PKDrawing()
                                    startTimer()
                                    showMemorizationText = false
                                    memorizationTimeRemaining = 7
                                    memorizationButtonDisabled = false
                                }
                            }
                        } label: {
                            Label("Next", systemImage: "arrow.right")
                                .foregroundColor(.primary)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.top, 20)
                .navigationDestination(isPresented: $navigateToScreen3) {
                    Screen3(drawingsForQuestions: drawingsForQuestions)
                }
            }
            .padding()
            .onAppear {
                startTimer()
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
    
    func startTimer() {
        currentTime = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            currentTime += 0.01
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func playDictation(text: String) {
        let audioSession = AVAudioSession()
        do {
            try audioSession.setCategory(.playback, mode: .default, options: .duckOthers)
            try audioSession.setActive(false)
        } catch let error {
            print("❓", error.localizedDescription)
        }
        
        speechSynthesizer = AVSpeechSynthesizer()
        
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        speechSynthesizer?.speak(speechUtterance)
    }
    
    func startMemorizationCountdown() {
        showMemorizationText = true
        memorizationButtonDisabled = true

        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if memorizationTimeRemaining > 0 {
                memorizationTimeRemaining -= 1
            } else {
                showMemorizationText = false
                timer.invalidate()
            }
        }
    }
}
