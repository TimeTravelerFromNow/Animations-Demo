
import SpriteKit

class TriConstructor: SKShapeNode {
    
    public func newTri(v0 : CGPoint, v1: CGPoint) -> [CGPoint] {
        var triOut = [CGPoint].init(repeating: CGPoint(0), count: 3)
        let sideV = v1 - v0
        let sideVLength = sideV.magnitude
        
        triOut[0] = v0 + sideV / 3
        //        /  |
        //      /    | h      tan(60) = h / base = h / ( 0.5 * ( sideVLength / 3 ) )
        //    /60deg_|        h = tan(60) * all_that
        let h = tan( .pi / 3) * ( sideVLength / 6)
        triOut[1] = v0 + 0.5 * sideV + h * ninetyDegRotated(sideV).normalized
        triOut[2] = v0 + 2 * sideV / 3
        return triOut
    }
    
    func ninetyDegRotated(_ sideVector: CGPoint) -> CGPoint {
        let ninetyDegRotMat: [[CGFloat]] = [
            [ 0, 1 ], // cos(pi/2) , - sin(pi/2)
            [ -1, 0 ]       //  sin(pi/2) , cos(pi/2)
        ]
        
        return CGPoint( sideVector.y * ninetyDegRotMat[0][1], sideVector.x * ninetyDegRotMat[1][0] )
    }
    
    var wedge: PiSlice!
    var srcV0: CustomPoint! // existing vertices
    var srcV1: CustomPoint!
    
    var mainVector: CustomLine!
    
    var baseSegment: CustomLine!
    var normalLine: CustomLine!
    var sideLine: CustomLine!
    
    var v0: CustomPoint!
    var v1: CustomPoint!
    var v2: CustomPoint!
    var midpoint: CustomPoint!
    
    var finalTri: CustomPolygon!
    
    var hL: SKLabelNode!
    var bL: SKLabelNode!
    var tanLabel: SKLabelNode!
    
    let fadeInT: TimeInterval = 1
    let ptsCol = float4(0.3, 0.6, 0.3, 1)
    let ptsColSecond = float4(0.3, 0.6, 0.9, 1)
    
    private let fO = SKAction.fadeOut(withDuration: 1)
    private let fI = SKAction.fadeIn(withDuration: 1)
    
    func animateBase() {
        mainVector.p0 = srcV0.position
        mainVector.p1 = srcV1.position
        mainVector.animate()
        
        v0.position = mainVector.v / 3 + srcV0.position
        v2.position = 2 * mainVector.v / 3 + srcV0.position
        v0.fadeIn(wait: true)
        v2.fadeIn(wait: true)
    }
    
    func animateNormalLine() {
        normalLine.position = srcV0.position
        normalLine.p0 = CGPoint(0)
        normalLine.p1 = mainVector.v
        normalLine.drawDur = 0.3
        normalLine.animate()
        
        midpoint.position = mainVector.v / 2 + srcV0.position
        midpoint.fadeIn()
        
        let wait = SKAction.wait(forDuration: 0.3)
        let rotateAction = SKAction.rotate(toAngle: .pi / 2, duration: 1)
        let positionAction = SKAction.move(to: midpoint.position, duration: 1)
        
        let moveRotate = SKAction.group( [ rotateAction, positionAction ])
        let waitandGo = SKAction.sequence( [ wait, moveRotate ])
        normalLine.run(waitandGo)
    }
    
    func animateMagFinder() {
        wedge.position = v0.position
        wedge.direction = CGVector(srcV1.position - srcV0.position)
        wedge.animate()
        
        bL.run(fI)
        hL.run(fI)
        tanLabel.run(fI)
        
        bL.position = wedge.position
        bL.position.x += 50
        hL.position = midpoint.position
        hL.position.x -= 30
        hL.position.y += 50
        tanLabel.position = midpoint.position
        tanLabel.position.x += 150
        tanLabel.position.y -= 40
    }
    
    func animateFinalPoint() {
        bL.run(fO)
        tanLabel.run(fO)
        normalLine.run(fO)
        
        // calculations occur
        sideLine.p0 = midpoint.position
        sideLine.p1 = newTri(v0: srcV1.position, v1: srcV0.position)[1]
        sideLine.animate()
        v1.position = sideLine.p1
        v1.fadeIn(wait: true)
        
        finalTri.pts = [v0.position, v1.position, v2.position]
    }
    
    func aniTri() {
        finalTri.run(fI)
        // fade out the rest
        _returnNormalLine()
        hL.run(fO)
        wedge.run(fO)
        sideLine.run(fO)
        v0.run(fO)
        v1.run(fO)
        v2.run(fO)
        mainVector.run(fO)
        midpoint.run(fO)
    }
    
    func fadeOut() {
        finalTri.run(fO)
    }
    
    private func _returnNormalLine() {
        normalLine.zRotation = 0
        normalLine.position = srcV0.position
    }
    
    private func _customStartingAppearance() {
        v0.alpha = 0
        v1.alpha = 0
        v2.alpha = 0
        finalTri.alpha = 0
        
        midpoint.alpha = 0
        midpoint.color = ptsColSecond
        
        v0.color = ptsCol
        v1.color = ptsCol
        v2.color = ptsCol
        
        normalLine.color = ptsColSecond
        normalLine.lineWidth = 4
        sideLine.lineWidth = 3
        
        mainVector.lineWidth = 5
        mainVector.alpha = 0.5
        
        sideLine.color = float4(0,1,1,1)
        
        bL.fontSize = 24
        hL.fontSize = 24
        tanLabel.fontSize = 24
    }
    
    init(_ v0: CustomPoint, _ v1: CustomPoint) {
        super.init()
        
        self.srcV0 = v0
        self.srcV1 = v1
        
        self.v0 = CustomPoint()
        self.v1 = CustomPoint()
        self.v2 = CustomPoint()
        
        self.midpoint = CustomPoint()
        
        self.wedge = PiSlice( .pi / 3 )
            
        self.mainVector = CustomLine()
        self.baseSegment = CustomLine()
        self.normalLine = CustomLine()
        self.sideLine = CustomLine()
        
        self.bL           = SKLabelNode(text: "b / 2")
        self.hL             = SKLabelNode(text: "h")
        self.tanLabel = SKLabelNode( text: "tan(60°) = h / (b / 2)")
        
        self.finalTri = CustomPolygon()
        
        self.addChild(self.wedge)
        self.addChild(self.v0)
        self.addChild(self.v1)
        self.addChild(self.v2)
        self.addChild(self.midpoint)
        self.addChild(self.mainVector)
        self.addChild(self.baseSegment)
        self.addChild(self.normalLine)
        self.addChild(self.sideLine)
        
        self.addChild(self.bL      )
            self.addChild(self.hL      )
                self.addChild(self.tanLabel)
        
        self.addChild(self.finalTri)
        _customStartingAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
