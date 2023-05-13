//
//  CropViewController.swift
//  Shapely
//
//  Created by Andrew on 08.05.2023.
//

import UIKit

// swiftlint:disable all

public protocol CropViewControllerDelegate: AnyObject {
    func cropViewController(_ controller: CropViewController, didFinishCroppingImage image: UIImage)
    func cropViewController(_ controller: CropViewController, didFinishCroppingImage image: UIImage, transform: CGAffineTransform, cropRect: CGRect)
    func cropViewControllerDidCancel(_ controller: CropViewController)
}

open class CropViewController: UIViewController {
    open weak var delegate: CropViewControllerDelegate?
    open var image: UIImage? {
        didSet {
            cropView?.props = .init(image: image!)
        }
    }
    open var cropRect = CGRect.zero {
        didSet {
            adjustCropRect()
        }
    }
    open var imageCropRect = CGRect.zero {
        didSet {
            cropView?.imageCropRect = imageCropRect
        }
    }

    fileprivate var cropView: CropView?

    open override func loadView() {
        let contentView = UIView()
        contentView.autoresizingMask = .flexibleWidth
        contentView.backgroundColor = UIColor.black
        view = contentView

        // Add CropView
        cropView = CropView()
        cropView?.frame = contentView.bounds
        contentView.addSubview(cropView!)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        cropView?.props = .init(image: image!)
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !cropRect.equalTo(CGRect.zero) {
            adjustCropRect()
        }

        if !imageCropRect.equalTo(CGRect.zero) {
            cropView?.imageCropRect = imageCropRect
        }
    }

    open func resetCropRect() {
        cropView?.resetCropRect()
    }

    open func resetCropRectAnimated(_ animated: Bool) {
        cropView?.resetCropRectAnimated(animated)
    }

    @objc func cancel(_ sender: UIBarButtonItem) {
        delegate?.cropViewControllerDidCancel(self)
    }

    @objc func done(_ sender: UIBarButtonItem) {
        if let image = cropView?.croppedImage {
            delegate?.cropViewController(self, didFinishCroppingImage: image)
            guard let rotation = cropView?.rotation else {
                return
            }
            guard let rect = cropView?.zoomedCropRect() else {
                return
            }
            delegate?.cropViewController(self, didFinishCroppingImage: image, transform: rotation, cropRect: rect)
        }
    }

    // MARK: - Private methods
    fileprivate func adjustCropRect() {
        imageCropRect = CGRect.zero

        guard var cropViewCropRect = cropView?.cropRect else {
            return
        }
        cropViewCropRect.origin.x += cropRect.origin.x
        cropViewCropRect.origin.y += cropRect.origin.y

        let minWidth = min(cropViewCropRect.maxX - cropViewCropRect.minX, cropRect.width)
        let minHeight = min(cropViewCropRect.maxY - cropViewCropRect.minY, cropRect.height)
        let size = CGSize(width: minWidth, height: minHeight)
        cropViewCropRect.size = size
        cropView?.cropRect = cropViewCropRect
    }
}
