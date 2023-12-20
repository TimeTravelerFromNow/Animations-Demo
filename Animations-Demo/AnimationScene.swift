
import SpriteKit
import GameplayKit

class AnimationScene: SKScene {
    
    var keysDown: [UInt16] = []
    var titleAnimator: TitleTextA?
    
    var frameNumber: Int = 0 { didSet { titleAnimator?.setFrame(frameNumber) } }
    
    var fWidth : CGFloat  { return self.frame.width  }
    var fHeight : CGFloat { return self.frame.height  }
    var fCenter: CGPoint { return CGPoint(fWidth * 0.5, fHeight * 0.5) }
    private var _startT: TimeInterval = 0
    private var _timeEl: TimeInterval = 0
    
    let triOffset: CGFloat = 90
    
    func moveCam(to: CGPoint, d: TimeInterval) {
        let mA = SKAction.move(to: to, duration: d)
        self.camera?.run(mA)
    }
    
    func returnCam(d: TimeInterval) {
        var triCenter = fCenter
        triCenter.y -= triOffset
        let mA = SKAction.move(to: triCenter, duration: d )
        self.camera?.run(mA)
    }
    
    func zoomCam(s: CGFloat, d: TimeInterval){
        let zA = SKAction.scale(to: s, duration: d)
        self.camera?.run(zA)
    }
    
    func unZoomCam(d: TimeInterval) {
        let zA = SKAction.scale(to: 1, duration: d)
        self.camera?.run(zA)
    }
    
    
    override func didMove(to view: SKView) {
        _startT = CACurrentMediaTime()

        runSnowflakeMakingCode()
        
        var cam = SKCameraNode()
        addChild(cam)
        cam.position = CGPoint(x: fWidth / 2,y: fHeight / 2 - triOffset)
        
        self.camera = cam
        AnimationManager.Initialize(self)
        titleAnimator = AnimationManager.getAnimation(.TitleText) as? TitleTextA
        
        self.backgroundColor = NSColor(red: 39 / 255, green: 41 / 255, blue: 69 / 255, alpha: 1)
    }
    
    func runSnowflakeMakingCode() {
        // MARK: kinda hacky, but Im converting my NDC to scene coordinates here. (ONLY CALL ONCE)
        self.ndcToScene(&FractalData.zeroIteration)
        var sfMaker = SnowflakeMaker()
        sfMaker.kochIteration()
        sfMaker.kochIteration()
        sfMaker.kochIteration()
    }
    
    override func mouseDown(with event: NSEvent) {
        AnimationManager.NextFrame()
        frameNumber += 1
    }
    override func keyUp(with event: NSEvent) {
        let key = event.keyCode
        KeyboardManager.KeyUp(key)
        if event.keyCode == Keycode.space.rawValue {
            frameNumber = 0
            AnimationManager.StopAll()
        }
    }
    
    override func keyDown(with event: NSEvent) {
        KeyboardManager.KeyDown(event.keyCode)
    }
    
    private var _animationDelay: TimeInterval = 1 // needed so an animation can finish
    
    override func update(_ currentTime: TimeInterval) {
        _timeEl = currentTime - _startT
        let tStep: CGFloat = 0.0166
        
        
        guard let cam = self.camera else { print("no camera in scene"); return }
        if( KeyboardManager.KeyPressed(Keycode.w)) {
            cam.position.y += tStep * 100
        }
        if( KeyboardManager.KeyPressed(Keycode.s)) {
            cam.position.y -= tStep * 100
        }
        if( KeyboardManager.KeyPressed(Keycode.d)) {
            cam.position.x += tStep * 100
        }
        if( KeyboardManager.KeyPressed(Keycode.a)) {
            cam.position.x -= tStep * 100
        }
        if( KeyboardManager.KeyPressed(Keycode.upArrow)) {
            camera?.xScale -= tStep
            camera?.yScale -= tStep
        }
        if( KeyboardManager.KeyPressed(Keycode.downArrow)) {
            camera?.xScale += tStep
            camera?.yScale += tStep
        }
        // Called before each frame is rendered
    }
}
