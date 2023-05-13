//
//  CropView.swift
//  Shapely
//
//  Created by Andrew on 08.05.2023.
//

import UIKit
import AVFoundation
import SnapKit

// swiftlint:disable all

final class CropView: UIView {
    private let imageView = with(UIImageView()) {
        $0.contentMode = .scaleAspectFit
    }

    private let zoomingView = with(UIView()) {
        $0.apply(.backgroundColor)
    }

    private let scrollView = with(UIScrollView()) {
        $0.apply(.photoEdit)
    }

    var croppedImage: UIImage? {
        return props.image.rotatedImageWithTransform(rotation, croppedToRect: zoomedCropRect())
    }
    var cropAspectRatio: CGFloat {
        get {
            let rect = scrollView.frame
            let width = rect.width
            let height = rect.height
            return width / height
        }
        set {
            setCropAspectRatio(newValue, shouldCenter: true)
        }
    }

    var props: Props = .default {
        didSet { render(oldProps: oldValue, newProps: props) }
    }

    func render(oldProps: Props, newProps: Props) {
        if oldProps.image != newProps.image {
            imageView.image = newProps.image
            imageSize = newProps.image.size
            setNeedsLayout()
        }
    }

    var rotation: CGAffineTransform {
        return imageView.transform
    }
    var rotationAngle: CGFloat {
        get {
            return atan2(rotation.b, rotation.a)
        }
        set {
            imageView.transform = CGAffineTransform(rotationAngle: newValue)
        }
    }
    var cropRect: CGRect {
        get {
            return scrollView.frame
        }
        set {
            zoomToCropRect(newValue)
        }
    }
    var imageCropRect = CGRect.zero {
        didSet {
            resetCropRect()

            let scale = min(scrollView.frame.width / imageSize.width, scrollView.frame.height / imageSize.height)
            let x = imageCropRect.minX * scale + scrollView.frame.minX
            let y = imageCropRect.minY * scale + scrollView.frame.minY
            let width = imageCropRect.width * scale
            let height = imageCropRect.height * scale

            let rect = CGRect(x: x, y: y, width: width, height: height)
            let intersection = rect.intersection(scrollView.frame)

            if !intersection.isNull {
                cropRect = intersection
            }
        }
    }
    var resizeEnabled = true {
        didSet {
            cropRectView.enableResizing(resizeEnabled)
        }
    }
    var showCroppedArea = true {
        didSet {
            layoutIfNeeded()
            scrollView.clipsToBounds = !showCroppedArea
            showOverlayView(showCroppedArea)
        }
    }

    private var imageSize = CGSize(width: 1.0, height: 1.0)
    private let cropRectView = CropRectView()
    private let topOverlayView = UIView()
    private let leftOverlayView = UIView()
    private let rightOverlayView = UIView()
    private let bottomOverlayView = UIView()
    private var insetRect = CGRect.zero
    private var editingRect = CGRect.zero
    private var resizing = false
    private let MarginTop: CGFloat = 37.0
    private let MarginLeft: CGFloat = 20.0

    init() {
        super.init(frame: .zero)
        prepareView()
    }

    required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func prepareView() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        (self as UIView).apply(.backgroundColor)

        let recognizer = UIRotationGestureRecognizer(target: self, action: #selector(CropView.handleRotation(_:)))
        recognizer.delegate = self
        scrollView.addGestureRecognizer(recognizer)

        cropRectView.delegate = self

        showOverlayView(showCroppedArea)
        
        zoomingView.addSubview(imageView)
        scrollView.addSubview(zoomingView)
        addSubviews(scrollView, cropRectView, topOverlayView, leftOverlayView, rightOverlayView, bottomOverlayView)
    }
    
    private func setupZoomingView() {
        let cropRect = AVMakeRect(aspectRatio: imageSize, insideRect: insetRect)

        scrollView.frame = cropRect
        scrollView.contentSize = cropRect.size
        scrollView.delegate = self

        zoomingView.frame = scrollView.bounds
    }

    private func setupImageView() {
        imageView.frame = zoomingView.bounds
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !isUserInteractionEnabled {
            return nil
        }

        if let hitView = cropRectView.hitTest(convert(point, to: cropRectView), with: event) {
            return hitView
        }
        let locationInImageView = convert(point, to: zoomingView)
        let zoomedPoint = CGPoint(
            x: locationInImageView.x * scrollView.zoomScale, y: locationInImageView.y * scrollView.zoomScale
        )
        if zoomingView.frame.contains(zoomedPoint) {
            return scrollView
        }
        return super.hitTest(point, with: event)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupEditingRect()

        insetRect = bounds.insetBy(dx: MarginLeft, dy: MarginTop)
        if !showCroppedArea {
            insetRect = editingRect
        }
        setupZoomingView()
        setupImageView()

        if !resizing {
            layoutCropRectViewWithCropRect(scrollView.frame)
        }
    }

