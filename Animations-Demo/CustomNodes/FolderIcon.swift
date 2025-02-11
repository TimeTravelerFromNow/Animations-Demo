
import SpriteKit

class FolderIcon: SKShapeNode {
    var color: float4 = float4(0.5, 0.5, 1, 1) { didSet { _refreshColors() }}
    
    var imageNode: SKNode!
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
        self.imageNode = SKNode(fileNamed: "Folders")!
        self.addChild(imageNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
