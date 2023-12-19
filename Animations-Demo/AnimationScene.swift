
import SpriteKit
import GameplayKit

class AnimationScene: SKScene {
    
    var keysDown: [UInt16] = []
    var titleAnimator: TitleTextA?
    
    var frameNumber: Int = 0 { didSet { titleAnimator?.setFrame(frameNumber) } }
    
    var fWidth : CGFloat  { return self.frame.width  }
    var fHeight : CGFloat { return self.frame.height  }
    private var _startT: TimeInterval = 0
    private var _timeEl: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        _startT = CACurrentMediaTime()

        runSnowflakeMakingCode()
        
        var cam = SKCameraNode()
        addChild(cam)
        cam.position = CGPoint(x: fWidth / 2,y: fHeight / 2)
        
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
        
        if Int(_timeEl) % 2 == 0 && frameNumber < 10 { // every 2 seconds next frame
            if _animationDelay > 0.0 {
                _animationDelay -= tStep
            } else {
                AnimationManager.NextFrame()
                frameNumber += 1
                _animationDelay = 1
                if frameNumber == 10 { _animationDelay = 4 }
            }
        } else if frameNumber == 10 {
            // show off the last triangle a few seconds more..
            if _animationDelay > 0.0 {
                _animationDelay -= tStep
            } else {
                _animationDelay = 1
                frameNumber += 1
            }
        }
        
        if frameNumber > 10 {
            frameNumber = 0
            _animationDelay = 0
            AnimationManager.StopAll()
        }
        
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
