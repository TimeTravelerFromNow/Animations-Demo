
import SpriteKit

enum AnimationType {
    case MakeTriangle
    case TitleText
}

class AnimationManager {
    
    private static var _animationLibrary: [AnimationType: Animation] = [:]
    
    public static func Initialize(_ scene: AnimationScene) {
        addAnimation(.MakeTriangle, TrianglePointsA(s: scene))
        addAnimation(.TitleText, TitleTextA(s: scene))
    }
    
    public static func NextFrame() {
        for a in _animationLibrary.values {
            a.animate()
        }
    }
    
    public static func StopAll() {
        for a in _animationLibrary.values {
            a.stopAll()
        }
    }
    
    public static func addAnimation(_ animationKey: AnimationType, _ animation: Animation) {
        _animationLibrary.updateValue(animation, forKey: animationKey)
    }
    
    public static func getAnimation(_ animationKey: AnimationType) -> Animation {
        return _animationLibrary[animationKey]!
    }
}

class TrianglePointsA: Animation {
    init(s: AnimationScene) {
        super.init(0, 10,s: s)
    }
    var points: [CustomPoint] = []
    var pLabels: [SKLabelNode] = []
    
    var outline: SKShapeNode!
    var arc: PiSlice!
    
    var tCoords = [
        CGPoint(x: -0.5,y: -0.5),
        CGPoint(x: 0.5, y: -0.5),
        CGPoint(x: 0.0,y: 0.366),
    ]
    func getTriPath() -> CGMutablePath {
        let path = CGMutablePath()
        path.move(to: points.first!.position)
        for p in points {
            path.addLine(to: p.position)
        }
        return path
    }

    override func setupNodes() {
        scene.ndcToScene(&tCoords)
        for i in 0..<3 {
            let pt = CustomPoint(30)
            let pL = SKLabelNode(text: "\(i)")
            self.points.append(pt)
            self.pLabels.append(pL)
        }
        outline = SKShapeNode()
        
        arc = PiSlice()
        
        setAnimationNodes(points)
        appendNodes(contentsOf: pLabels)
        appendNode(outline)
        appendNode(arc)
    }
    
    override func customAnimation() {
        let tFA = SKAction.fadeIn(withDuration: 1) // 1 sec fade action

        if fIndex == 0 {
            outline.alpha = 0
//            outline.path = nil
            
            for (i, pt) in points.enumerated() {
                pt.position = CGPoint(x: scene.fWidth / 2, y: scene.fHeight / 2) //
                pt.zPosition = 1
                pLabels[i].alpha = 0
            }
            
        }
        if fIndex == 1 {
            let tFA2 = SKAction.customAction(withDuration: 1, actionBlock: {
                node, elapsedT in
                ( node as! SKShapeNode ).path = self.getTriPath()
            }
            )
            outline.run(tFA)
            outline.fillColor = .white

            outline.run(tFA2)
            
            outline.strokeColor = .white
            outline.lineWidth = 1
            
            for (i, pt) in points.enumerated() {
                let moveAct = SKAction.move(to: tCoords[i], duration: 1)
                pt.run(moveAct)
            }
            
            arc.position = points[0].position
            arc.run(tFA)
        }
        if fIndex == 2 {

            for (i, pL) in pLabels.enumerated() {
                pL.position = points[i].position
                pL.position.y += 30
                pL.position.x += 30 * ( CGFloat(i) - 1 )
                pL.run(tFA)
            }
            arc.angle = 2 * .pi
            arc.run(tFA)

        }
    }
}

class TitleTextA: Animation {
    
    var titleText: SKLabelNode!
    var frameNo: SKLabelNode!
    
    func makeTexts(_ fW: CGFloat, _ fH: CGFloat) {
        titleText = SKLabelNode(text: "Triangle Vertices")
        titleText.position.x = fW * 0.25
        titleText.position.y = fH * 0.75
        frameNo = SKLabelNode(text: "Frame: 0")
        frameNo.position = titleText.position
        frameNo.position.x += fW * 0.5
    }
    
    init( s: AnimationScene) {
        super.init(0, 10, s: s)
    }
    
    func setFrame(_ to: Int) {
        frameNo.text = "Frame: \(to)"
    }
    
    override func setupNodes() {
        makeTexts( scene.fWidth, scene.fHeight )
        appendNode(titleText)
        appendNode(frameNo)
    }
    override func customAnimation() {
        if fIndex == 1 {
            titleText.text = "Equilateral Triangle"
        }
    }
}

class Animation {
    
    var scene: AnimationScene! // in case you need this to specify animation properties
    
    private var _animationNodes: [SKNode] = []

    var fIndex: Int!
    
    let fStart: Int!
    var fEnd: Int!
    var frameCount: Int { return  fEnd - fStart }
    
    func stopAll() {
        _removeNodesFromScene()
        fIndex = 0
    }
    
    func animate() {
        if scene.frameNumber < fStart {
            return // no animation needed until we reach the starting
        }
        if fIndex == 0 {
            _addNodesToScene()
        }
        customAnimation()
        if fIndex < frameCount {
            fIndex += 1
        } else {
            // this animation manager is done, remove the nodes
            _removeNodesFromScene()
        }
    }
    
    func setupNodes() { } // override this
    
    func customAnimation() { } // start the current animation
    
    private func _removeNodesFromScene() {
        for n in _animationNodes {
            n.removeFromParent()
        }
    }
    
    private func _addNodesToScene() {
        for n in _animationNodes {
            scene.addChild(n)
        }
    }
    
    init(_ fStart: Int = 0, _ fEnd: Int = 1, s: AnimationScene) {
        fIndex = fStart
        self.fStart = fStart
        self.fEnd = fEnd
        scene = s
        setupNodes()
    }
    
    // getters setters
    func appendNode(_ n: SKNode) { _animationNodes.append(n); }
    func setAnimationNodes(_ to: [SKNode]) { _animationNodes = to; }
    func appendNodes(contentsOf: [SKNode]) { _animationNodes.append(contentsOf: contentsOf); }
}
