import SpriteKit

enum DestinationIconType {
    case VPS
    case Mina
    case SSH
    case Postgres
    case Unicorn
    case Nginx
    case HTTPS
}


class DeployJourneyAnimation: Animation {
    var bgImage: SKNode!
    var pathNode: SKShapeNode!
    var dashedPathNode: SKShapeNode!
    
    let destinationOrder: [DestinationIconType] = [.VPS, .SSH, .Unicorn]
    var destinationIconNodes: [DestinationIconType:SKShapeNode] = [:]
    let destinationFileNames: [DestinationIconType:String] =
    [.VPS:"digital-ocean-logo.png",
     .SSH:"ssh-console.png",
     .Unicorn:"unicorn-logo.png"
    ]
    let destinationPositions: [DestinationIconType:CGPoint] =
    [.VPS:CGPoint(x:-300,y:200),
     .SSH:CGPoint(x:-100,y:180),
     .Unicorn:CGPoint(x: 10, y: -200)
    ]
    var pathPositions: [CGPoint] { return destinationOrder.map { destinationPositions[$0]! } }
    var pathPositionsCopy: [CGPoint] = []
    
    override func setupNodes() {
        self.bgImage = SKSpriteNode(imageNamed: "middle-earth-3rd-age.png")
        self.pathPositionsCopy = pathPositions
        self.pathNode = CustomSplinePath(splinePoints: &pathPositionsCopy, count: pathPositionsCopy.count)
        self.dashedPathNode = DashedSplinePath(fromSplinePath: pathNode.path!)

        bgImage.zPosition = -2
        bgImage.position = self.scene!.getCenter()
        pathNode.position = self.scene!.getCenter()
        dashedPathNode.position = self.scene!.getCenter()

        appendNode(self.dashedPathNode)
        appendNode(bgImage)
        appendNode(pathNode)
//        buildDestinationIcons()
    }
    
    private func buildDestinationIcons() {
        destinationIconNodes.updateValue(createLogoIcon(iconType: .SSH), forKey: .SSH)
        destinationIconNodes.updateValue(createLogoIcon(iconType: .VPS), forKey: .VPS)
        destinationIconNodes.updateValue(createLogoIcon(iconType: .Unicorn), forKey: .Unicorn)

        for (_, iconNode) in destinationIconNodes {
            appendNode(iconNode)
        }
    }
        
    private func createLogoIcon(iconType: DestinationIconType) -> SKShapeNode {
        guard let imageNamed = destinationFileNames[iconType] else { fatalError("no file string for \(iconType)") }
        guard let position = destinationPositions[iconType] else { fatalError("no position for \(iconType)") }
        var icon = SKShapeNode(circleOfRadius: 40)
        icon.fillTexture = SKTexture(imageNamed: imageNamed)
        icon.fillColor = .white
        icon.lineWidth = 10
        icon.position = self.scene!.getCenter() + position
        return icon
    }
    
    override func setupAnimationCode() {
        addAnimationFrame {
          print("initialized")
            
        }
        addAnimationFrame {
            (self.scene as! AnimationScene).zoomCam(s: 2.5, d: 0.4)
            (self.dashedPathNode as! DashedSplinePath).animateDottedPath()
        }
        addAnimationFrame {
            print("cleanup frame")
        }
    }
    
    override func cleanup() {
//       ( self.dashedPathNode as! DashedSplinePath).cleanup()
    }
}

