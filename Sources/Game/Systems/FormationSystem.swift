import UIKit
import SpriteKit

/// Detects multi-finger formation gestures on a selected Legion
/// and applies the corresponding formation change.
final class FormationSystem {

    enum FormationAction {
        case contract(scale: CGFloat)   // pinch
        case expand(scale: CGFloat)     // spread
        case rotate(angle: CGFloat)
        case charge
        case brace
    }

    weak var scene: SKScene?

    /// Simple distance-based pinch / spread detection between the first two active fingers.
    /// In a full implementation this would be a custom UIGestureRecognizer or continuous analysis.
    func evaluate(touches: [UITouch], on legion: Legion) -> FormationAction? {
        guard touches.count >= 2 else { return nil }

        let locations = touches.prefix(2).map { $0.location(in: scene!) }
        let distance = hypot(locations[0].x - locations[1].x, locations[0].y - locations[1].y)

        // Placeholder thresholds – tune later with real device testing
        if distance < 80 {
            return .contract(scale: 0.7)
        } else if distance > 180 {
            return .expand(scale: 1.4)
        }

        // Future: track previous distance to detect continuous pinch velocity
        // Future: angle between vectors for rotate
        // Future: three-finger velocity for charge / brace

        return nil
    }

    func apply(_ action: FormationAction, to legion: Legion) {
        switch action {
        case .contract(let scale), .expand(let scale):
            legion.applyFormation(scale: scale)
            // TODO: animate unit offsets toward / away from center
        case .rotate:
            // TODO: rotate relative offsets
            break
        case .charge:
            // TODO: give temporary speed + aggression boost
            break
        case .brace:
            // TODO: defensive posture
            break
        }
    }
}
