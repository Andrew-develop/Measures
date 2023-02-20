import UIKit

struct DefaultTypography: Typography {
    private init() {}

    static var header1: UIFont = R.font.interBold(size: 32.0)!
    static var header2: UIFont = R.font.interBold(size: 24.0)!

    static var body1: UIFont = R.font.interBold(size: 16.0)!
    static var body2: UIFont = R.font.interRegular(size: 16.0)!

    static var title3: UIFont = R.font.interBold(size: 32.0)!
    static var title4: UIFont = R.font.interRegular(size: 24.0)!

    static var footnote: UIFont = R.font.interRegular(size: 12.0)!
}
