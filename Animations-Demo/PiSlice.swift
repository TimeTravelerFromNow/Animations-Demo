
import SpriteKit
import GameKit

class PiSlice: SKShapeNode {
    
    var direction: CGVector = CGVector(dx: 1, dy: 0) {
        didSet {
            print(direction)
            self.zRotation = atan( direction.dy / direction.dx )
        }
    }
    
    var radius: CGFloat = 40
    var angle: CGFloat = 3 * .pi / 12 { didSet { updatePath() } }
        
    func updatePath() {
        var slicePath = CGMutablePath()
        
        slicePath.move(to: CGPoint(0))
    
        slicePath.addArc(center: CGPoint(0), radius: radius, startAngle: 0, endAngle: self.angle, clockwise: false)
        slicePath.addLine(to: CGPoint(0))

        self.fillColor = NSColor(red: 0, green: 1, blue: 1, alpha: 1)
        self.strokeColor = .blue
        self.lineWidth = 1
        self.path = slicePath
    }
    
    override init() {
        super.init()
        updatePath()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
