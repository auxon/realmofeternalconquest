import UIKit
import SpriteKit

/// Responsible for mapping simultaneous UITouches to independent command channels.
/// This is the heart of the multi-finger design.
final class TouchCommandSystem {

    struct Channel {
        let touchID: ObjectIdentifier
        weak var boundLegion: Legion?
        var currentTarget: CGPoint
        var orderLine: SKShapeNode?
    }

    private(set) var channels: [ObjectIdentifier: Channel] = [:]

    weak var scene: SKScene?

    init(scene: SKScene) {
        self.scene = scene
    }

    func began(_ touches: Set<UITouch>, in scene: SKScene, legions: [Legion]) {
        for touch in touches {
            let id = ObjectIdentifier(touch)
            let location = touch.location(in: scene)

            // Prefer binding to a legion under the finger
            let bound = legions.first { $0.node.contains(location) }

            var channel = Channel(touchID: id, boundLegion: bound, currentTarget: location, orderLine: nil)

            if let legion = bound {
                legion.setSelected(true)
            }

            channels[id] = channel
        }
    }

    func moved(_ touches: Set<UITouch>, in scene: SKScene) {
        for touch in touches {
            let id = ObjectIdentifier(touch)
            guard var channel = channels[id] else { continue }

            let location = touch.location(in: scene)
            channel.currentTarget = location
            channels[id] = channel

            // Visual update would live here or in the scene
        }
    }

    func ended(_ touches: Set<UITouch>) {
        for touch in touches {
            let id = ObjectIdentifier(touch)
            if let channel = channels[id], let legion = channel.boundLegion {
                legion.issueMoveOrder(to: channel.currentTarget)
            }
            channels.removeValue(forKey: id)
        }
    }

    func cancelled(_ touches: Set<UITouch>) {
        for touch in touches {
            channels.removeValue(forKey: ObjectIdentifier(touch))
        }
    }
}
