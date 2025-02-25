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
        
        label = CustomFloatingLabel(title: title,
                                    text: description,
                                    subject: icon,
                                    right: labelOnRight)
        super.init()
        
        label.zPosition = self.zPosition

        self.addChild(icon)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
