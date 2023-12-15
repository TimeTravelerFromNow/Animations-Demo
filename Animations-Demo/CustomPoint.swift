
import SpriteKit

class CustomPoint: SKShapeNode {
    
    override class func didChangeValue(forKey key: String) {
        if key == "position" {
            print("Custompoint position changed")
        }
    }
    
    init(_ ptSize: CGFloat = 20) {
        super.init()
        self.fillColor = NSColor(red: 0, green: 1, blue: 1, alpha: 1)
        self.strokeColor = NSColor(red: 1, green: 1, blue: 0, alpha: 0)
        self.path = CGPath(ellipseIn: CGRect(x: -ptSize / 4, y: -ptSize / 4, width: ptSize / 2, height: ptSize / 2), transform: nil)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: ptSize)
        self.physicsBody!.linearDamping = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
