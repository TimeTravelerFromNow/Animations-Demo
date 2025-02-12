import SpriteKit

class Animation: SKNode {
    private var _animationNodes: [SKNode] = []
    private lazy var _customAnimationFrameCodeBlocks: [ () -> (Void) ] = []
    
    var localFrame: Int = 0
    var frameCount: Int { return _customAnimationFrameCodeBlocks.count }
    
    // https://www.geeksforgeeks.org/escaping-and-non-escaping-closures-in-swift/
    func addAnimationFrame( customCode: @escaping () -> (Void) ) {
        _customAnimationFrameCodeBlocks.append(customCode)
    }
    
    init(_ scene: SKScene) {
        super.init()
        scene.addChild(self)
        setupNodes()
        setupAnimationCode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateStep() {
        if localFrame == 0 {
            _addNodesToScene()
        }
        
        if localFrame >= frameCount {
            // this animation is done, remove the nodes
            reset()
            return
        }
        
        // call the custom animation code
        _customAnimationFrameCodeBlocks[localFrame]()
        
        
        localFrame += 1
    }
    
    func setupNodes() { } // override this
    func setupAnimationCode() { } //override, do not call "return" in custom code.
    func cleanup() { }
        
    private func _removeNodesFromScene() {
        for n in _animationNodes {
            n.removeFromParent()
        }
    }
    
    private func _addNodesToScene() {
        guard let scene = self.scene else { print("Animation::WARN::no_scene"); return }
        for n in _animationNodes {
            scene.addChild(n)
        }
    }
    
    func reset() {
        localFrame = 0
        _removeNodesFromScene()
        (scene as! AnimationScene).returnCam(d: 0)
        (scene as! AnimationScene).unZoomCam(d: 0)
        cleanup()
    }
    
    // getters setters
    func appendNode(_ n: SKNode) { _animationNodes.append(n); }
    func setAnimationNodes(_ to: [SKNode]) { _animationNodes = to; }
    func appendNodes(contentsOf: [SKNode]) { _animationNodes.append(contentsOf: contentsOf); }
}
