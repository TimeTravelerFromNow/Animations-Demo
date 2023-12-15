
import SpriteKit

class PiSlice: SKShapeNode {
    
    var norm: CGVector = CGVector(dx: 1, dy: 0) { didSet { /* rotate */ } }
    
    var radius: CGFloat = 40
    var angle: CGFloat = 3 * .pi / 12 { didSet { updatePath() } }
    
    var slicePath: CGMutablePath?
    
    func updatePath() {
        slicePath?.move(to: self.position)
    
        slicePath?.addArc(center: self.position, radius: radius, startAngle: 0, endAngle: angle, clockwise: false)
        slicePath?.addLine(to: self.position)
        slicePath?.closeSubpath()

        self.fillColor = NSColor(red: 0, green: 1, blue: 1, alpha: 1)
        self.strokeColor = .red
        self.lineWidth = 1
    }
    
    override init() {
        super.init()
        slicePath = CGMutablePath()
        updatePath()
        self.path = slicePath

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
