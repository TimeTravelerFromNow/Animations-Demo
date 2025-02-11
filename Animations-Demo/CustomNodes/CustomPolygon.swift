import SpriteKit

class CustomPolygon: SKShapeNode {
    
    var pts: [CGPoint] = [] { didSet { _refresh() } }
    var outsideInds: [Int]? = nil
    
    var color: float4 = float4(1, 1, 1, 1) { didSet { _refreshCol() } }
    
    private func _refreshCol() {
        self.fillColor = NSColor(color)
    }
    
    private func _refresh() {
        if pts.count < 2 {return}
        var polyP = CGMutablePath()
        
     
        if outsideInds != nil {
            polyP.move(to: pts[outsideInds![0]] )
            for i in 1..<outsideInds!.count {
                let oIndex = outsideInds![i]
                polyP.addLine(to: pts[oIndex])
            }
            polyP.addLine(to: pts[outsideInds![0]])

        } else {
            polyP.move(to: pts[0])
            
            for i in 1..<pts.count {
                polyP.addLine(to: pts[i])
            }
            polyP.addLine(to: pts[0])
        }
        
        self.path = polyP
    }
    
    
    override init() {
        super.init()
        self.lineWidth = 1
        self.zPosition = -2
        self.alpha = 0.6
        _refreshCol()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
