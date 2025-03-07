
import SpriteKit
import GameplayKit

class AnimationScene: SKScene {
    var animation: Animation!
    var defaultZoom = 3.0
    var keysDown: [UInt16] = []
        
    var fWidth : CGFloat  { return self.frame.width  }
    var fHeight : CGFloat { return self.frame.height  }
    var fCenter: CGPoint { return CGPoint(fWidth * 0.5, fHeight * 0.5) }
    private var _startT: TimeInterval = 0
    private var _timeEl: TimeInterval = 0
    
    func moveCam(to: CGPoint, d: TimeInterval) {
        let mA = SKAction.move(to: to, duration: d)
        self.camera?.run(mA)
    }
    
    func returnCam(d: TimeInterval) {
        let mA = SKAction.move(to: fCenter, duration: d )
        self.camera?.run(mA)
    }
    
    func zoomCam(s: CGFloat, d: TimeInterval){
        let zA = SKAction.scale(to: s, duration: d)
        self.camera?.run(zA)
    }
    
    func unZoomCam(d: TimeInterval) {
        let zA = SKAction.scale(to: self.defaultZoom, duration: d)
        self.camera?.run(zA)
    }
    
    
    override func didMove(to view: SKView) {
        animation = DeployJourneyAnimation(self)
        _startT = CACurrentMediaTime()
        
        var cam = SKCameraNode()
        cam.setScale(self.defaultZoom)
        addChild(cam)
        cam.position = CGPoint(x: fWidth / 2,y: fHeight / 2)
        
        self.camera = cam
        
        self.backgroundColor = NSColor(red: 39 / 255, green: 41 / 255, blue: 69 / 255, alpha: 1)
    }
    
    override func mouseDown(with event: NSEvent) {
//        print(event.locationInWindow.x, event.locationInWindow.y)
        var inScenePos = event.location(in: self) - self.fCenter
        print(inScenePos.x, inScenePos.y)
    }
    override func keyUp(with event: NSEvent) {
        let key = event.keyCode
        KeyboardManager.KeyUp(key)
        if event.keyCode == Keycode.space.rawValue {
            animation.restart()
        }
    }
    
    override func keyDown(with event: NSEvent) {
        KeyboardManager.KeyDown(event.keyCode)
        if( event.keyCode == Keycode.rightArrow.rawValue) {
            animation.animateStep()
        }
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
