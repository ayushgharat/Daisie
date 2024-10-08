import SwiftUI
import PencilKit

struct CustomCanvasView: UIViewRepresentable {
    @Binding var drawing: PKDrawing
    @Binding var currentQuestionIndex: Int
    @Binding var drawingsForQuestions: [DrawingForQuestion]
    @Binding var currentTime: CGFloat
    @Binding var lastSavedDrawing: PKDrawing
    var questions: [Question]

    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: CustomCanvasView

        init(_ parent: CustomCanvasView) {
            self.parent = parent
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            // Update the binding with the current drawing when it changes
            parent.drawing = canvasView.drawing

            // Only extract new strokes if there is a difference between current drawing and last saved drawing
            if parent.drawing != parent.lastSavedDrawing {
                parent.extractNewStrokes(from: canvasView.drawing)
                parent.lastSavedDrawing = canvasView.drawing // Update last saved drawing to the current state
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        canvasView.tool = PKInkingTool(.pen, color: .gray, width: 10)
        canvasView.delegate = context.coordinator
        canvasView.layer.borderColor = UIColor.black.cgColor
        canvasView.layer.borderWidth = 2
        canvasView.layer.cornerRadius = 8
        canvasView.backgroundColor = UIColor(Color.clear)

        #if targetEnvironment(simulator)
        // In simulator, allow drawing with any input (like a mouse or trackpad)
        canvasView.drawingPolicy = .anyInput
        #endif

        // Initialize the canvas with the current drawing
        canvasView.drawing = drawing

        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // Synchronize the PKDrawing only if it has changed
        if uiView.drawing != drawing {
            uiView.drawing = drawing
        }
    }

    // Extract only the new strokes and append them to the strokes array for the current question
    func extractNewStrokes(from drawing: PKDrawing) {
        var newStrokes: [StrokeObject] = []

        // Get the strokes from the current drawing that are not in the last saved drawing
        let currentStrokes = drawing.strokes
        let previousStrokes = lastSavedDrawing.strokes

        // Determine which strokes are new by manually comparing current strokes to previous strokes
        let newStrokeSet = currentStrokes.filter { stroke in
            !previousStrokes.contains { previousStroke in
                pathsAreEqual(stroke.path, previousStroke.path)
            }
        }

        for stroke in newStrokeSet {
            var points: [PointObject] = []

            let baseTimestamp = currentTime

            for i in 0..<stroke.path.count {
                let strokePoint = stroke.path[i]
                let timestamp = i == 0 ? baseTimestamp : baseTimestamp + strokePoint.timeOffset

                let point = PointObject(
                    x: strokePoint.location.x,
                    y: strokePoint.location.y,
                    timestamp: timestamp,
                    force: strokePoint.force
                )
                points.append(point)
            }

            let strokeObject = StrokeObject(type: "stroke", points: points)
            newStrokes.append(strokeObject)
        }

        // Append the new strokes to the correct question's strokes array
        drawingsForQuestions[currentQuestionIndex].strokes.append(contentsOf: newStrokes)
    }

    // Helper function to compare two PKStrokePath objects by comparing their points
    func pathsAreEqual(_ path1: PKStrokePath, _ path2: PKStrokePath) -> Bool {
        if path1.count != path2.count {
            return false
        }

        for i in 0..<path1.count {
            let point1 = path1[i]
            let point2 = path2[i]

            if point1.location != point2.location || point1.timeOffset != point2.timeOffset || point1.force != point2.force {
                return false
            }
        }

        return true
    }
}

struct DrawingView: View {
    @Binding var drawing: PKDrawing
    @Binding var currentQuestionIndex: Int
    @Binding var drawingsForQuestions: [DrawingForQuestion]
    @Binding var currentTime: CGFloat
    @Binding var lastSavedDrawing: PKDrawing
    var questions: [Question]
    

    var body: some View {
        ZStack {
            // Background reference view for the preloaded drawing
            if let preloadedDrawing = questions[currentQuestionIndex].preloadedDrawing {
                // Display the preloaded drawing as a background image
                Color.white.overlay(
                    Image(uiImage: preloadedDrawing.toUIImage())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 800, height: 500)
//                        .border(Color.blue, width: 5)
                        .opacity(0.3) // Adjust the opacity to make it a reference
                )
            } else {
                Color.white // Fallback background if no preloaded drawing exists
            }

            // Drawing canvas overlaid on top of the reference background
            CustomCanvasView(
                drawing: $drawing,
                currentQuestionIndex: $currentQuestionIndex,
                drawingsForQuestions: $drawingsForQuestions,
                currentTime: $currentTime,
                lastSavedDrawing: $lastSavedDrawing,
                questions: questions
            )
            .background(Color.clear) // Ensure the canvas background is clear so the image shows
        }
    }
}

extension PKDrawing {
    // Helper function to convert PKDrawing to UIImage
    func toUIImage() -> UIImage {
        let canvasSize = CGSize(width: 300, height: 300) // Adjust the canvas size to your needs
        return self.image(from: CGRect(origin: .zero, size: canvasSize), scale: 1.0)
    }
}
