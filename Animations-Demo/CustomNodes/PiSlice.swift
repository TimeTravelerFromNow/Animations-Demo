
import SpriteKit
import GameKit

class PiSlice: SKShapeNode {
    
    var direction: CGVector = CGVector(dx: 1, dy: 0) {
        didSet {
            self.zRotation = atan( direction.dy / direction.dx )
        }
    }
    
    var color: float4 = float4(0.5, 0.5, 1, 1) { didSet { _refreshColors() }}

    private func _refreshColors() {
        self.fillColor = NSColor(color)
    }
    
    var radius: CGFloat = 40
    var endsRadius: CGFloat = 60
    
    var angle: CGFloat! { didSet { _setAngleStep() } }
    static let anTime: TimeInterval = 1
    var angleStep: CGFloat!
    
    private var _aniAngle: CGFloat = 0

    private let _animateSweep: SKAction = SKAction.customAction(withDuration: PiSlice.anTime, actionBlock: { (node, timeEl) in
        
        guard let pN = node as? PiSlice  else { return }
        pN._aniAngle = pN.angleStep * timeEl
        pN._updatePath()
    })
    
    private func _setAngleStep() {
        angleStep = angle / PiSlice.anTime
    }
        
    private func _updatePath() {
        var slicePath = CGMutablePath()
        
        slicePath.move(to: CGPoint(0))
        slicePath.addLine(to: CGPoint(endsRadius, 0))
        
        slicePath.addArc(center: CGPoint(0), radius: radius, startAngle: 0, endAngle: _aniAngle, clockwise: false)
        
        slicePath.addLine(to: CGPoint(0))
        slicePath.addLine(to: endsRadius * CGPoint(x: cos(_aniAngle),y: sin(_aniAngle)) )

        _refreshColors()
        self.lineWidth = 1
        self.path = slicePath
        self.zPosition = -2
        self.alpha = 0.6
    }
    
    func animate() {
        self.run(_animateSweep)
    }
    
    init(_ angle: CGFloat = .pi) {
        super.init()
        self.angle = angle
        _setAngleStep()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
