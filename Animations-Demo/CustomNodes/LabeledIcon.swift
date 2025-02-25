import SpriteKit

class LabeledIcon: SKNode {
    var icon: SKShapeNode!
    var label: CustomFloatingLabel!
    
    
    init(labelOnRight: Bool = false,
         fileName: String,
         center: CGPoint,
         title: String,
         description: String
        ) {
        icon = SKShapeNode(circleOfRadius: 40)
        icon.fillTexture = SKTexture(imageNamed: fileName)
        icon.fillColor = .white
        icon.position = center
        icon.lineWidth = 6
        icon.zPosition = -2
        
        label = CustomFloatingLabel(title: title,
                                    text: description,
                                    subject: icon,
                                    right: labelOnRight)
        super.init()
        
        label.zPosition += 1.0
        
        self.addChild(icon)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
