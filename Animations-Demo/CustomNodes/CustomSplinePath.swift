import SpriteKit

// initialize a spline with CustomSplinePath(splinePoints: &points, count: points.count)
// what this does is initialize the spline
// the animation uses dotted paths from a copy of the original spline and adds them sequentially
class CustomSplinePath: SKShapeNode {
    var dottedPath: CGPath!
    var dottedPathCopy: CGMutablePath!
    var dottedPathNode: SKShapeNode!
    var dottedPathComponents: [CGPath] = []
    
    var drawDuration: TimeInterval = 5
    var dashIndex = 0
    
    func cleanup() {
        self.dottedPathNode.removeFromParent()
        self.dottedPathNode.path = nil
    }
    
    private var _animatePath: SKAction {
        return SKAction.customAction(withDuration: drawDuration, actionBlock: { (node, timeEl) in
            
            let currentPathComponentIndex = Int( Float(self.dottedPathComponents.count) * Float(timeEl / self.drawDuration) - 1 )
            if(self.dashIndex < currentPathComponentIndex) {
                
                self.dottedPathCopy.addPath(self.dottedPathComponents[self.dashIndex])
//                self.dottedPathCopy.
                print(self.dottedPathComponents[self.dashIndex])
                self.dottedPathNode.path = self.dottedPathCopy
                self.dashIndex += 1
                print(self.dashIndex)
            }
        })
    }
    
    func animateDottedPath() {
        var preview: SKShapeNode! = SKShapeNode(path: self.path!.copy(dashingWithPhase: 100.0, lengths: [10]))
        preview.fillColor = .green
        self.addChild(preview)

        self.dashIndex = 0
        self.dottedPath = self.path?.copy(dashingWithPhase: 100.0, lengths: [10])
        
        self.dottedPathComponents = self.dottedPath.componentsSeparated()

        
        self.dottedPathCopy = dottedPathComponents.first!.mutableCopy()
        self.dottedPathNode = CustomSplinePath(path: self.dottedPathCopy)
        self.dottedPathNode.alpha = 1.0
        self.dottedPathNode.zPosition = 0.0
        self.addChild(self.dottedPathNode)
        
        self.run(_animatePath)
    }
    
    override init() {
        super.init()
        self.zPosition = -1
        self.glowWidth = 0
        self.strokeColor = NSColor(red: 1.0, green: 0.5, blue: 0.5, alpha: 1.0)
        self.lineWidth = 10
        self.alpha = 0.6
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
