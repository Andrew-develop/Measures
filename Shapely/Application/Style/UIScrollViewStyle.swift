//
//  UIScrollViewStyle.swift
//  Shapely
//
//  Created by Andrew on 08.05.2023.
//

import UIKit

extension StyleWrapper where Element == UIScrollView {
    static var photoEdit: StyleWrapper {
        return .wrap { scrollView, theme in
            scrollView.autoresizingMask = [
                .flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleRightMargin
            ]
            scrollView.backgroundColor = theme.colorPalette.background
            scrollView.maximumZoomScale = 20.0
            scrollView.minimumZoomScale = 1.0
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.showsVerticalScrollIndicator = false
            scrollView.bounces = false
            scrollView.bouncesZoom = false
            scrollView.clipsToBounds = false
        }
    }
}
