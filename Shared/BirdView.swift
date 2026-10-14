import SwiftUI

/// The mascot. The artwork lives in `Shared/BirdArt.xcassets` as three
/// illustrations, one per mood, cut from a single generated sticker sheet so
/// the character stays identical and only the expression changes.
struct BirdView: View {
    var mood: BirdMood = .happy
    var size: CGFloat = 60   // approximate body width in points

    var body: some View {
        BirdArt.load(mood.assetName)
            .resizable()
            .interpolation(.high)
            .scaledToFit()
            // the illustrations sit on a square canvas about 1.35x the body width
            .frame(width: size * 1.35, height: size * 1.35)
            .accessibilityHidden(true)
    }
}

enum BirdArt {
    /// How the artwork is loaded. Overridable so design tooling outside the
    /// app bundle can supply the same PNGs from disk.
    static var load: (String) -> Image = { Image($0) }
}

extension BirdMood {
    var assetName: String {
        switch self {
        case .sleepy: return "BirdSleepy"
        case .happy:  return "BirdHappy"
        case .party:  return "BirdParty"
        }
    }
}
