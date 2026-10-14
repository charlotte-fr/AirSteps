import SwiftUI

/// The 2x2 widget face. Also reused inside the app as a live preview.
struct StepsCardView: View {
    let snapshot: StepSnapshot

    var body: some View {
        ZStack {
            clouds

            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    ZStack(alignment: .bottom) {
                        Capsule()
                            .fill(Theme.branch)
                            .frame(width: 58, height: 6)
                            .offset(y: 2)
                        BirdView(mood: snapshot.mood, size: 46)
                    }
                    .frame(width: 70, height: 64, alignment: .bottom)

                    Spacer(minLength: 2)

                    Text(snapshot.message)
                        .font(.cute(9.5, .heavy))
                        .foregroundStyle(Theme.ink)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .minimumScaleFactor(0.8)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 5)
                        .background(Theme.card, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .padding(.top, 2)
                }

                Spacer(minLength: 2)

                Text(snapshot.status == .ok ? snapshot.steps.grouped : "–")
                    .font(.cute(32, .heavy))
                    .foregroundStyle(Theme.ink)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .contentTransition(.numericText())

                Text(subtitle)
                    .font(.cute(10, .bold))
                    .foregroundStyle(Theme.muted)
                    .padding(.bottom, 6)

                ProgressPill(progress: snapshot.progress, celebrate: snapshot.reachedGoal)
            }
        }
    }

    private var subtitle: String {
        switch snapshot.status {
        case .ok:              return "steps · goal \(snapshot.goal.short)"
        case .noSource:        return "open app to set up"
        case .needsPermission: return "tap to allow Health"
        }
    }

    private var clouds: some View {
        ZStack {
            Capsule().fill(.white.opacity(0.55)).frame(width: 46, height: 14).offset(x: 46, y: -58)
            Capsule().fill(.white.opacity(0.40)).frame(width: 30, height: 10).offset(x: 62, y: -44)
            Capsule().fill(.white.opacity(0.35)).frame(width: 36, height: 11).offset(x: -52, y: 62)
        }
    }
}

struct ProgressPill: View {
    let progress: Double
    let celebrate: Bool

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Theme.track)
                Capsule()
                    .fill(Theme.progress)
                    .frame(width: max(geo.size.width * progress, progress > 0 ? 12 : 0))
                Image(systemName: celebrate ? "heart.fill" : "heart")
                    .font(.system(size: 9, weight: .heavy))
                    .foregroundStyle(celebrate ? Theme.progressStart : Theme.muted.opacity(0.6))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 4)
            }
        }
        .frame(height: 12)
    }
}

#Preview("widget face") {
    StepsCardView(snapshot: .sample)
        .padding(14)
        .frame(width: 158, height: 158)
        .background(Theme.background)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
}
