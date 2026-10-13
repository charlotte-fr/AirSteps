import SwiftUI

/// A round little bird, drawn entirely with shapes so it stays crisp at any size.
struct BirdView: View {
    var mood: BirdMood = .happy
    var size: CGFloat = 60

    var body: some View {
        ZStack {
            // sparkles when the goal is reached
            if mood == .party {
                sparkle(at: CGPoint(x: -0.62, y: -0.55), scale: 0.22)
                sparkle(at: CGPoint(x: 0.66, y: -0.40), scale: 0.18)
                sparkle(at: CGPoint(x: 0.58, y: 0.30), scale: 0.13)
            }

            // zzz when sleepy
            if mood == .sleepy {
                Text("z")
                    .font(.cute(size * 0.22, .heavy))
                    .foregroundStyle(Theme.muted)
                    .offset(x: size * 0.52, y: -size * 0.48)
                Text("z")
                    .font(.cute(size * 0.15, .heavy))
                    .foregroundStyle(Theme.muted.opacity(0.7))
                    .offset(x: size * 0.66, y: -size * 0.64)
            }

            // tuft
            ForEach([-22.0, 0.0, 22.0], id: \.self) { angle in
                Capsule()
                    .fill(Theme.birdWing)
                    .frame(width: size * 0.07, height: size * 0.2)
                    .rotationEffect(.degrees(angle))
                    .offset(x: size * 0.012 * angle / 10, y: -size * 0.50)
            }

            // feet
            ForEach([-1.0, 1.0], id: \.self) { side in
                Capsule()
                    .fill(Theme.beak)
                    .frame(width: size * 0.16, height: size * 0.06)
                    .offset(x: side * size * 0.13, y: size * 0.50)
            }

            // body
            Circle()
                .fill(Theme.birdBody)
                .frame(width: size, height: size)

            // belly
            Ellipse()
                .fill(Theme.birdBelly)
                .frame(width: size * 0.60, height: size * 0.48)
                .offset(y: size * 0.20)

            // wing
            Ellipse()
                .fill(Theme.birdWing)
                .frame(width: size * 0.26, height: size * 0.40)
                .rotationEffect(.degrees(mood == .party ? -55 : -22))
                .offset(x: -size * 0.36, y: size * (mood == .party ? -0.02 : 0.10))

            // cheeks
            ForEach([-1.0, 1.0], id: \.self) { side in
                Circle()
                    .fill(Theme.blush.opacity(mood == .party ? 0.95 : 0.7))
                    .frame(width: size * 0.13, height: size * 0.13)
                    .offset(x: side * size * 0.28, y: size * 0.04)
            }

            // eyes
            ForEach([-1.0, 1.0], id: \.self) { side in
                eye.offset(x: side * size * 0.17, y: -size * 0.11)
            }

            // beak
            Triangle()
                .fill(Theme.beak)
                .frame(width: size * 0.15, height: size * 0.10)
                .offset(y: size * 0.03)
        }
        .frame(width: size * 1.5, height: size * 1.4)
    }

    @ViewBuilder private var eye: some View {
        switch mood {
        case .sleepy:
            Capsule()
                .fill(Theme.eye)
                .frame(width: size * 0.12, height: size * 0.035)
        case .happy, .party:
            ZStack(alignment: .topLeading) {
                Circle()
                    .fill(Theme.eye)
                    .frame(width: size * 0.11, height: size * 0.11)
                Circle()
                    .fill(.white)
                    .frame(width: size * 0.04, height: size * 0.04)
                    .offset(x: size * 0.02, y: size * 0.015)
            }
        }
    }

    private func sparkle(at p: CGPoint, scale: CGFloat) -> some View {
        Image(systemName: "sparkle")
            .font(.system(size: size * scale, weight: .bold))
            .foregroundStyle(Theme.sparkle)
            .offset(x: size * p.x, y: size * p.y)
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}
