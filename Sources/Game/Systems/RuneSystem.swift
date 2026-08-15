import UIKit
import SpriteKit

/// Captures freehand paths in spell mode and matches them against known runes.
final class RuneSystem {

    enum Rune {
        case bolt       // simple slash
        case barrier    // circle
        case storm      // spiral
        case unknown
    }

    private var currentPath: [CGPoint] = []
    private var isDrawing = false

    weak var scene: SKScene?

    func beginDrawing(at point: CGPoint) {
        currentPath = [point]
        isDrawing = true
    }

    func continueDrawing(to point: CGPoint) {
        guard isDrawing else { return }
        currentPath.append(point)
        // TODO: update a live SKShapeNode trail for visual feedback
    }

    func endDrawing() -> (rune: Rune, power: CGFloat) {
        isDrawing = false
        let result = recognize(path: currentPath)
        currentPath.removeAll()
        return result
    }

    private func recognize(path: [CGPoint]) -> (Rune, CGFloat) {
        guard path.count > 5 else { return (.unknown, 0) }

        // Extremely simplified prototype recognition:
        // - Mostly linear → bolt
        // - Closed-ish shape → barrier
        // - Otherwise → unknown (spiral detection needs curvature analysis)

        let start = path.first!
        let end = path.last!
        let distance = hypot(end.x - start.x, end.y - start.y)
        let totalLength = zip(path, path.dropFirst()).reduce(0) { $0 + hypot($1.0.x - $1.1.x, $1.0.y - $1.1.y) }

        let straightness = distance / max(totalLength, 1)

        if straightness > 0.85 {
            return (.bolt, min(1.0, totalLength / 200))
        }

        // Very rough closed-shape test
        if distance < 40 && totalLength > 120 {
            return (.barrier, min(1.0, totalLength / 300))
        }

        return (.unknown, 0)
    }
}
