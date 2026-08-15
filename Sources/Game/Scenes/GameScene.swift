import SpriteKit
import UIKit

/// Main battlefield scene.
/// Demonstrates the core multi-finger command philosophy:
/// each active finger can independently control a different legion or issue a unique order.
final class GameScene: SKScene {

    // MARK: - Touch State

    /// Maps UITouch identity (ObjectIdentifier) → current order target / bound legion
    private var activeTouches: [ObjectIdentifier: TouchCommand] = [:]

    /// Visual feedback nodes for each finger’s current order path
    private var orderLines: [ObjectIdentifier: SKShapeNode] = [:]

    // MARK: - Entities (prototype)

    private var legions: [Legion] = []
    private var selectedLegion: Legion?

    // MARK: - Lifecycle

    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.08, green: 0.12, blue: 0.22, alpha: 1.0)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)

        setupPrototypeLegions()
        setupHUD()
    }

    private func setupPrototypeLegions() {
        let infantry = Legion(name: "Iron Cohort", type: .infantry, position: CGPoint(x: -180, y: -80))
        let cavalry  = Legion(name: "Sky Riders", type: .cavalry,  position: CGPoint(x:  120, y: -40))
        let archers  = Legion(name: "Cloud Archers", type: .archer, position: CGPoint(x: -40, y: 120))

        legions = [infantry, cavalry, archers]
        legions.forEach { addChild($0.node) }
    }

    private func setupHUD() {
        let label = SKLabelNode(text: "Multi-touch: each finger commands independently")
        label.fontName = "Helvetica-Bold"
        label.fontSize = 14
        label.fontColor = .white
        label.position = CGPoint(x: 0, y: size.height / 2 - 40)
        label.zPosition = 100
        addChild(label)
    }

    // MARK: - Multi-Touch Handling

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let id = ObjectIdentifier(touch)
            let location = touch.location(in: self)

            // Simple selection: if we touch a legion, bind this finger to it
            if let legion = legion(at: location) {
                selectedLegion = legion
                activeTouches[id] = TouchCommand(legion: legion, target: location)
                legion.setSelected(true)
            } else if let selected = selectedLegion {
                // Issue a move order with this finger
                activeTouches[id] = TouchCommand(legion: selected, target: location)
                createOrderLine(for: id, from: selected.position, to: location)
            } else {
                // Create a free order marker (future: place new units or mark targets)
                activeTouches[id] = TouchCommand(legion: nil, target: location)
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let id = ObjectIdentifier(touch)
            guard var command = activeTouches[id] else { continue }

            let location = touch.location(in: self)
            command.target = location
            activeTouches[id] = command

            // Update visual order line
            if let legion = command.legion {
                updateOrderLine(for: id, from: legion.position, to: location)
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let id = ObjectIdentifier(touch)
            if let command = activeTouches[id], let legion = command.legion {
                // Commit the order
                legion.issueMoveOrder(to: command.target)
            }
            cleanupTouch(id)
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            cleanupTouch(ObjectIdentifier(touch))
        }
    }

    private func cleanupTouch(_ id: ObjectIdentifier) {
        activeTouches.removeValue(forKey: id)
        orderLines[id]?.removeFromParent()
        orderLines.removeValue(forKey: id)
    }

    // MARK: - Helpers

    private func legion(at point: CGPoint) -> Legion? {
        legions.first { $0.node.contains(point) }
    }

    private func createOrderLine(for id: ObjectIdentifier, from: CGPoint, to: CGPoint) {
        let path = CGMutablePath()
        path.move(to: from)
        path.addLine(to: to)

        let line = SKShapeNode(path: path)
        line.strokeColor = .cyan
        line.lineWidth = 2.5
        line.glowWidth = 4
        line.zPosition = 50
        addChild(line)
        orderLines[id] = line
    }

    private func updateOrderLine(for id: ObjectIdentifier, from: CGPoint, to: CGPoint) {
        guard let line = orderLines[id] else {
            createOrderLine(for: id, from: from, to: to)
            return
        }
        let path = CGMutablePath()
        path.move(to: from)
        path.addLine(to: to)
        line.path = path
    }

    // MARK: - Update Loop

    override func update(_ currentTime: TimeInterval) {
        legions.forEach { $0.update(deltaTime: 1.0 / 60.0) }
    }
}

// MARK: - Supporting Types

struct TouchCommand {
    weak var legion: Legion?
    var target: CGPoint
}
