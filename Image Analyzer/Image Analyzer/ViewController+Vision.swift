//
//  ViewController+Vision.swift
//  Image Analyzer
//
//  Created by Songkyung Min on 5/19/24.
//  Copyright © 2024 Nyisztor, Karoly. All rights reserved.
//

import UIKit
import Vision

extension ViewController {
    
    var detectionBarcodeRequest: VNDetectBarcodesRequest {
        let request = VNDetectBarcodesRequest { request, error in
            if let detectError = error {
                debugPrint(detectError)
                return
            } else {
                guard let observations = request.results as? [VNDetectedObjectObservation] else { return }
                print(observations)
                self.visualizedObservations(observations)
            }
        }
        
        return request
    }
    
    var detectionFaceRequest: VNDetectFaceRectanglesRequest {
        let request = VNDetectFaceRectanglesRequest { request, error in
            if let detectError = error {
                debugPrint(detectError)
                return
            } else {
                guard let observations = request.results as? [VNDetectedObjectObservation] else { return }
                print(observations)
                self.visualizedObservations(observations)
            }
        }
        
        return request
    }
    
    var detectionTextRequest: VNDetectTextRectanglesRequest {
        let request = VNDetectTextRectanglesRequest { request, error in
            if let detectError = error {
                debugPrint(detectError)
                return
            } else {
                guard let observations = request.results as? [VNDetectedObjectObservation] else { return }
                print(observations)
                self.visualizedObservations(observations)
            }
        }
        request.reportCharacterBoxes = true
        
        return request
    }
    
    var detectionRequest: VNDetectRectanglesRequest {
        let request = VNDetectRectanglesRequest { request, error in
            if let detectError = error {
                debugPrint(detectError)
                return
            } else {
                guard let observations = request.results as? [VNDetectedObjectObservation] else { return }
                print(observations)
                self.visualizedObservations(observations)
            }
        }
        
        request.maximumObservations = 0
        request.minimumConfidence = 0.5
        request.minimumAspectRatio = 0
        
        return request
    }
     
    func performVisionRequest(image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: image.cgOrientation, options: [:])
        
        let requests = [detectionRequest, detectionTextRequest, detectionFaceRequest, detectionBarcodeRequest]
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                print(requests)
                try imageRequestHandler.perform(requests)
            } catch let error as NSError {
                debugPrint(error.localizedDescription.localizedLowercase)
                return
            }
        }
    }
    
    private func visualizedObservations(_ observations: [VNDetectedObjectObservation]) {
        DispatchQueue.main.async {
            guard let image = self.imageView.image else {
                debugPrint("Failed to retrieve image")
                return
            }
            
            let imageSize = image.size // returns a cgsize
            var transform = CGAffineTransform.identity.scaledBy(x: 1, y: -1).translatedBy(x: 0, y: -imageSize.height)
            transform = transform.scaledBy(x: imageSize.width, y: imageSize.height) // flipping image & scaled to image size (UIKit 기준으로 변환)
            
            UIGraphicsBeginImageContextWithOptions(imageSize, true, 0.0)
            let context = UIGraphicsGetCurrentContext()
            image.draw(in: CGRect(origin: .zero, size: imageSize)) // 이미지 비트맵 형식으로 draw
            
            context?.saveGState()
            context?.setLineJoin(CGLineJoin.round)
            context?.setLineWidth(8.0)
            context?.setStrokeColor(UIColor.red.cgColor)
            context?.setFillColor(red: 1, green: 0, blue: 0, alpha: 0.3)
            
            observations.forEach { observation in
                let observationsBounds = observation.boundingBox.applying(transform)
                context?.addRect(observationsBounds)
            }
            
            context?.drawPath(using: CGPathDrawingMode.fillStroke)
            context?.restoreGState()
            
            let drawnImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            self.imageView.image = drawnImage
            
            
            
            
             
        }
    }
}
