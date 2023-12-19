
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
    var indices: [SKLabelNode] = []
    var triMaker: TriConstructor!
    
    var tri: CustomPolygon!
    var currSnowflake: CustomPolygon!
    var nextSnowflake: CustomPolygon!
    
    let fIA = SKAction.fadeIn(withDuration: 1)
    let fIA_half = SKAction.fadeAlpha(to: 0.5, duration: 1)
    
    let fO = SKAction.fadeOut(withDuration: 1)
    
    override func setupNodes() {
        for i in 0..<FractalData.thirdIteration.count {
            var v = CustomPoint()
            v.position = FractalData.thirdIteration[i]
            v.alpha = 0
            var l = SKLabelNode(text: " \(FractalData.thirdIndices[i]) ")
            l.position = v.position
            l.alpha = 0
            points.append(v)
            indices.append(l)
        }
        
        tri = CustomPolygon()
        tri.pts =  FractalData.zeroIteration
        currSnowflake = CustomPolygon()
        currSnowflake.alpha = 0
        nextSnowflake = CustomPolygon()
        nextSnowflake.alpha = 0
        
        triMaker = TriConstructor(points[0], points[2])

        self.setAnimationNodes(points)
        self.appendNodes(contentsOf: indices)
        self.appendNode(triMaker)
        self.appendNode(tri)
        self.appendNode(currSnowflake)
        self.appendNode(nextSnowflake)

    }
    func hideAll() { 
        for p in points{ p.alpha = 0};
        for ind in indices { ind.alpha = 0};
        tri.alpha = 0
        currSnowflake.alpha = 0
        nextSnowflake.alpha = 0
    }
    
    override func customAnimation() {

        if fIndex == 0 {
            hideAll()
            tri.run(fIA_half)
            for i in FractalData.zeroIndices {
                points[i].alpha = 1
                indices[i].run(fIA)
            }
        }
        
        if fIndex == 1 {
            triMaker.animateBase()
        }
        
        if fIndex == 2 {
            triMaker.animateNormalLine()
        }
        
        if fIndex == 3 {
            triMaker.zoomOn(mC: self.scene.moveCam, zC: self.scene.zoomCam)
        }
        
        if fIndex == 4 {
            triMaker.animateMagFinder()
        }
        if fIndex == 5 {
            triMaker.animateFinalPoint()
        }
        
        if fIndex == 6 {
            triMaker.aniTri()
        }
        
        if fIndex == 7 {
            self.scene.returnCam(d: 1)
            self.scene.unZoomCam(d: 1)
        }
        
        if fIndex == 8 {
            triMaker.fadeOut()
            currSnowflake.outsideInds = FractalData.outterIs_1
            currSnowflake.pts = FractalData.firstIteration
            currSnowflake.run(fIA_half)
            tri.run(fO)
        }
        
        if fIndex == 9 {
            for i in FractalData.firstIndices {
                points[i].alpha = 1
                indices[i].run(fIA)
            }
        }
        if fIndex == 10  {
            currSnowflake.alpha = 0
            nextSnowflake.outsideInds = FractalData.outterIs_2
            nextSnowflake.pts = FractalData.secondIteration
            nextSnowflake.run(fIA_half)
            
            currSnowflake.outsideInds = FractalData.outterIs_3
            currSnowflake.pts = FractalData.thirdIteration
            for i in FractalData.secondIndices   {
                points[i].alpha = 1
                indices[i].run(fIA)
            }
        }
        
        if fIndex == 11 {
            
            nextSnowflake.run(fO)
            currSnowflake.run(fIA_half)
            
            for i in FractalData.thirdIndices   {
                indices[i].run(fO)
                    
                points[i].run(fIA)
            }
        }
    }
}

class TitleTextA: Animation {
    
    var titleText: SKLabelNode!
    var frameNo: SKLabelNode!
    
    func makeTexts(_ fW: CGFloat, _ fH: CGFloat) {
        titleText = SKLabelNode(text: "Triangle Vertices")
        titleText.position.x = fW * 0.5
        titleText.position.y = fH * 0.8
        frameNo = SKLabelNode(text: "Frame: 0")
        frameNo.position = titleText.position
        frameNo.position.x += fW * 0.5
    }
    
    init( s: AnimationScene) {
        super.init(0, 10, s: s)
    }
    
    func setFrame(_ to: Int) {
        frameNo.text = "Ready to play frame: \(to)"
    }
    
    override func setupNodes() {
        makeTexts( scene.fWidth, scene.fHeight )
        appendNode(titleText)
//        appendNode(frameNo)
        titleText.text = "Equilateral Triangle"

    }
    override func customAnimation() {
        if fIndex == 0 {
            titleText.text = "Equilateral Triangle"
        }
        if fIndex == 1 {
            titleText.text = "Vectorize Side"
        }
        if fIndex == 2 {
            titleText.text = "Rotate 90°"
        }
        
        
        if fIndex == 4 {
            titleText.text = "Use tangent to find height"
        }
        
        
        if fIndex == 5 {
            titleText.text = "Unit vector multiplied by height"
        }
        
        
        if fIndex == 6 {
            titleText.text = "new triangle created"
        }
        
        
        if fIndex == 8 {
            titleText.text = "first iteration"
        }
        
        if fIndex == 9 {
            titleText.text = "new points"

        }
        
        if fIndex == 10 {
            titleText.text = "second iteration"

        }
        if fIndex == 11 {
            titleText.text = "third iteration"
        }
        
        if fIndex == 12 {
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
