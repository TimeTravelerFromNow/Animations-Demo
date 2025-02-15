
import SpriteKit
import simd


// for demonstrating vector operations
class CustomLine: SKShapeNode{
    
    var p0: CGPoint = CGPoint(0) { didSet { _setPath(); }}
    var p1: CGPoint = CGPoint(0) { didSet { _setPath(); _p1APos = p0 }}
    
    var v: CGPoint { return p1 - p0 }
    
    private var _p1APos: CGPoint = CGPoint(0)
    
    var color: float4 = float4(0.93, 0.2, 0.2, 1)
    
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
        setDrawProperties()
        var lineP = CGMutablePath()
        
        lineP.move(to: p0)
        lineP.addLine(to: _p1APos)
        
        self.path = lineP
    }
    func setDrawProperties() {
        self.strokeColor = NSColor( color )
        self.fillColor = NSColor(color)
        self.alpha = CGFloat(color.w)
        
        self.glowWidth = 0
        self.lineWidth = 20
    }
    
    init(p0: CGPoint, p1: CGPoint) {
        super.init()
        self.p0 = p0
        self.p1 = p1
    }
    
    override init() {
        super.init()
        setDrawProperties()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cleanup() {
        self._p1APos = p0
        self._setPath()
    }
}
