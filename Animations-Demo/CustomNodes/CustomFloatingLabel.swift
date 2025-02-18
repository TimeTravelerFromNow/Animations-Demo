import SpriteKit

// FloatingUI style description, title
class CustomFloatingLabel: SKNode {
    weak var subject: SKNode?
    var title: String
    var descriptionText: String
    
    var titleNode: SKLabelNode!
    var titleBackground: SKShapeNode!
    
    var descriptionNode: SKLabelNode!
    var descriptionBackground: SKShapeNode!
    
    init(title: String, text: String, subject: SKNode? = nil) {
        self.subject = subject
        self.title = title
        self.descriptionText = text
        super.init()
        
        buildFloatingTitle(position: subject?.position)
        let descriptionOffset = self.titleBackground.frame.height + 20
        buildFloatingDescription(top: descriptionOffset)
    }
    
    func buildFloatingTitle(position: CGPoint?) {
        self.titleNode = SKLabelNode(fontNamed: "Chalkduster")
        
        self.titleNode.position = position ?? CGPoint(x:0,y:0)
        self.titleNode.text = self.title
        var titleRect = titleNode.frame.insetBy(dx: -10, dy: -10)
        self.titleBackground = SKShapeNode(rect: titleRect, cornerRadius: 10)
        titleBackground.fillColor = .white
        titleNode.fontColor = .black
        
        self.addChild(titleNode)
        self.addChild(titleBackground)
    }
    
    func buildFloatingDescription(top: CGFloat) {
        self.descriptionNode = SKLabelNode(fontNamed: "Chalkduster")
        
        self.descriptionNode.position = self.titleNode.position
        
        self.descriptionNode.text = self.descriptionText
        self.descriptionNode.fontSize = 8
        
        var backgroundRectangle = descriptionNode.frame.insetBy(dx: -10, dy: -10)
        self.descriptionBackground = SKShapeNode(rect: backgroundRectangle, cornerRadius: 10)
        descriptionBackground.fillColor = .white
        descriptionNode.fontColor = .black
        
        descriptionNode.position.y -= top
        descriptionBackground.position = descriptionNode.position
        
        self.addChild(descriptionNode)
        self.addChild(descriptionBackground)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
