import SwiftUI

/// The 2x2 widget face: a ring that fills up over the day with the bird
/// sitting inside it, and the step count underneath. Also reused inside the
/// app as a live preview.
struct StepsCardView: View {
    let snapshot: StepSnapshot

    var body: some View {
        ZStack {
            clouds

            VStack(spacing: 0) {
                ZStack {
                    ProgressRing(progress: snapshot.progress, celebrate: snapshot.reachedGoal)
                    BirdView(mood: snapshot.mood, size: 44)
                        .offset(y: 2)
                }
                .frame(width: 88, height: 88)

                Spacer(minLength: 0)

                Text(snapshot.status == .ok ? snapshot.steps.grouped : "–")
                    .font(.cute(24, .heavy))
                    .foregroundStyle(Theme.ink)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .contentTransition(.numericText())

                Text(subtitle)
                    .font(.cute(9.5, .bold))
                    .foregroundStyle(Theme.muted)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
    }

    private var subtitle: String {
        switch snapshot.status {
        case .ok:              return "goal \(snapshot.goal.short)"
        case .noSource:        return "open app to set up"
        case .needsPermission: return "tap to allow Health"
        }
    }

    private var clouds: some View {
        ZStack {
            Capsule().fill(.white.opacity(0.55)).frame(width: 40, height: 12).offset(x: 50, y: -56)
            Capsule().fill(.white.opacity(0.40)).frame(width: 26, height: 9).offset(x: 60, y: -44)
            Capsule().fill(.white.opacity(0.35)).frame(width: 30, height: 10).offset(x: -56, y: -30)
        }
    }
}

/// A soft ring that fills clockwise from the top, with a little heart riding
/// on the tip of the progress arc. The heart fills in when the goal is reached.
struct ProgressRing: View {
    let progress: Double
    let celebrate: Bool
    var lineWidth: CGFloat = 9

    var body: some View {
        GeometryReader { geo in
            let d = min(geo.size.width, geo.size.height)
            let radius = d / 2 - lineWidth / 2
            let angle = -Double.pi / 2 + 2 * Double.pi * progress
            let tip = CGPoint(x: geo.size.width / 2 + radius * cos(angle),
                              y: geo.size.height / 2 + radius * sin(angle))

            ZStack {
                Circle()
                    .stroke(Theme.track, lineWidth: lineWidth)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(AngularGradient(colors: [Theme.progressStart, Theme.progressEnd],
                                            center: .center),
                            style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .rotationEffect(.degrees(-90))

                Image(systemName: celebrate ? "heart.fill" : "heart")
                    .font(.system(size: lineWidth * 1.15, weight: .heavy))
                    .foregroundStyle(celebrate ? Theme.progressStart : Theme.muted.opacity(0.7))
                    .padding(3)
                    .background(Theme.cream, in: Circle())
                    .position(tip)
            }
        }
    }
}

#Preview("widget face") {
    StepsCardView(snapshot: .sample)
        .padding(14)
        .frame(width: 158, height: 158)
        .background(Theme.background)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
}
