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
    private var _arrowPoints: [CGPoint] = []
    
    init(title: String, text: String, subject: SKNode? = nil, right: Bool = true, width: CGFloat = 200, padding: CGFloat = 10) {
        self.subject = subject
        self.title = title
        self.descriptionText = text
        self._WIDTH = width
        self._PADDING = padding
        super.init()
        
        // left of subject
        let horizontalOffset: CGFloat! = right ? _WIDTH : -_WIDTH
//        horizontalOffset = horizontalOffset
        let position = subject == nil ? nil : CGPoint(x: subject!.position.x + horizontalOffset, y: subject!.position.y)
        
        buildFloatingTitle(position: position)
        
        var descriptionPosition = self.titleNode.position
        descriptionPosition.y -= self.titleNode.frame.size.height
        buildFloatingDescription(position: descriptionPosition)
        
        let arrowNode = makeArrow(right: right)
        arrowNode.position.x += right ? -titleBackground.frame.width / 2 : titleBackground.frame.width / 2
        arrowNode.fillColor = .white
        arrowNode.lineWidth = 1
        arrowNode.strokeTexture?.filteringMode = .nearest
        self.titleNode.addChild(arrowNode)
        self.hideAll()
        
        arrowNode.strokeColor = .black
    }
        
    private func makeArrow(right: Bool) -> SKShapeNode {
        let trianglePath = CGMutablePath()
        _arrowPoints = right ?
          [CGPoint(4.0,-10.0),CGPoint(-30.0,0.0),CGPoint(4.0,10.0)] :
          [CGPoint(-4.0,10.0),CGPoint(30.0,0.0),CGPoint(-4.0,-10.0)]

        return SKShapeNode(points: &_arrowPoints, count: 3)
    }
    
    func buildFloatingTitle(position: CGPoint?) {
        self.titleNode = SKLabelNode(fontNamed: "Big Caslon")
        
        self.titleNode.position = position ?? CGPoint(x:0,y:0)
        
        self.titleNode.text = self.title
        let titleRect = titleNode.frame.insetBy(dx: -_PADDING, dy: -_PADDING)
        // override size with _WIDTH constant
        let titleSize = CGSize(width: _WIDTH + _PADDING, height: titleRect.height)
        
        // SKShapeNode(rectOf: textParentNode) instead of rect: uses the size at center to make shape
        self.titleBackground = SKShapeNode(rectOf: titleSize, cornerRadius: _PADDING)
        titleBackground.fillColor = .white
        titleBackground.strokeColor = .black
        titleNode.fontColor = .black
        titleNode.verticalAlignmentMode = .center
        
        self.addChild(titleNode)
        titleBackground.zPosition = -1
        titleNode.addChild(titleBackground)
    }
    
    func buildFloatingDescription(position: CGPoint?) {
        
        self.descriptionNode = SKLabelNode(fontNamed: "Big Caslon")
        
        self.descriptionNode.position = position ?? CGPoint(x:0,y:0)

        // allow 0 (undefined #) of lines (default 1)
        self.descriptionNode.numberOfLines = 0

        self.descriptionNode.lineBreakMode = .byWordWrapping
        self.descriptionNode.preferredMaxLayoutWidth = _WIDTH
        self.descriptionNode.verticalAlignmentMode = .center

        self.descriptionNode.text = self.descriptionText
        self.descriptionNode.fontSize = 12
        
        let backgroundRectangle = descriptionNode.frame.insetBy(dx: -_PADDING, dy: -_PADDING)
        let backgroundSize = CGSize(width: _WIDTH + _PADDING, height: backgroundRectangle.height)
        self.descriptionBackground = SKShapeNode(rectOf: backgroundSize, cornerRadius: 10)
        descriptionBackground.fillColor = .white
        descriptionBackground.strokeColor = .black
        descriptionNode.fontColor = .black
        
        descriptionNode.position.y -= descriptionNode.frame.height / 2 + _PADDING
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
