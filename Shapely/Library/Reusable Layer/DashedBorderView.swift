//
//  DashedBorderView.swift
//  Shapely
//
//  Created by Andrew on 10.03.2023.
//

import UIKit

final class DashedBorderView: UIView {
    private let borderLayer = CAShapeLayer()

    override func draw(_ rect: CGRect) {
        borderLayer.strokeColor = DefaultColorPalette.surfaceSecondary.cgColor
        borderLayer.lineWidth = 1
        borderLayer.fillColor = nil
        borderLayer.lineDashPattern = [4, 4]
        borderLayer.frame = rect
        borderLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: Grid.s.offset).cgPath
        layer.addSublayer(borderLayer)
    }
}
