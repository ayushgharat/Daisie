//
//  utils.swift
//  TestProject
//
//  Created by Ayush Gharat on 9/29/24.
//

import PencilKit
import SwiftUI

func createTwoDotsDrawing() -> PKDrawing {
    // Create a mutable array of strokes
    var strokes: [PKStroke] = []
    
    // Define canvas size (hardcoded or approximate)
    let canvasWidth: CGFloat = 300
    let canvasHeight: CGFloat = 200
    
    // Create a dot at the top (centered horizontally)
    let topDotPoint = PKStrokePoint(location: CGPoint(x: canvasWidth / 2, y: 10), timeOffset: 0, size: CGSize(width: 5, height: 5), opacity: 1, force: 1, azimuth: 0, altitude: 0)
    
    let topDotPath = PKStrokePath(controlPoints: [topDotPoint], creationDate: Date())
    let topDotStroke = PKStroke(ink: PKInk(.pen, color: .black), path: topDotPath)
    strokes.append(topDotStroke)
    
    // Create a dot at the bottom (centered horizontally)
    let bottomDotPoint = PKStrokePoint(location: CGPoint(x: canvasWidth / 2, y: canvasHeight - 10), timeOffset: 0, size: CGSize(width: 5, height: 5), opacity: 1, force: 1, azimuth: 0, altitude: 0)
    
    let bottomDotPath = PKStrokePath(controlPoints: [bottomDotPoint], creationDate: Date())
    let bottomDotStroke = PKStroke(ink: PKInk(.pen, color: .black), path: bottomDotPath)
    strokes.append(bottomDotStroke)
    
    // Create a drawing from the strokes
    let drawing = PKDrawing(strokes: strokes)
    
    return drawing
}

// Example function to create a circle preloaded drawing
func createCirclePKDrawing() -> PKDrawing {
    // Convert 6 cm to points (approximately 227 points for 6 cm)
    let circleDiameter: CGFloat = 227
    let circleRadius = circleDiameter / 2
    
    // Circle center
    let center = CGPoint(x: circleRadius + 20, y: circleRadius + 20)  // Adding some padding from the top-left corner
    
    // Create the points for the circle
    var points: [PKStrokePoint] = []
    
    // Generate points around the circumference of the circle
    let numPoints = 100
    for i in 0..<numPoints {
        let angle = 2 * CGFloat.pi * CGFloat(i) / CGFloat(numPoints)
        let x = center.x + circleRadius * cos(angle)
        let y = center.y + circleRadius * sin(angle)
        
        let point = PKStrokePoint(
            location: CGPoint(x: x, y: y),
            timeOffset: 0,
            size: CGSize(width: 2, height: 2),
            opacity: 1,
            force: 1,
            azimuth: 0,
            altitude: 0
        )
        points.append(point)
    }
    
    // Create the stroke for the circle path
    let circlePath = PKStrokePath(controlPoints: points, creationDate: Date())
    let circleStroke = PKStroke(ink: PKInk(.pen, color: .black), path: circlePath)
    
    // Return the PKDrawing with the circle
    return PKDrawing(strokes: [circleStroke])
}

func createPKDrawingWithTextAndLines() -> PKDrawing {
    var strokes: [PKStroke] = []
    
    // First line coordinates
    let firstLinePath = createLinePath(from: CGPoint(x: 20, y: 150), to: CGPoint(x: 380, y: 150))
    let firstLineStroke = PKStroke(ink: PKInk(.pen, color: .black), path: firstLinePath)
    strokes.append(firstLineStroke)
    
//    // Second line coordinates
//    let secondLinePath = createLinePath(from: CGPoint(x: 20, y: 160), to: CGPoint(x: 380, y: 160))
//    let secondLineStroke = PKStroke(ink: PKInk(.pen, color: .black), path: secondLinePath)
//    strokes.append(secondLineStroke)
//
//    // Third line coordinates
//    let thirdLinePath = createLinePath(from: CGPoint(x: 20, y: 260), to: CGPoint(x: 380, y: 260))
//    let thirdLineStroke = PKStroke(ink: PKInk(.pen, color: .black), path: thirdLinePath)
//    strokes.append(thirdLineStroke)
    
    // Return the PKDrawing with all strokes (lines)
    return PKDrawing(strokes: strokes)
}

// Helper function to create a PKStrokePath from two points (start and end of the line)
func createLinePath(from startPoint: CGPoint, to endPoint: CGPoint) -> PKStrokePath {
    let startStrokePoint = PKStrokePoint(
        location: startPoint,
        timeOffset: 0,
        size: CGSize(width: 5, height: 5),
        opacity: 1,
        force: 1,
        azimuth: 0,
        altitude: 0
    )
    
    let endStrokePoint = PKStrokePoint(
        location: endPoint,
        timeOffset: 0,
        size: CGSize(width: 5, height: 5),
        opacity: 1,
        force: 1,
        azimuth: 0,
        altitude: 0
    )
    
    return PKStrokePath(controlPoints: [startStrokePoint, endStrokePoint], creationDate: Date())
}

import Foundation

class DrawingToJSONConverter {
    
    // Function to convert DrawingForQuestion to JSON
    static func convert(drawings: [DrawingForQuestion]) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let jsonData = try encoder.encode(drawings)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            print("Failed to convert drawings to JSON: \(error)")
        }
        return nil
    }
}

import Foundation

// Extension to safely access array elements without risking out-of-range errors
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