    func setRotationAngle(_ rotationAngle: CGFloat, snap: Bool) {
        var rotation = rotationAngle
        if snap {
            rotation = nearbyint(rotationAngle / CGFloat(Double.pi / 2)) * CGFloat(Double.pi / 2)
        }
        self.rotationAngle = rotation
    }

    func resetCropRect() {
        resetCropRectAnimated(false)
    }

    func resetCropRectAnimated(_ animated: Bool) {
        if animated {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.25)
            UIView.setAnimationBeginsFromCurrentState(true)
        }
        imageView.transform = CGAffineTransform.identity
        let contentSize = scrollView.contentSize
        let initialRect = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        scrollView.zoom(to: initialRect, animated: false)

        layoutCropRectViewWithCropRect(scrollView.bounds)

        if animated {
            UIView.commitAnimations()
        }
    }

    func zoomedCropRect() -> CGRect {
        let cropRect = convert(scrollView.frame, to: zoomingView)
        var ratio: CGFloat = 1.0
        ratio = AVMakeRect(aspectRatio: imageSize, insideRect: insetRect).width / imageSize.width

        let zoomedCropRect = CGRect(x: cropRect.origin.x / ratio,
            y: cropRect.origin.y / ratio,
            width: cropRect.size.width / ratio,
            height: cropRect.size.height / ratio)

        return zoomedCropRect
    }

    func croppedImage(_ image: UIImage) -> UIImage {
        imageSize = image.size
        return image.rotatedImageWithTransform(rotation, croppedToRect: zoomedCropRect())
    }

    @objc func handleRotation(_ gestureRecognizer: UIRotationGestureRecognizer) {
        let rotation = gestureRecognizer.rotation
        let transform = imageView.transform.rotated(by: rotation)
        imageView.transform = transform
        gestureRecognizer.rotation = 0.0

        switch gestureRecognizer.state {
        case .began, .changed:
            cropRectView.showsGridMinor = true
        default:
            cropRectView.showsGridMinor = false
        }
    }

    // MARK: - Private methods
    private func showOverlayView(_ show: Bool) {
        let color = show ? UIColor(white: 0.0, alpha: 0.4) : UIColor.clear

        topOverlayView.backgroundColor = color
        leftOverlayView.backgroundColor = color
        rightOverlayView.backgroundColor = color
        bottomOverlayView.backgroundColor = color
    }

    private func setupEditingRect() {
        editingRect = bounds.insetBy(dx: MarginLeft, dy: MarginTop)
        if !showCroppedArea {
            editingRect = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        }
    }

    private func layoutCropRectViewWithCropRect(_ cropRect: CGRect) {
        cropRectView.frame = cropRect
        layoutOverlayViewsWithCropRect(cropRect)
    }

    private func layoutOverlayViewsWithCropRect(_ cropRect: CGRect) {
        topOverlayView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: cropRect.minY)
        leftOverlayView.frame = CGRect(x: 0, y: cropRect.minY, width: cropRect.minX, height: cropRect.height)
        rightOverlayView.frame = CGRect(x: cropRect.maxX, y: cropRect.minY, width: bounds.width - cropRect.maxX, height: cropRect.height)
        bottomOverlayView.frame = CGRect(x: 0, y: cropRect.maxY, width: bounds.width, height: bounds.height - cropRect.maxY)
    }

    private func zoomToCropRect(_ toRect: CGRect) {
        zoomToCropRect(toRect, shouldCenter: false, animated: true)
    }

    private func zoomToCropRect(_ toRect: CGRect, shouldCenter: Bool, animated: Bool, completion: (() -> Void)? = nil) {
        if scrollView.frame.equalTo(toRect) {
            return
        }

        let width = toRect.width
        let height = toRect.height
        let scale = min(editingRect.width / width, editingRect.height / height)

        let scaledWidth = width * scale
        let scaledHeight = height * scale
        let cropRect = CGRect(x: (bounds.width - scaledWidth) / 2.0, y: (bounds.height - scaledHeight) / 2.0, width: scaledWidth, height: scaledHeight)

        var zoomRect = convert(toRect, to: zoomingView)
        zoomRect.size.width = cropRect.width / (scrollView.zoomScale * scale)
        zoomRect.size.height = cropRect.height / (scrollView.zoomScale * scale)

        if shouldCenter {
            let imageViewBounds = imageView.bounds
            zoomRect.origin.x = (imageViewBounds.width / 2.0) - (zoomRect.width / 2.0)
            zoomRect.origin.y = (imageViewBounds.height / 2.0) - (zoomRect.height / 2.0)
        }

        var duration = 0.0
        if animated {
            duration = 0.25
        }

        UIView.animate(withDuration: duration, delay: 0.0, options: .beginFromCurrentState, animations: { [unowned self] in
            self.scrollView.bounds = cropRect
            self.scrollView.zoom(to: zoomRect, animated: false)
            self.layoutCropRectViewWithCropRect(cropRect)
        }) { finished in
            completion?()
        }
    }

    private func cappedCropRectInImageRectWithCropRectView(_ cropRectView: CropRectView) -> CGRect {
        var cropRect = cropRectView.frame

        let rect = convert(cropRect, to: scrollView)
        if rect.minX < zoomingView.frame.minX {
            cropRect.origin.x = scrollView.convert(zoomingView.frame, to: self).minX
            let cappedWidth = rect.maxX
            let height = cropRect.size.height
            cropRect.size = CGSize(width: cappedWidth, height: height)
        }

        if rect.minY < zoomingView.frame.minY {
            cropRect.origin.y = scrollView.convert(zoomingView.frame, to: self).minY
            let cappedHeight = rect.maxY
            let width = cropRect.size.width
            cropRect.size = CGSize(width: width, height: cappedHeight)
        }

        if rect.maxX > zoomingView.frame.maxX {
            let cappedWidth = scrollView.convert(zoomingView.frame, to: self).maxX - cropRect.minX
            let height = cropRect.size.height
            cropRect.size = CGSize(width: cappedWidth, height: height)
        }
        
        if rect.maxY > zoomingView.frame.maxY {
            let cappedHeight = scrollView.convert(zoomingView.frame, to: self).maxY - cropRect.minY
            let width = cropRect.size.width
            cropRect.size = CGSize(width: width, height: cappedHeight)
        }

        return cropRect
    }

    private func automaticZoomIfEdgeTouched(_ cropRect: CGRect) {
        if cropRect.minX < editingRect.minX - 5.0 ||
            cropRect.maxX > editingRect.maxX + 5.0 ||
            cropRect.minY < editingRect.minY - 5.0 ||
            cropRect.maxY > editingRect.maxY + 5.0 {
                UIView.animate(withDuration: 1.0, delay: 0.0, options: .beginFromCurrentState, animations: { [unowned self] in
                    self.zoomToCropRect(self.cropRectView.frame)
                    }, completion: nil)
        }
    }

    private func setCropAspectRatio(_ ratio: CGFloat, shouldCenter: Bool) {
        var cropRect = scrollView.frame
        var width = cropRect.width
        var height = cropRect.height
        if ratio <= 1.0 {
            width = height * ratio
            if width > imageView.bounds.width {
                width = cropRect.width
                height = width / ratio
            }
        } else {
            height = width / ratio
            if height > imageView.bounds.height {
                height = cropRect.height
                width = height * ratio
            }
        }
        cropRect.size = CGSize(width: width, height: height)
        zoomToCropRect(cropRect, shouldCenter: shouldCenter, animated: false) {
            let scale = self.scrollView.zoomScale
            self.scrollView.minimumZoomScale = scale
        }
    }
}

extension CropView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomingView
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let contentOffset = scrollView.contentOffset
        targetContentOffset.pointee = contentOffset
    }
}

extension CropView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension CropView: CropRectViewDelegate {
    func cropRectViewDidBeginEditing(_ view: CropRectView) {
        resizing = true
    }

    func cropRectViewDidChange(_ view: CropRectView) {
        let cropRect = cappedCropRectInImageRectWithCropRectView(view)
        layoutCropRectViewWithCropRect(cropRect)
        automaticZoomIfEdgeTouched(cropRect)
    }

    func cropRectViewDidEndEditing(_ view: CropRectView) {
        resizing = false
        zoomToCropRect(cropRectView.frame)
    }
}

extension CropView {
    struct Props: Mutable {
        var image: UIImage

        static var `default` = Props(image: UIImage())
    }
}
