import CoreGraphics

/**
 Grid is a group of size items which represents the offsets that are recommended to use between elements and screen edges. Based on the [8-point grid methodology](https://spec.fm/specifics/8-pt-grid)
 */
public enum Grid: CaseIterable {
    // swiftlint:disable identifier_name
    case zero, xs, s, sm, m, ml, l, xl, xxl, xxxl
    // swiftlint:enable identifier_name

    /// Minimal recommended size between elements.
    static let baseModuleSize = 8.0

    /// Offset corresponding for each size item. Calculation is based on base module size.
    public var offset: CGFloat {
        switch self {
        case .zero:
            return 0.0
        case .xs:
            return CGFloat(Grid.baseModuleSize)
        case .s:
            return CGFloat(Grid.baseModuleSize * 2)
        case .sm:
            return CGFloat(Grid.baseModuleSize * 3)
        case .m:
            return CGFloat(Grid.baseModuleSize * 4)
        case .ml:
            return CGFloat(Grid.baseModuleSize * 5)
        case .l:
            return CGFloat(Grid.baseModuleSize * 6)
        case .xl:
            return CGFloat(Grid.baseModuleSize * 7)
        case .xxl:
            return CGFloat(Grid.baseModuleSize * 8)
        case .xxxl:
            return CGFloat(Grid.baseModuleSize * 15)
        }
    }
}
