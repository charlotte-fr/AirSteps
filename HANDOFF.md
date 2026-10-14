# AirSteps handoff — continue on the Mac

Context: a cloud session built this repo without Xcode. Your job is to take it the rest of the way to the App Store from this MacBook. Work in this order and stop only when something needs me (Charlotte) to tap something on the phone or in a browser; say exactly what, then continue once I confirm.

## What the project is
A SwiftUI iOS app plus a WidgetKit `systemSmall` widget that shows today's steps from a **Fitbit Air**. Data path: Fitbit Air → Google Health app → Apple Health → this app/widget via HealthKit, restricted to the Google Health / Fitbit source so iPhone motion steps never mix in. Tap on the widget opens `airsteps://sync`, which opens Google Health to force a Fitbit sync. A vector-drawn bird changes mood with goal progress. No servers, no packages.

Layout:
- `Shared/` — code in both targets: `HealthReader.swift`, `SnapshotStore.swift` (App Group `group.com.axitetech.airsteps`), `StepSnapshot.swift`, `BirdView.swift`, `StepsCardView.swift`, `Theme.swift`
- `AirSteps/` — app target, bundle id `com.axitetech.AirSteps`
- `AirStepsWidget/` — widget extension, bundle id `com.axitetech.AirSteps.widget`
- `AirSteps.xcodeproj` — hand-generated, never opened in Xcode yet. `project.yml` is an XcodeGen spec you can regenerate from if the pbxproj is broken (`brew install xcodegen && xcodegen`).
- `docs/` — privacy page, support page, icon, `app-store-listing.md` with all App Store Connect text and a checklist
- `.github/workflows/pages.yml` — deploys `docs/` to GitHub Pages

## Step 1 — GitHub Pages (the cloud session could not do this)
Repo `charlotte-fr/AirSteps` is private. The Pages API was blocked through the cloud proxy and the workflow failed with "Create Pages site failed: Resource not accessible by integration". From here, `gh` is fully authenticated, so:
```
gh api -X POST repos/charlotte-fr/AirSteps/pages -f build_type=workflow
gh workflow run pages.yml --repo charlotte-fr/AirSteps
```
Then confirm https://charlotte-fr.github.io/AirSteps/privacy.html returns 200. If the POST says Pages needs a paid plan for private repos, tell me; options are making the repo public or hosting `docs/` elsewhere. Do not change repo visibility without asking me.

## Step 2 — Build
```
git clone https://github.com/charlotte-fr/AirSteps.git && cd AirSteps
open AirSteps.xcodeproj
```
- Expect compile errors; the code was never compiled. Fix them minimally, keeping the design and behavior.
- Build with `xcodebuild -scheme AirSteps -destination 'generic/platform=iOS' -allowProvisioningUpdates build` once signing is set.
- Signing: I have a paid Apple Developer Program account. Set my team on both targets (automatic signing). Register the App Group `group.com.axitetech.airsteps` and the HealthKit capability on both targets if Xcode asks. If the bundle id is taken, change it everywhere it appears (both targets, `project.yml`, the listing doc) and tell me.
- Check the SwiftUI previews in `StepsCardView.swift` and `AirStepsWidget.swift` render; the widget face should look soft and cute: pastel gradient, round bird on a branch, big rounded number, heart-tipped progress pill.

## Step 3 — Run on my iPhone (needs me)
Ask me to plug in the phone. Run the app. Then I will: trust the developer profile, enable Google Health → Apple Health steps sync (Profile → Partner apps → Apple Health), tap Allow Apple Health in the app, and add the small widget. Verify together that:
- the source picker lists Google Health / Fitbit and it is auto-selected
- the widget shows the same number as Google Health after a sync
- tapping the widget opens Google Health
- measure how long Google Health takes to write new steps into Apple Health; note it in the README under accuracy

## Step 4 — Ship
- In App Store Connect create the app "AirSteps" (check the name is free), category Health & Fitness, with the text from `docs/app-store-listing.md`. Privacy answer: Data Not Collected. Privacy URL and support URL are the GitHub Pages URLs from step 1.
- Screenshots: take 6.7" screenshots of the Home Screen widget in happy and goal states plus the app's main screen, as listed in the listing doc.
- Archive (Product → Archive, or `xcodebuild archive` + `xcodebuild -exportArchive`) and upload to TestFlight. Have me install via TestFlight.
- Submit for review with the App Review notes from the listing doc.

## Conventions
- Commit as you go on `main`, small commits, plain messages. Push after each milestone.
- Keep it lightweight: no third-party dependencies, no analytics, no network code. HealthKit read of step count only.
- Keep the widget `systemSmall` only.
