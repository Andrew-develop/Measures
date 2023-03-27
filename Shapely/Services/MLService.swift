//
//  MLService.swift
//  Shapely
//
//  Created by Andrew on 14.03.2023.
//

import UIKit
import CoreML
import Vision
import CoreMedia
import RxSwift

// swiftlint:disable all

final class MLService {
    private let imageSubject = PublishSubject<UIImage>()
    var rx_maskedImage: Observable<UIImage> {
        imageSubject.asObserver()
    }

    func runVisionRequest(with inputImage: UIImage) {
        guard let model = try? VNCoreMLModel(for: DeepLabV3(configuration: .init()).model) else { return }
        
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            DispatchQueue.main.async {
                if let observations = request.results as? [VNCoreMLFeatureValueObservation],
                    let segmentationmap = observations.first?.featureValue.multiArrayValue {
                    let segmentationMask = segmentationmap.image(min: 0, max: 1)
                    let outputImage = segmentationMask!.resizedImage(for: inputImage.size)!

                    self?.maskInputImage(inputImage: inputImage, outputImage: outputImage)
                }
            }
        }
        request.imageCropAndScaleOption = .scaleFill

        DispatchQueue.global().async {
            let handler = VNImageRequestHandler(cgImage: inputImage.cgImage!, options: [:])
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
    }
    
    private func maskInputImage(inputImage: UIImage, outputImage: UIImage) {
        
//        let points = [GradientPoint(location: 0, color: #colorLiteral(red: 0.6486759186, green: 0.2260715365, blue: 0.2819285393, alpha: 1)), GradientPoint(location: 0.2, color: #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 0.5028884243)), GradientPoint(location: 0.4, color: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 0.3388534331)),
//                  GradientPoint(location: 0.6, color: #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 0.3458681778)), GradientPoint(location: 0.8, color: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 0.3388534331))]
//
//        let bgImage = UIImage(size: self.inputImage.size, gradientPoints: points, scale: self.inputImage.scale)!
        
//        let bgImage = UIImage.imageFromColor(color: .orange, size: inputImage.size, scale: inputImage.scale)!

        let beginImage = CIImage(cgImage: inputImage.cgImage!)
//        let background = CIImage(cgImage: bgImage.cgImage!)
        let mask = CIImage(cgImage: outputImage.cgImage!)
        
        if let compositeImage = CIFilter(name: "CIBlendWithMask", parameters: [
                                        kCIInputImageKey: beginImage,
//                                        kCIInputBackgroundImageKey: background,
                                        kCIInputMaskImageKey: mask])?.outputImage {
            
            let ciContext = CIContext(options: nil)
            let filteredImageRef = ciContext.createCGImage(compositeImage, from: compositeImage.extent)
            
            imageSubject.onNext(UIImage(cgImage: filteredImageRef!))
        }
    }
}
