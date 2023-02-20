import UIKit

/**
 Typography with fonts from the MaterialDesign
 https://material.io/design/typography/
 */

public protocol Typography {
    static var header1: UIFont { get }
    static var header2: UIFont { get }

    static var body1: UIFont { get }
    static var body2: UIFont { get }

    static var title3: UIFont { get }
    static var title4: UIFont { get }

    static var footnote: UIFont { get }
}
