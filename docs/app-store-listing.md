# App Store listing — AirSteps

Paste these into App Store Connect. Character limits are Apple's.

## Name (30 max)
AirSteps

## Subtitle (30 max)
Cute Fitbit Air step widget

## Promotional text (170 max, editable without a new build)
A little bird on your Home Screen that shows your Fitbit Air steps. Sleepy in the morning, sparkly when you hit your goal.

## Description (4000 max)
AirSteps puts your Fitbit Air step count on your Home Screen, with a tiny bird who gets happier the more you walk.

It is small on purpose: one 2×2 widget, one number, one friend.

HOW IT WORKS
Your Fitbit Air syncs to the Google Health app. Google Health can share your steps with Apple Health. AirSteps reads only that Fitbit source from Apple Health and shows it in the widget. Your iPhone's own motion steps are never mixed in, so the number you see is your Fitbit's number.

THE BIRD
• Sleepy and snoozing when the day is young
• Bright-eyed and cheering once you're on your way
• Blushing with sparkles when you reach your goal

FEATURES
• 2×2 Home Screen widget with your steps and a soft progress bar
• Daily goal: 5k, 6k, 8k, 10k or 12k
• Tap the widget to open Google Health and sync your Fitbit right away
• Pick exactly which Apple Health source counts
• No account, no servers, no ads, no tracking. Everything stays on your phone.

GOOD TO KNOW
Fitbit trackers sync in the background every 15 to 20 minutes, so the widget shows the latest synced count rather than a live ticker. Tapping the widget forces an immediate sync.

SETUP
1. In Google Health: Profile → Partner apps → Apple Health → turn on Steps.
2. In AirSteps: Allow Apple Health.
3. Add the AirSteps widget to your Home Screen.

AirSteps is an independent app and is not affiliated with Google or Fitbit. Fitbit is a trademark of Google LLC.

## Keywords (100 max, comma separated, no spaces after commas)
steps,pedometer,widget,fitbit,step counter,walking,cute,health,daily goal,bird

## What's New (first release)
First flight. A cute bird, your Fitbit Air steps, one small widget.

## Support URL
https://charlotte-fr.github.io/AirSteps/

## Privacy Policy URL
https://charlotte-fr.github.io/AirSteps/privacy.html
(Enable GitHub Pages for the `docs/` folder on the main branch, or host the page anywhere you like.)

## Category
Primary: Health & Fitness
Secondary: Lifestyle

## Age rating
4+ (no objectionable content)

## App Privacy questionnaire (the "nutrition label")
Answer: **Data Not Collected.**
Reasoning for each category Apple asks about:
- Health & Fitness: read on device only, never leaves the device, not linked to identity, not used for tracking → counts as not collected under Apple's definition.
- Identifiers, Usage Data, Diagnostics, Contact Info, Location: none.

## App Review notes (paste into "Notes" in the review information section)
AirSteps displays the user's daily step count from Apple Health in a Home Screen widget. It reads one HealthKit type (step count) and nothing else. Health data never leaves the device; the app has no network code.

To test: the widget reads steps written to Apple Health by the Google Health app. On a device without a Fitbit, you can select any step source (for example the iPhone itself) in the app's "step source" list to see the widget populate. A sample state is shown in the widget gallery preview.

The app contains a companion screen for permissions, goal selection and source selection, plus the widget itself.

## Screenshots to take (6.7" iPhone, required)
1. Home Screen with the widget among other apps, bird happy mid-day.
2. Widget close-up at goal with sparkles.
3. The app's main screen with the preview card and goal chips.
4. Widget in the sleepy morning state.
Caption ideas: "Your Fitbit Air steps, with a friend" · "Sparkles when you hit your goal" · "Nothing leaves your phone"

## Pre-submission checklist
- [ ] Apple Developer Program membership active
- [ ] Bundle id `com.axitetech.AirSteps` registered (Xcode does this with automatic signing)
- [ ] App Group `group.com.axitetech.airsteps` registered to your team
- [ ] Privacy policy URL live
- [ ] Replace CONTACT_EMAIL in `docs/privacy.html`
- [ ] Check "AirSteps" is still an available app name in App Store Connect
- [ ] Archive in Xcode → Distribute → App Store Connect → upload
- [ ] TestFlight on your own phone for a few days first
