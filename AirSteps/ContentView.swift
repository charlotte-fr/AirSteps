import SwiftUI
import HealthKit

struct ContentView: View {
    @EnvironmentObject private var model: AppModel

    private let goals = [5_000, 6_000, 8_000, 10_000, 12_000]

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    header
                    widgetPreview
                    goalPicker
                    sourcePicker
                    setupCard
                }
                .padding(20)
            }
        }
        .task { await model.refresh() }
    }

    // MARK: sections

    private var header: some View {
        VStack(spacing: 6) {
            BirdView(mood: model.snapshot.mood, size: 110)
                .padding(.top, 12)
            Text("AirSteps")
                .font(.cute(30, .heavy))
                .foregroundStyle(Theme.ink)
            Text("your Fitbit Air steps, with a little friend")
                .font(.cute(14, .semibold))
                .foregroundStyle(Theme.muted)
        }
    }

    private var widgetPreview: some View {
        VStack(spacing: 10) {
            StepsCardView(snapshot: model.snapshot)
                .padding(14)
                .frame(width: 158, height: 158)
                .background(Theme.background)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .shadow(color: .black.opacity(0.08), radius: 14, y: 6)

            if model.snapshot.status == .ok {
                Text("synced \(model.snapshot.updatedAt, style: .relative) ago")
                    .font(.cute(12, .semibold))
                    .foregroundStyle(Theme.muted)
            }

            Button {
                model.openGoogleHealth()
            } label: {
                Label("Sync now in Google Health", systemImage: "arrow.triangle.2.circlepath")
                    .font(.cute(15, .bold))
                    .padding(.horizontal, 18)
                    .padding(.vertical, 12)
                    .background(Theme.card, in: Capsule())
                    .foregroundStyle(Theme.ink)
            }
        }
    }

    private var goalPicker: some View {
        card("daily goal") {
            VStack(spacing: 12) {
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text(model.goal.grouped)
                        .font(.cute(34, .heavy))
                        .foregroundStyle(Theme.ink)
                        .contentTransition(.numericText())
                    Text("steps")
                        .font(.cute(14, .bold))
                        .foregroundStyle(Theme.muted)
                }

                HStack(spacing: 10) {
                    roundButton("minus") { model.setGoal(max(Self.minGoal, model.goal - Self.goalStep)) }
                    Slider(value: goalBinding, in: Double(Self.minGoal)...Double(Self.maxGoal), step: Double(Self.goalStep))
                        .tint(Theme.progressStart)
                    roundButton("plus") { model.setGoal(min(Self.maxGoal, model.goal + Self.goalStep)) }
                }

                HStack(spacing: 8) {
                    ForEach(goals, id: \.self) { g in
                        Button {
                            model.setGoal(g)
                        } label: {
                            Text(g.short)
                                .font(.cute(13, .heavy))
                                .padding(.horizontal, 11)
                                .padding(.vertical, 7)
                                .background(model.goal == g ? Theme.progressStart : .white.opacity(0.6),
                                            in: Capsule())
                                .foregroundStyle(model.goal == g ? .white : Theme.ink)
                        }
                    }
                }

                Text("Anything from \(Self.minGoal.grouped) to \(Self.maxGoal.grouped) steps a day.")
                    .font(.cute(11, .semibold))
                    .foregroundStyle(Theme.muted)
            }
            .frame(maxWidth: .infinity)
            .animation(.snappy, value: model.goal)
        }
    }

    private static let minGoal = 100
    private static let maxGoal = 50_000
    private static let goalStep = 100

    private var goalBinding: Binding<Double> {
        Binding(get: { Double(model.goal) },
                set: { model.setGoal(Int($0.rounded())) })
    }

    private func roundButton(_ symbol: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 13, weight: .heavy))
                .foregroundStyle(Theme.ink)
                .frame(width: 32, height: 32)
                .background(.white.opacity(0.6), in: Circle())
        }
    }

    @ViewBuilder private var sourcePicker: some View {
        card("step source") {
            if !model.healthGranted {
                Button {
                    Task { await model.requestHealth() }
                } label: {
                    Label("Allow Apple Health", systemImage: "heart.fill")
                        .font(.cute(15, .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Theme.progressStart, in: Capsule())
                        .foregroundStyle(.white)
                }
            } else if model.sources.isEmpty {
                Text("No step sources in Apple Health yet. Turn on the Google Health → Apple Health sync below, then come back.")
                    .font(.cute(13, .semibold))
                    .foregroundStyle(Theme.muted)
            } else {
                VStack(spacing: 6) {
                    ForEach(model.sources, id: \.bundleIdentifier) { src in
                        Button { model.select(source: src) } label: {
                            HStack {
                                Image(systemName: src.bundleIdentifier == model.selectedSourceID
                                      ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(Theme.progressStart)
                                Text(src.name).font(.cute(14, .bold)).foregroundStyle(Theme.ink)
                                Spacer()
                                if HealthReader.looksLikeFitbit(src) {
                                    Text("Fitbit").font(.cute(11, .heavy))
                                        .padding(.horizontal, 8).padding(.vertical, 3)
                                        .background(Theme.mint, in: Capsule())
                                        .foregroundStyle(Theme.ink)
                                }
                            }
                            .padding(.vertical, 6)
                        }
                    }
                    Text("Only the selected source is counted, so your iPhone's own motion steps never mix in.")
                        .font(.cute(11, .semibold))
                        .foregroundStyle(Theme.muted)
                        .padding(.top, 4)
                }
            }
        }
    }

    private var setupCard: some View {
        card("set up once") {
            VStack(alignment: .leading, spacing: 10) {
                step(1, "In Google Health: Profile → Partner apps → Apple Health. Turn on Steps.")
                step(2, "Tap Allow Apple Health above and allow Steps.")
                step(3, "Long-press your Home Screen → + → AirSteps → add the small widget.")
                step(4, "Tap the widget any time to force a Fitbit sync.")
            }
        }
    }

    // MARK: helpers

    private func card<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.cute(13, .heavy))
                .foregroundStyle(Theme.muted)
                .textCase(.lowercase)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private func step(_ n: Int, _ text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text("\(n)")
                .font(.cute(12, .heavy))
                .frame(width: 22, height: 22)
                .background(Theme.peach, in: Circle())
                .foregroundStyle(Theme.ink)
            Text(text)
                .font(.cute(13, .semibold))
                .foregroundStyle(Theme.ink)
        }
    }
}

#Preview {
    ContentView().environmentObject(AppModel())
}
