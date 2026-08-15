# Realm of Eternal Conquest — Design Document

## High Concept

A native iOS real-time strategy / action hybrid set among floating sky-islands and eternal fortresses. The player is a warlord of one of five ancient Realms competing for the Eternal Throne. The defining feature is **multi-touch as the primary command language**.

## Setting & Narrative Frame

Golden-hour floating citadels, cascading waterfalls off cliff edges into clouds, winged banners, soaring architecture. The world is an archipelago of sky-islands. Capturing a keep permanently unlocks the surrounding zone and opens warpaths to the next region. The fifth and final shadowed domain only appears when the four outer keeps are held.

## Core Pillars

1. **Fingers as Command Channels** — simultaneous independent orders
2. **Physical Feel** — haptics, pressure of sieges, gesture shaping of formations
3. **Progressive Revelation of the World** — conquering keeps expands the map
4. **Hero + Army Hybrid** — direct control of a hero while still commanding legions

## Signature Touch Systems

### 1. Multi-Finger Legion Command

- `touchesBegan` records up to 5 active fingers
- Each finger is bound to a selected unit/legion or creates a new order target
- `touchesMoved` continuously updates the move/attack destination for that finger’s bound group
- Lifting a finger cancels or locks the order
- Visual: colored order lines or ghost paths per finger ID

### 2. Formation Gestures

Recognized while two or more fingers are on a selected Legion:

- **Pinch** → contract into shield wall (defensive bonus, slower)
- **Spread** → expand into battle line
- **Two-finger rotate** → wheel the formation
- **Three-finger forward swipe** → charge order
- **Three-finger downward press** → Brace

Implemented via custom `UIGestureRecognizer` or direct distance/angle analysis in the touch system.

### 3. Rune Drawing Magic

- Long-press or dedicated mode button enters Spell Mode
- Freehand path is recorded
- Path is matched against a small library of runes (slash, circle, spiral, specific glyphs)
- Score based on shape similarity + drawing speed + size
- Successful cast triggers layered haptics + particle effect
- Failed drawing fizzles with weak feedback

### 4. Siege Touch

When interacting with a Keep wall or gate:

- Multiple fingers pressed on the structure accumulate a power value
- Visual meter + increasing haptic intensity
- On release (or timed threshold) an impact is delivered proportional to power and number of fingers
- Defenders can multi-touch the same section to reinforce

### 5. Supporting Feedback

- Distinct `UIImpactFeedbackGenerator` patterns for different unit types and events
- Optional device tilt for camera or charge momentum
- Apple Pencil support for high-precision rune drawing on iPad

## Entity Model (Initial)

- **Unit** — individual soldier with type (Infantry, Cavalry, Archer, Siege), health, position, current order
- **Legion** — collection of Units that share formation state and can receive group orders
- **Hero** — special Unit with unique abilities and direct-control mode
- **Keep** — capturable structure with wall sections, garrison, and unlock effects
- **Island** — map node containing Keeps and resources; ownership determines dominion bonuses

## Combat Loop (Prototype Target)

1. Player selects legions / hero
2. Issues simultaneous multi-finger orders
3. Formations are shaped on the fly
4. Rune spells are drawn as needed
5. When a Keep is reached, siege touch begins
6. Capture → map expands → new warpaths appear

## Technical Notes

- All primary input handled in `GameScene` via the standard touch methods (not only high-level gesture recognizers) so simultaneous independent fingers remain possible
- Gesture recognizers used as secondary detectors for formation and rune modes
- Haptics prepared once and reused
- Game state is pure Swift structs/classes so it can later be networked or persisted easily

## Future Directions

- Seasonal ranked conquest
- Co-op sky-titan raids
- Persistent player islands with light base building
- Cross-save via Game Center / iCloud

---

*This document is the living design reference for the prototype in this repository.*
