//
//  UIImage+Extension.swift
//  Image Analyzer
//
//  Created by Songkyung Min on 5/19/24.
//  Copyright © 2024 Nyisztor, Karoly. All rights reserved.
//

import UIKit

extension UIImage {
    var cgOrientation: CGImagePropertyOrientation {
        switch imageOrientation {
            case .up: return .up
            case .upMirrored: return .upMirrored
            case .down: return .down
            case .downMirrored: return .downMirrored
            case .leftMirrored: return .leftMirrored
            case .left: return .left
            case .right: return .right
            case .rightMirrored: return .rightMirrored
        }
    }
}
