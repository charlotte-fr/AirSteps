# AirSteps

A small, cute iOS Home Screen widget (2×2, four tiles) that shows today's
steps from your **Fitbit Air**, with a little bird who gets happier as you walk.

No servers, no login, no third-party code. The widget reads the steps that the
Google Health app writes into Apple Health, and counts **only** that source,
so your iPhone's own motion steps are never mixed in.

## How the data flows

```
Fitbit Air  ──Bluetooth──▶  Google Health app  ──▶  Apple Health  ──▶  AirSteps widget
            (every ~15 min, or instantly when Google Health is opened)
```

Accuracy: the number is exactly the Fitbit Air's own count. Freshness: the
Fitbit Air syncs to Google Health in the background every 15–30 minutes, so the
widget is usually that far behind. Tapping the widget opens Google Health, which
forces an immediate sync; measured on an iPhone 14 with iOS 27, the new count
appeared in Apple Health and in the widget within a minute of that sync.

## Setup

1. Open `AirSteps.xcodeproj` in Xcode 15 or newer.
2. Select the **AirSteps** target → *Signing & Capabilities* → pick your team.
   Do the same for **AirStepsWidgetExtension**. Both targets already declare
   HealthKit and the App Group `group.nl.studiocobalt.airsteps`. If Xcode asks to
   register the App Group with your team, say yes. If you change the bundle id,
   change the App Group id in both `.entitlements` files and in
   `Shared/SnapshotStore.swift`.
3. Run on a real iPhone (HealthKit data is not available in the Simulator).
4. In the **Google Health** app: Profile → Partner apps → Apple Health → turn on
   **Steps**.
5. In AirSteps, tap **Allow Apple Health** and pick the Google Health / Fitbit
   source if it isn't auto-selected.
6. Long-press the Home Screen → **+** → AirSteps → add the small widget.

## Project layout

| Path | What |
|---|---|
| `Shared/` | Code compiled into both the app and the widget: HealthKit reader, App Group store, bird + widget face views, theme |
| `AirSteps/` | The companion app: permissions, goal, source picker, widget preview |
| `AirStepsWidget/` | The WidgetKit extension (`systemSmall` only) |
| `project.yml` | XcodeGen spec; `xcodegen` regenerates the `.xcodeproj` if you add files |

## Why not live counting?

The Fitbit Air only streams per-step data to Google's own app over an
encrypted Bluetooth link, and iOS Home Screen widgets cannot run code between
refreshes. This widget is the most direct path available to a third-party app.
