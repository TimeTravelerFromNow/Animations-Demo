import SpriteKit

// FloatingUI style description, title
class CustomFloatingLabel: SKNode {
    weak var subject: SKNode?
    var title: String
    var descriptionText: String
    
    var titleNode: SKLabelNode!
    // SKShapeNode(rectOf: textParentNode) instead of rect: uses the size at center to make shape
    var titleBackground: SKShapeNode!
    
    var descriptionNode: SKLabelNode!
    var descriptionBackground: SKShapeNode!
    
    init(title: String, text: String, subject: SKNode? = nil) {
        self.subject = subject
        self.title = title
        self.descriptionText = text
        super.init()
        
        buildFloatingTitle(position: subject?.position)
        var descriptionPosition = self.titleNode.position
        buildFloatingDescription(position: descriptionPosition)
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
    
    func buildFloatingDescription(position: CGPoint?) {
        
        self.descriptionNode = SKLabelNode(fontNamed: "Chalkduster")
        
        self.descriptionNode.position = position ?? CGPoint(x:0,y:0)

        // allow 0 (undefined #) of lines (default 1)
        self.descriptionNode.numberOfLines = 0

        self.descriptionNode.lineBreakMode = .byWordWrapping
        self.descriptionNode.preferredMaxLayoutWidth = 200
        self.descriptionNode.verticalAlignmentMode = .top

        
        self.descriptionNode.text = self.descriptionText
        self.descriptionNode.fontSize = 12
        
        var backgroundRectangle = descriptionNode.frame.insetBy(dx: -10, dy: -10)
        self.descriptionBackground = SKShapeNode(rectOf: backgroundRectangle.size, cornerRadius: 10)
        descriptionBackground.fillColor = .white
        descriptionNode.fontColor = .black
        
        descriptionNode.position.y -= 40
        self.addChild(descriptionNode)
        descriptionBackground.zPosition = -1
        descriptionNode.addChild(descriptionBackground)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
