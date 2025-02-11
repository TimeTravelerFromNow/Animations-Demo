
import SpriteKit
import simd


// for demonstrating vector operations
class CustomLine: SKShapeNode{
    
    var p0: CGPoint = CGPoint(0) { didSet { _setPath(); }}
    var p1: CGPoint = CGPoint(0) { didSet { _setPath(); _p1APos = p0 }}
    
    var v: CGPoint { return p1 - p0 }
    
    private var _p1APos: CGPoint = CGPoint(0)
    
    var color: float4 = float4(1, 1, 1, 1) { didSet { _setPath() } }
    
    var drawDur: TimeInterval = 1
    
    private var _animateGrow: SKAction { return SKAction.customAction(withDuration: drawDur, actionBlock: { (node, timeEl) in
        
        guard let lN = node as? CustomLine  else { return }
        lN._p1APos = lN.p0 + lN.v * timeEl / self.drawDur
        lN._setPath()
    }) }
    
    func cut(_ in: Int) {
        
    }
    
    func animate() {
        self.run(_animateGrow)
    }
    
    private func _setPath() {
        var lineP = CGMutablePath()
        
        lineP.move(to: p0)
        lineP.addLine(to: _p1APos)
        
        self.strokeColor = NSColor( color )
        self.alpha = CGFloat(color.w)
        
        self.glowWidth = 0
        
        self.path = lineP
    }
    
    override init() {
        super.init()
        self.zPosition = -1
        _setPath()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
