import SpriteKit

enum UnitType: String {
    case infantry
    case cavalry
    case archer
    case siege
}

/// Individual soldier / entity on the battlefield.
final class Unit {
    let id = UUID()
    let type: UnitType
    var health: CGFloat = 100
    var maxHealth: CGFloat = 100
    var position: CGPoint
    var velocity: CGVector = .zero
    var targetPosition: CGPoint?

    let node: SKShapeNode

    init(type: UnitType, position: CGPoint) {
        self.type = type
        self.position = position

        let radius: CGFloat
        let color: SKColor

        switch type {
        case .infantry:
            radius = 8
            color = SKColor(red: 0.55, green: 0.45, blue: 0.35, alpha: 1)
        case .cavalry:
            radius = 10
            color = SKColor(red: 0.75, green: 0.55, blue: 0.25, alpha: 1)
        case .archer:
            radius = 7
            color = SKColor(red: 0.35, green: 0.55, blue: 0.35, alpha: 1)
        case .siege:
            radius = 12
            color = SKColor(red: 0.4, green: 0.35, blue: 0.3, alpha: 1)
        }

        node = SKShapeNode(circleOfRadius: radius)
        node.fillColor = color
        node.strokeColor = .white
        node.lineWidth = 1.5
        node.position = position
        node.zPosition = 10
    }

    func issueMoveOrder(to point: CGPoint) {
        targetPosition = point
    }

    func update(deltaTime: CGFloat) {
        guard let target = targetPosition else { return }

        let dx = target.x - position.x
        let dy = target.y - position.y
        let distance = hypot(dx, dy)

        if distance < 4 {
            position = target
            targetPosition = nil
            velocity = .zero
        } else {
            let speed: CGFloat = type == .cavalry ? 180 : 90
            let dirX = dx / distance
            let dirY = dy / distance
            velocity = CGVector(dx: dirX * speed, dy: dirY * speed)
            position.x += velocity.dx * deltaTime
            position.y += velocity.dy * deltaTime
        }

        node.position = position
    }
}
