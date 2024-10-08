//
//  to.swift
//  TestProject
//
//  Created by Ayush Gharat on 9/28/24.
//


import SwiftUI
import PencilKit

// Define an enum to represent the different question types
enum QuestionType: String, Codable {
    case drawing
    case dictation
    case memorization
    case copying
    case parkinson
}

import Foundation

import Foundation

// Message struct to simulate a chat
struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool // true for Human, false for AI
}

// Define a struct to hold the question and its type
struct Question: Codable {
    let text: String
    let type: QuestionType
    let preloadedDrawing: PKDrawing?
    let dictationText: String?
    let imageLink: String?
    let questionNo: String
}

// Structure to hold the question and its corresponding strokes
struct DrawingForQuestion: Hashable, Encodable {
    let question: String
    var strokes: [StrokeObject]
    let questionNo: String
//    var screenshot: UIImage?
}

// Struct to hold individual point data for a stroke
struct PointObject: Codable, Hashable {
    let x: CGFloat
    let y: CGFloat
    let timestamp: CGFloat
    let force: CGFloat
}

// Struct to hold individual stroke data
struct StrokeObject: Codable, Hashable {
    let type: String
    var points: [PointObject]
}

// Array of questions with their respective types and preloaded drawings
// Array of questions with their respective types and preloaded drawings
let questions: [Question] = [
    Question(text: "Join two points with a vertical line, continuously for four times", type: .drawing, preloadedDrawing: createTwoDotsDrawing(), dictationText: nil, imageLink: nil, questionNo: "3"),
    //Question(text: "Write CASA in Reverse", type: .copying, preloadedDrawing: nil, dictationText: nil, imageLink: nil),
    Question(text: "Copy the word “mamma” above a line", type: .drawing, preloadedDrawing: createPKDrawingWithTextAndLines(), dictationText: nil, imageLink: nil, questionNo: "13"),
    Question(text: "Write the name of the object in the picture", type: .copying, preloadedDrawing: nil, dictationText: nil, imageLink: "data:image/jpeg;base64,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", questionNo: "18"),
    Question(text: "Write a telephone number under dictation", type: .dictation, preloadedDrawing: nil, dictationText: "309-840-0145", imageLink: nil, questionNo: "23"),
    
    Question(text: "Copy the word \"foglio\"", type: .copying, preloadedDrawing: nil, dictationText: nil, imageLink: nil, questionNo: "10"),
    Question(text: "Memorize the words and rewrite them. You will have 7 seconds to memorize them", type: .memorization, preloadedDrawing: nil, dictationText: "telefono, cane, negozio", imageLink: nil, questionNo: "14"),
    Question(text: "Retrace a circle (6 cm of diameter) continuously for four times.", type: .drawing, preloadedDrawing: createCirclePKDrawing(), dictationText: nil, imageLink: nil, questionNo: "4"),
    Question(text: "Copy in reverse the word \"bottiglia\"", type: .copying, preloadedDrawing: nil, dictationText: nil, imageLink: nil, questionNo: "15"),
    Question(text: "Draw a spiral starting from the center and moving outwards", type: .copying, preloadedDrawing: nil, dictationText: nil, imageLink: nil, questionNo: "26")
    
]
