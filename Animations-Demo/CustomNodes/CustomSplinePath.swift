import SpriteKit

// initialize a spline with CustomSplinePath(splinePoints: &points, count: points.count)
class CustomSplinePath: SKShapeNode {
    override init() {
        super.init()
        self.zPosition = -1
        self.glowWidth = 0
        self.strokeColor = NSColor(red: 0.4, green: 0.5, blue: 0.5, alpha: 1.0)
        self.lineWidth = 10
        self.alpha = 0.6
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
