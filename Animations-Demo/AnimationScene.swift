//
//  GameScene.swift
//  Animations-Demo
//
//  Created by sebi d on 12/14/23.
//

import SpriteKit
import GameplayKit

class AnimationScene: SKScene {
    var titleAnimator: TitleTextA?
    
    var frameNumber: Int = 0 { didSet { titleAnimator?.setFrame(frameNumber) } }
    
    var fWidth : CGFloat  { return self.frame.width  }
    var fHeight : CGFloat { return self.frame.height  }
  
    override func didMove(to view: SKView) {
        AnimationManager.Initialize(self)
        titleAnimator = AnimationManager.getAnimation(.TitleText) as? TitleTextA
    }
    
    override func mouseDown(with event: NSEvent) {
        AnimationManager.NextFrame()
        frameNumber += 1
    }
    override func keyUp(with event: NSEvent) {
        if event.keyCode == Keycode.space {
            frameNumber = 0
            AnimationManager.StopAll()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
