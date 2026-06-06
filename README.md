# Adaptive Training System

A Bachelor's thesis project — an iOS app that reads physiological data from a chest strap in real time and uses it to guide your endurance training through adaptive audio feedback.

Built at Alpen-Adria-Universität Klagenfurt, 2026.

---

## The Problem

Most wearables collect a ton of data during a run, but none of it reaches you when it actually matters — while you're still running. Post-session graphs are nice, but they don't stop you from pushing too hard on a recovery day or sandbagging a threshold session.

Existing real-time systems aren't much better. They rely on fixed heart rate thresholds that don't adapt to how your body is responding in the moment, and they treat every user the same regardless of fitness level or fatigue.

---

## What This App Does

The app connects to a Bluetooth chest strap, streams your heart rate and RR intervals, and continuously evaluates your current physiological state. Based on that, it gives you contextual audio feedback through your headphones — telling you to speed up, slow down, or adjust your route to stay in your target training zone.

The feedback isn't just "go faster". It accounts for where you are in your session, how your HRV is trending, and what kind of training you're actually trying to do. Three feedback strategies are implemented and evaluated against each other:

- **Static** — fixed thresholds, simple rules
- **Context-based** — reacts to short-term HRV changes during the session
- **Personalized** — adapts to individual user characteristics over time

---

## Hardware

- **Polar H10** chest strap (or any BLE device implementing the standard Heart Rate Profile)
- iPhone (iOS 16+)
- AirPods or any headphones for audio feedback

---

## Tech Stack

- **Swift / SwiftUI** — UI and app logic
- **Core Bluetooth** — direct BLE communication, no third-party SDK dependencies
- **AVSpeechSynthesizer** — voice feedback delivered through headphones
- **CoreML** — on-device ML inference for training state classification (in progress)

---

## How It Works

### 1. BLE Connection

The app scans for devices advertising the standard Heart Rate Service (`0x180D`). No proprietary SDK is used — Core Bluetooth communicates directly with any compatible chest strap. When a supported device is found, the app connects automatically.

Supported devices are configured in `Configuration.swift` and matched by name:

```swift
static let supportedDevices: [String] = ["Polar", "Garmin"]
```

### 2. Data Parsing

The chest strap sends raw bytes following the [Bluetooth Heart Rate Profile](https://www.bluetooth.com/specifications/specs/heart-rate-profile-1-0/) specification. The app parses two things:

- **Heart rate** — beats per minute
- **RR intervals** — time between individual heartbeats in milliseconds, the foundation for HRV analysis

### 3. Training Zone Classification

Before a session the user selects a training zone and enters their age. Max heart rate is estimated using `220 - age`. The app maps this to absolute BPM boundaries for the chosen zone.

| Zone | Name | % of Max HR |
|------|------|-------------|
| 1 | Recovery | 50–60% |
| 2 | Endurance | 60–70% |
| 3 | Aerobic | 70–80% |
| 4 | Threshold | 80–90% |
| 5 | Maximum | 90–100% |

Zone boundaries use an inclusive lower bound and exclusive upper bound — so exactly 70% puts you in Zone 3, not Zone 2.

### 4. Adaptive Feedback

Every second, the app checks whether you're in your target zone. If you've been outside it long enough, it speaks through your headphones:

- **"Faster"** — heart rate is too low for the target zone
- **"Slower"** — heart rate is too high
- **Route suggestions** — if your pace adjustment isn't enough, the app can guide you toward a flatter or steeper section of your route to naturally regulate intensity
- **Silence** — you're exactly where you should be

A configurable cooldown (default 10 seconds) prevents the feedback from becoming noise.

---

## Architecture

The BLE layer sits behind a `HeartRateService` protocol. The rest of the app — zone logic, feedback, UI — never touches Core Bluetooth directly. This means swapping in a different device or SDK later is a one-line change.

```
ZoneSelectionView
      ↓  zone + maxHR
TrainingView
      ├── CoreBluetoothService   implements HeartRateService
      └── Feedback               evaluates HR every second → speaks
```

---

## Evaluation

The system is evaluated under real running conditions with both objective and subjective metrics.

**Objective:**
- Percentage of training time spent in the target zone
- Deviation from target heart rate
- Heart rate stability throughout the session

**Subjective:**
- Perceived exertion (Borg scale)
- Usability
- Perceived usefulness of the feedback

---

## Scientific Context

This work draws on current research in:

- Wearable Computing
- Physiological Computing
- Human Activity Recognition
- Adaptive Feedback Systems in Sport
