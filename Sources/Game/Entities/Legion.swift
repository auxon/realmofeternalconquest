import SpriteKit

/// A group of Units that share orders and formation state.
/// The primary object that a player finger binds to for multi-touch command.
final class Legion {
    let id = UUID()
    let name: String
    let type: UnitType

    private(set) var units: [Unit] = []
    private(set) var isSelected = false

    /// Average position of the legion (used for order lines and selection)
    var position: CGPoint {
        guard !units.isEmpty else { return .zero }
        let sum = units.reduce(CGPoint.zero) { CGPoint(x: $0.x + $1.position.x, y: $0.y + $1.position.y) }
        return CGPoint(x: sum.x / CGFloat(units.count), y: sum.y / CGFloat(units.count))
    }

    /// Visual representation of the legion (simple for prototype)
    let node: SKNode

    private let selectionRing: SKShapeNode
    private let label: SKLabelNode

    init(name: String, type: UnitType, position: CGPoint, unitCount: Int = 6) {
        self.name = name
        self.type = type

        node = SKNode()
        node.position = position
        node.zPosition = 10

        // Create individual units in a loose cluster
        for i in 0..<unitCount {
            let offset = CGPoint(
                x: CGFloat.random(in: -30...30),
                y: CGFloat.random(in: -30...30)
            )
            let unit = Unit(type: type, position: CGPoint(x: position.x + offset.x, y: position.y + offset.y))
            units.append(unit)
            node.addChild(unit.node)
        }

        // Selection ring
        selectionRing = SKShapeNode(circleOfRadius: 55)
        selectionRing.strokeColor = .cyan
        selectionRing.lineWidth = 2
        selectionRing.glowWidth = 3
        selectionRing.fillColor = .clear
        selectionRing.isHidden = true
        selectionRing.zPosition = 5
        node.addChild(selectionRing)

        // Name label
        label = SKLabelNode(text: name)
        label.fontName = "Helvetica-Bold"
        label.fontSize = 11
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        label.position = CGPoint(x: 0, y: 70)
        label.zPosition = 20
        node.addChild(label)
    }

    func setSelected(_ selected: Bool) {
        isSelected = selected
        selectionRing.isHidden = !selected
        selectionRing.alpha = selected ? 1.0 : 0.0
    }

    /// Issue a move order to every unit in the legion (they keep relative offsets for now).
    func issueMoveOrder(to target: CGPoint) {
        let currentCenter = position
        let delta = CGPoint(x: target.x - currentCenter.x, y: target.y - currentCenter.y)

        for unit in units {
            let newTarget = CGPoint(x: unit.position.x + delta.x, y: unit.position.y + delta.y)
            unit.issueMoveOrder(to: newTarget)
        }
    }

    func update(deltaTime: CGFloat) {
        units.forEach { $0.update(deltaTime: deltaTime) }

        // Keep the legion node centered on the average of its units
        // (individual unit nodes are children, so we only update the container if needed)
        // For the prototype we leave unit nodes in world space relative to the original parent.
    }

    // Future: formation methods (pinch → contract offsets, etc.)
    func applyFormation(scale: CGFloat) {
        // Placeholder for pinch/spread logic
    }
}
