public struct DefaultTheme: Theme {
    private init() {}

    public static let colorPalette: ColorPalette.Type = DefaultColorPalette.self
    public static let typography: Typography.Type = DefaultTypography.self
}
