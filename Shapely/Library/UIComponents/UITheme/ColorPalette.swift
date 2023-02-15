import UIKit

/**
 Color palette with colors from the baseline MaterialDesign theme
 https://material.io/design/color/
 */

public protocol ColorPalette {
    static var background: UIColor { get }
    static var surface: UIColor { get }
    static var surfaceSecondary: UIColor { get }
    static var button: UIColor { get }
    static var text: UIColor { get }
    static var textSecondary: UIColor { get }
}
