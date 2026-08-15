# Realm of Eternal Conquest

**Epic fantasy real-time strategy for iOS** built around multi-touch legion command, gesture formations, freehand rune magic, and tactile siege warfare.

> Floating sky-realms. Eternal war for the Throne. Your fingers are the warlord.

[![iOS](https://img.shields.io/badge/iOS-17%2B-blue)]()
[![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange)]()
[![SpriteKit](https://img.shields.io/badge/SpriteKit-native-green)]()

## Vision

Inspired by the cinematic trailer of soaring floating citadels at golden hour, *Realm of Eternal Conquest* is a native iOS strategy/action hybrid that treats the entire Multi-Touch surface as a command interface.

You command legions across drifting sky-islands, capture keeps that permanently expand the world, and ultimately contest the shadowed Eternal Throne.

### Signature Mechanics

| Mechanic | Input | Feel |
|----------|-------|------|
| **Multi-Finger Legion Command** | Up to 5 simultaneous fingers | Independent orders to different squads at once |
| **Formation Gestures** | Pinch / Spread / Rotate / 3-finger swipe | Shape battle lines in real time |
| **Rune Drawing** | Freehand draw in spell mode | Accuracy + speed determine power |
| **Siege Touch** | Multi-finger press-and-hold on walls | Build power then release impact (haptics) |
| **Hero Direct Control** | Thumb + gestures or virtual stick | Hybrid with army orders |

## Project Status

Early prototype / foundation.

- [x] Repository & design documentation
- [x] Core SpriteKit scene with multi-touch tracking
- [x] Unit & Legion models
- [x] Basic formation gesture recognition
- [ ] Rune drawing recognition
- [ ] Siege power meter + haptics
- [ ] Island / keep map progression
- [ ] Full combat & AI
- [ ] Persistence & seasons

## Architecture

```
RealmOfEternalConquest/
├── App/
│   └── (standard iOS app entry)
├── Game/
│   ├── Scenes/
│   │   └── GameScene.swift          # Main multi-touch battlefield
│   ├── Entities/
│   │   ├── Unit.swift
│   │   ├── Legion.swift
│   │   └── Hero.swift
│   ├── Systems/
│   │   ├── TouchCommandSystem.swift # Multi-finger order dispatcher
│   │   ├── FormationSystem.swift
│   │   ├── RuneSystem.swift
│   │   └── SiegeSystem.swift
│   ├── UI/
│   │   └── HUDNode.swift
│   └── World/
│       ├── Island.swift
│       └── Keep.swift
├── Resources/
│   ├── Art/                         # Placeholder + trailer-inspired assets
│   └── Audio/
└── Docs/
    └── Design.md
```

**Tech stack**: Pure Swift + SpriteKit (no Unity/Unreal). Heavy use of `UIGestureRecognizer` subclasses, `UIImpactFeedbackGenerator` / `UINotificationFeedbackGenerator`, and simultaneous multi-touch tracking via `touchesBegan/Moved/Ended`.

## Getting Started (Xcode)

1. Clone the repo
2. Open Xcode → File → New → Project → **iOS → Game** (SpriteKit template)
3. Name it `RealmOfEternalConquest`, choose Swift + SpriteKit
4. Replace the generated `GameScene.swift` and add the source files from this repository under the appropriate groups
5. Set deployment target to iOS 17+
6. Build & run on a physical device (multi-touch + haptics require real hardware)

Alternatively, the `Sources/` directory can be used as a starting point for a Swift Package that contains the pure game logic.

## Core Touch Philosophy

Most mobile strategy games collapse to single-finger taps + menus.  
This game treats every finger as an independent command channel.

- One finger moves the infantry line
- Second finger wheels the cavalry
- Third finger holds a defensive knot
- Fourth finger draws a lightning rune
- Fifth finger marks the siege target

The result should feel closer to conducting an orchestra of war than tapping buttons.

## License

Proprietary for now. All rights reserved by the project owner.

---

*Five Realms. One Throne. Eternal Conquest.*
