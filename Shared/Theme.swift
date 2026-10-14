import SwiftUI

/// Soft, Finch-style pastel palette. Everything is vector, no image assets.
enum Theme {
    static let cream    = Color(hex: 0xFFF7EC)
    static let peach    = Color(hex: 0xFFDCC8)
    static let sky      = Color(hex: 0xDCEBFA)
    static let mint     = Color(hex: 0xD7F2E3)
    static let lavender = Color(hex: 0xE9E3F9)

    static let ink      = Color(hex: 0x4A3F3A)
    static let muted    = Color(hex: 0x9A8C86)
    static let card     = Color.white.opacity(0.72)
    static let track    = Color(hex: 0xF3E6D9)

    static let birdBody = Color(hex: 0xFFC98C)
    static let birdBodyLight = Color(hex: 0xFFDBAE)
    static let birdWing = Color(hex: 0xF4B16A)
    static let birdBelly = Color(hex: 0xFFF2DA)
    static let beak     = Color(hex: 0xFF9A5C)
    static let blush    = Color(hex: 0xFFB1C4)
    static let eye      = Color(hex: 0x3B2F2F)
    static let branch   = Color(hex: 0xCBA57F)
    static let sparkle  = Color(hex: 0xFFC94D)

    static let progressStart = Color(hex: 0xFF9D7E)
    static let progressEnd   = Color(hex: 0xFFC56B)

    static var background: LinearGradient {
        LinearGradient(colors: [sky, cream, peach],
                       startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    static var progress: LinearGradient {
        LinearGradient(colors: [progressStart, progressEnd],
                       startPoint: .leading, endPoint: .trailing)
    }
}

extension Color {
    init(hex: UInt32) {
        self.init(red:   Double((hex >> 16) & 0xFF) / 255,
                  green: Double((hex >> 8)  & 0xFF) / 255,
                  blue:  Double(hex & 0xFF) / 255)
    }
}

extension Font {
    static func cute(_ size: CGFloat, _ weight: Font.Weight = .bold) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }
}

extension Int {
    var grouped: String {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f.string(from: NSNumber(value: self)) ?? "\(self)"
    }

    /// 8000 -> "8k", 12500 -> "12.5k"
    var short: String {
        guard self >= 1000 else { return "\(self)" }
        let k = Double(self) / 1000
        return k == k.rounded() ? "\(Int(k))k" : String(format: "%.1fk", k)
    }
}
