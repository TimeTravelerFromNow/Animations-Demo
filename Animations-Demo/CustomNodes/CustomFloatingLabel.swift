import SpriteKit

// FloatingUI style description, title
class CustomFloatingLabel: SKNode {
    let _WIDTH: CGFloat!
    let _PADDING: CGFloat! // == margin
    let _DURATION: TimeInterval = 0.6
    weak var subject: SKNode?
    var title: String
    var descriptionText: String
    
    var titleNode: SKLabelNode!
    var titleBackground: SKShapeNode!
    
    var descriptionNode: SKLabelNode!
    var descriptionBackground: SKShapeNode!
    
    init(title: String, text: String, subject: SKNode? = nil, width: CGFloat = 200, padding: CGFloat = 10) {
        self.subject = subject
        self.title = title
        self.descriptionText = text
        self._WIDTH = width
        self._PADDING = padding
        super.init()
        
        // left of subject
        var position = subject == nil ? nil : CGPoint(x: subject!.position.x - subject!.frame.minX, y: subject!.position.y)
        
        buildFloatingTitle(position: position)
        
        var descriptionPosition = self.titleNode.position
        buildFloatingDescription(position: descriptionPosition)
        self.hideAll()
    }
    
    func buildFloatingTitle(position: CGPoint?) {
        self.titleNode = SKLabelNode(fontNamed: "Chalkduster")
        
        self.titleNode.position = position ?? CGPoint(x:0,y:0)
        
        self.titleNode.text = self.title
        var titleRect = titleNode.frame.insetBy(dx: -10, dy: -10)
        // override size with _WIDTH constant
        var titleSize = CGSize(width: _WIDTH, height: titleRect.height + 10)
        
        // SKShapeNode(rectOf: textParentNode) instead of rect: uses the size at center to make shape
        self.titleBackground = SKShapeNode(rectOf: titleSize, cornerRadius: 10)
        titleBackground.fillColor = .white
        titleNode.fontColor = .black
        titleNode.verticalAlignmentMode = .center
        
        self.addChild(titleNode)
        titleBackground.zPosition = -1
        titleNode.addChild(titleBackground)
    }
    
    func buildFloatingDescription(position: CGPoint?) {
        
        self.descriptionNode = SKLabelNode(fontNamed: "Chalkduster")
        
        self.descriptionNode.position = position ?? CGPoint(x:0,y:0)

        // allow 0 (undefined #) of lines (default 1)
        self.descriptionNode.numberOfLines = 0

        self.descriptionNode.lineBreakMode = .byWordWrapping
        self.descriptionNode.preferredMaxLayoutWidth = _WIDTH
        self.descriptionNode.verticalAlignmentMode = .center

        self.descriptionNode.text = self.descriptionText
        self.descriptionNode.fontSize = 12
        
        var backgroundRectangle = descriptionNode.frame.insetBy(dx: -10, dy: -10)
        self.descriptionBackground = SKShapeNode(rectOf: backgroundRectangle.size, cornerRadius: 10)
        descriptionBackground.fillColor = .white
        descriptionNode.fontColor = .black
        
        descriptionNode.position.y -= 50
        self.addChild(descriptionNode)
        descriptionBackground.zPosition = -1
        descriptionNode.addChild(descriptionBackground)
    }
    
    
    private var _fIA: SKAction { return SKAction.fadeIn(withDuration: _DURATION) }

    private var _fadeOutAll: SKAction { return SKAction.customAction(withDuration: _DURATION) {
        (node : SKNode!, elapsedTime : CGFloat) -> Void in
            node.alpha = 1.0 - elapsedTime / self._DURATION
        }
    }
    private var _removeFromParent: SKAction { return SKAction.customAction(withDuration: 0) {
        (node : SKNode!, elapsedTime : CGFloat) -> Void in
            self.removeFromParent()
        }
    }
    private var _fadeOutAndRemove: SKAction { return SKAction.sequence([_fadeOutAll, _removeFromParent]) }

    func hideAll() {
        for node in children {
            node.alpha = 0.0
        }
    }
    
    func animateFadeIn() {
        // First run title fade in, then description
        if self.titleNode.alpha == 0.0 {
            self.titleNode.run(_fIA)
            self.titleBackground.run(_fIA)
        } else if self.descriptionNode.alpha == 0.0 {
            self.descriptionNode.run(_fIA)
            self.descriptionBackground.run(_fIA)
        }
    }
    
    func animateFadeOut() {
        self.run(_fadeOutAndRemove)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
