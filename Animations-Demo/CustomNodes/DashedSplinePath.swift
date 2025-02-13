import SpriteKit

/// First, initialize a spline with node = SKShapeNode(splinePoints: &points, count: points.count)
// then create a dashed path for animation with DashedSplinePath(fromSplinePath: node.path!)
// the animation uses dashed paths from a copy of the original spline and adds them sequentially
class DashedSplinePath: SKShapeNode {
    var dottedPathCopy: CGMutablePath!
    var dottedPathComponents: [CGPath] = []
    
    var drawDuration: TimeInterval = 5
    var dashIndex = 0
    
    private var _animatePath: SKAction {
        return SKAction.customAction(withDuration: drawDuration, actionBlock: { (node, timeEl) in
            
            let currentPathComponentIndex = Int( Float(self.dottedPathComponents.count) * Float(timeEl / self.drawDuration) - 1 )
            if(self.dashIndex < currentPathComponentIndex) {
                
                self.dottedPathCopy.addPath(self.dottedPathComponents[self.dashIndex])
                print(self.dottedPathComponents[self.dashIndex])
                self.path = self.dottedPathCopy
                self.dashIndex += 1
                print(self.dashIndex)
            }
        })
    }
    
    func animateDottedPath() {
        self.dashIndex = 0
        self.dottedPathComponents = self.path!.componentsSeparated()
        
        self.dottedPathCopy = dottedPathComponents.first!.mutableCopy()
        self.alpha = 1.0
        self.zPosition = 0.0
        
        self.run(_animatePath)
    }
    
    
    init(fromSplinePath: CGPath) {
        super.init()
        self.path = fromSplinePath.copy(dashingWithPhase: 100.0, lengths: [10])
        
        self.zPosition = -1
        self.glowWidth = 0
        self.strokeColor = NSColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0)
        self.lineWidth = 10
        self.alpha = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
