
import SpriteKit

class CustomPoint: SKShapeNode {
    var color: float4 = float4(0.5, 0.5, 1, 1) { didSet { _refreshColors() }}

    private let _delay: TimeInterval = 1
    private let _fIA: SKAction = SKAction.fadeIn(withDuration: 1)
    
    func fadeIn(wait: Bool = false) {
        if wait {
            let delayA = SKAction.wait(forDuration: _delay)
            self.run( SKAction.group([ delayA, _fIA]) )
        } else {
            self.run(_fIA)
        }
    }
    
    private func _refreshColors() {
        self.fillColor = NSColor(color)
    }
    
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
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
