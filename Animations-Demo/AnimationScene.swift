//
//  GameScene.swift
//  Animations-Demo
//
//  Created by sebi d on 12/14/23.
//

import SpriteKit
import GameplayKit

class AnimationScene: SKScene {
    
    var keysDown: [UInt16] = []
    var titleAnimator: TitleTextA?
    
    var frameNumber: Int = 0 { didSet { titleAnimator?.setFrame(frameNumber) } }
    
    var fWidth : CGFloat  { return self.frame.width  }
    var fHeight : CGFloat { return self.frame.height  }
  
    override func didMove(to view: SKView) {
        var cam = SKCameraNode()
        addChild(cam)
        cam.position = CGPoint(x: fWidth / 2,y: fHeight / 2)
        
        self.camera = cam
        AnimationManager.Initialize(self)
        titleAnimator = AnimationManager.getAnimation(.TitleText) as? TitleTextA
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
    
    override func update(_ currentTime: TimeInterval) {
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
