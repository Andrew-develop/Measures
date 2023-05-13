//
//  AddPhotoViewController+Recognizers.swift
//  Shapely
//
//  Created by Andrew on 13.05.2023.
//

import UIKit

extension AddPhotoViewController: UIGestureRecognizerDelegate {
    /**
     UIPanGestureRecognizer - Moving Objects
     Selecting transparent parts of the imageview won't move the object
     */
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        if let view = recognizer.view {
            if view is UIImageView {
                // Tap only on visible parts on the image
                if recognizer.state == .began {
                    for imageView in subImageViews(view: canvasView) {
                        let location = recognizer.location(in: imageView)
                        let alpha = imageView.alphaAtPoint(location)
                        if alpha > 0 {
                            imageViewToPan = imageView
                            break
                        }
                    }
                }
                if imageViewToPan != nil {
                    moveView(view: imageViewToPan!, recognizer: recognizer)
                }
            } else {
                moveView(view: view, recognizer: recognizer)
            }
        }
    }
    /**
     UIPinchGestureRecognizer - Pinching Objects
     If it's a UITextView will make the font bigger so it doen't look pixlated
     */
    @objc func pinchGesture(_ recognizer: UIPinchGestureRecognizer) {
        if let recView = recognizer.view, let textView = recView as? UITextView {
            if textView.font!.pointSize * recognizer.scale < 90 {
                let font = UIFont(name: textView.font!.fontName, size: textView.font!.pointSize * recognizer.scale)
                textView.font = font
                let sizeToFit = textView.sizeThatFits(CGSize(width: UIScreen.main.bounds.size.width,
                                                             height: CGFloat.greatestFiniteMagnitude))
                textView.bounds.size = CGSize(width: textView.intrinsicContentSize.width,
                                              height: sizeToFit.height)
            } else {
                let sizeToFit = textView.sizeThatFits(CGSize(width: UIScreen.main.bounds.size.width,
                                                             height: CGFloat.greatestFiniteMagnitude))
                textView.bounds.size = CGSize(width: textView.intrinsicContentSize.width,
                                              height: sizeToFit.height)
            }
            textView.setNeedsDisplay()
        } else {
            view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
        }
        recognizer.scale = 1
    }
    /**
     UIRotationGestureRecognizer - Rotating Objects
     */
    @objc func rotationGesture(_ recognizer: UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
        }
    }
    /**
     UITapGestureRecognizer - Taping on Objects
     Will make scale scale Effect
     Selecting transparent parts of the imageview won't move the object
     */
    @objc func tapGesture(_ recognizer: UITapGestureRecognizer) {
        if let view = recognizer.view {
            if view is UIImageView {
                // Tap only on visible parts on the image
                for imageView in subImageViews(view: canvasView) {
                    let location = recognizer.location(in: imageView)
                    let alpha = imageView.alphaAtPoint(location)
                    if alpha > 0 {
                        scaleEffect(view: imageView)
                        break
                    }
                }
            } else {
                scaleEffect(view: view)
            }
        }
    }
    /*
     Support Multiple Gesture at the same time
     */
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }

//    func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
//        if recognizer.state == .recognized {
//            if !stickersVCIsVisible {
//                addStickersViewController()
//            }
//        }
//    }

    /**
     Scale Effect
     */
    func scaleEffect(view: UIView) {
        view.superview?.bringSubviewToFront(view)

        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
        let previouTransform = view.transform
        UIView.animate(withDuration: 0.2,
                       animations: {
            view.transform = view.transform.scaledBy(x: 1.2, y: 1.2)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2) {
                view.transform = previouTransform
            }
        })
    }
    /**
     Moving Objects
     delete the view if it's inside the delete view
     Snap the view back if it's out of the canvas
     */
    func moveView(view: UIView, recognizer: UIPanGestureRecognizer) {
        view.superview?.bringSubviewToFront(view)
        let pointToSuperView = recognizer.location(in: self.view)

        view.center = CGPoint(x: view.center.x + recognizer.translation(in: canvasView).x,
                              y: view.center.y + recognizer.translation(in: canvasView).y)

        recognizer.setTranslation(CGPoint.zero, in: canvasView)

        if let previousPoint = lastPanPoint {
            // View is going into deleteView
            if deleteView.frame.contains(pointToSuperView) && !deleteView.frame.contains(previousPoint) {
                if #available(iOS 10.0, *) {
                    let generator = UIImpactFeedbackGenerator(style: .heavy)
                    generator.impactOccurred()
                }
                UIView.animate(withDuration: 0.3, animations: {
                    view.transform = view.transform.scaledBy(x: 0.25, y: 0.25)
                    view.center = recognizer.location(in: self.canvasView)
                })
            }
                // View is going out of deleteView
            else if deleteView.frame.contains(previousPoint) && !deleteView.frame.contains(pointToSuperView) {
                // Scale to original Size
                UIView.animate(withDuration: 0.3, animations: {
                    view.transform = view.transform.scaledBy(x: 4, y: 4)
                    view.center = recognizer.location(in: self.canvasView)
                })
            }
        }
        lastPanPoint = pointToSuperView

        if recognizer.state == .ended {
            imageViewToPan = nil
            lastPanPoint = nil
            let point = recognizer.location(in: self.view)

            if deleteView.frame.contains(point) { // Delete the view
                view.removeFromSuperview()
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            } else if !canvasView.bounds.contains(view.center) { // Snap the view back to canvasImageView
                UIView.animate(withDuration: 0.3, animations: {
                    view.center = self.canvasView.center
                })

            }
        }
    }

    func subImageViews(view: UIView) -> [UIImageView] {
        var imageviews: [UIImageView] = []
        view.subviews.forEach {
            if let imView = $0 as? UIImageView {
                imageviews.append(imView)
            }
        }
        return imageviews
    }

    func addGestures(view: UIView) {
        // Gestures
        view.isUserInteractionEnabled = true

        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(AddPhotoViewController.panGesture))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)

        let pinchGesture = UIPinchGestureRecognizer(target: self,
                                                    action: #selector(AddPhotoViewController.pinchGesture))
        pinchGesture.delegate = self
        view.addGestureRecognizer(pinchGesture)

        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self,
                                                           action: #selector(AddPhotoViewController.rotationGesture) )
        rotationGestureRecognizer.delegate = self
        view.addGestureRecognizer(rotationGestureRecognizer)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddPhotoViewController.tapGesture))
        view.addGestureRecognizer(tapGesture)
    }
}
