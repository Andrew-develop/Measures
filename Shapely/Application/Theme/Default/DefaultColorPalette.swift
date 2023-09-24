import UIKit

struct DefaultColorPalette: ColorPalette {
    private init() {}

    static var background: UIColor = R.color.background()!
    static var surface: UIColor = R.color.surface()!
    static var surfaceSecondary: UIColor = R.color.surfaceSecondary()!
    static var button: UIColor = R.color.button()!
    static var text: UIColor = R.color.text()!
    static var textSecondary: UIColor = R.color.textSecondary()!
    static var border: UIColor = R.color.border()!
}
