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
    var dashedSplinePath: CustomDashedSpline!
    
    let destinationOrder: [DestinationIconType] = [.VPS, .SSH, .Unicorn, .Nginx]
    var destinationIconNodes: [DestinationIconType:SKShapeNode] = [:]
    let destinationFileNames: [DestinationIconType:String] =
    [.VPS:"digital-ocean-logo.png",
     .SSH:"ssh-console.png",
     .Unicorn:"unicorn-logo.png",
     .Nginx:"nginx_logo_dark.png"
    ]
    let destinationPositions: [DestinationIconType:CGPoint] =
    [.VPS:CGPoint(x:-300,y:200),
     .SSH:CGPoint(x:-100,y:180),
     .Unicorn:CGPoint(x: 10, y: -200),
     .Nginx:CGPoint(x: 70, y: -100)
    ]
    var floatingLabels: [DestinationIconType:CustomFloatingLabel] = [:]
    var pathPositions: [CGPoint] { return destinationOrder.map { destinationPositions[$0]! } }
    var pathPositionsCopy: [CGPoint] = []
    
    override func setupNodes() {
        self.bgImage = SKSpriteNode(imageNamed: "middle-earth-3rd-age.png")
        self.pathPositionsCopy = pathPositions
        
        bgImage.zPosition = -10
        bgImage.position = self.scene!.getCenter()
        
        var splineShapeNode = SKShapeNode(splinePoints: &pathPositionsCopy, count: pathPositionsCopy.count)
        var splinePath = splineShapeNode.path!
        
        dashedSplinePath = CustomDashedSpline(sourcePath: splinePath )
        dashedSplinePath.position = self.scene!.getCenter()
        dashedSplinePath.setPathFractions(destinationFractions())

        appendNode(dashedSplinePath)
        
        appendNode(bgImage)
        buildDestinationIcons()
        buildFloatingLabels()
    }
    
    func destinationFractions() -> [Float] {
        // linear approximation for animating the progress across autogenerated spline.
        var length:Float = 0.0
        var prevPoint = pathPositions.first
        //calc length
        for i in 1..<pathPositions.count {
            let destination = pathPositions[i]
            length += distance(prevPoint!.toSIMDFloat, destination.toSIMDFloat)
            prevPoint = destination
        }
        
        //calculating each segments distance
        var outputSegmentPercentLengths = [Float].init(repeating: 0.0, count: pathPositions.count)
        var fractionSum: Float = 0.0
        prevPoint = pathPositions.first
        // first output value is 0.0
        for i in 1..<pathPositions.count {
            let destination = pathPositions[i]
            fractionSum += distance(prevPoint!.toSIMDFloat, destination.toSIMDFloat) / length
            outputSegmentPercentLengths[i] = fractionSum
            prevPoint = destination
        }
        
        return outputSegmentPercentLengths
    }
    
    
    private func buildDestinationIcons() {
        destinationIconNodes.updateValue(createLogoIcon(iconType: .SSH), forKey: .SSH)
        destinationIconNodes.updateValue(createLogoIcon(iconType: .VPS), forKey: .VPS)
        destinationIconNodes.updateValue(createLogoIcon(iconType: .Unicorn), forKey: .Unicorn)
        destinationIconNodes.updateValue(createLogoIcon(iconType: .Nginx), forKey: .Nginx)

        for (_, iconNode) in destinationIconNodes {
            appendNode(iconNode)
        }
    }
    
    private func buildFloatingLabels() {
        for (title, descriptionText, destinationType) in deployJourneyDescriptionData {
            floatingLabels.updateValue(CustomFloatingLabel(title: title,
                                                           text: descriptionText,
                                                           subject: destinationIconNodes[destinationType]),
                                       forKey: destinationType)
            
        }
    }
    
        
    private func createLogoIcon(iconType: DestinationIconType) -> SKShapeNode {
        guard let imageNamed = destinationFileNames[iconType] else { fatalError("no file string for \(iconType)") }
        guard let position = destinationPositions[iconType] else { fatalError("no position for \(iconType)") }
        var icon = SKShapeNode(circleOfRadius: 40)
        icon.fillTexture = SKTexture(imageNamed: imageNamed)
        icon.fillColor = .white

        icon.position = self.scene!.getCenter() + position
        return icon
    }
    
    override func setupAnimationCode() {
        addAnimationFrame {
            (self.scene as! AnimationScene).zoomCam(s: 2, d: 0.4)
        }
        
        // first animate camera going to each destination, and fade in floating labels describing destination.
        for (i, destination) in destinationOrder.enumerated() {
            // each path line animation sequence
            addAnimationFrame {
                guard let animationScene = (self.scene as? AnimationScene) else { return }
                animationScene.moveCam(to: self.destinationPositions[destination]! + animationScene.getCenter(), d: 1.0)
            }
            
            if let floatingLabel = floatingLabels[destination] {
                if !(floatingLabel.inParentHierarchy(self)) { self.addChild(floatingLabel) }
                //title fade in
                addAnimationFrame {
                    floatingLabel.animateFadeIn()
                }
                // description fade in
                addAnimationFrame {
                    floatingLabel.animateFadeIn()
                }
                //fade out
                addAnimationFrame {
                    floatingLabel.animateFadeOut()
                }
            }
        }
        
        // Then after we can animate the red dotted path journey
        for (i, destination) in destinationOrder.enumerated() {
            addAnimationFrame {
                guard let animationScene = (self.scene as? AnimationScene) else { return }
                animationScene.moveCam(to: self.destinationPositions[destination]! + animationScene.getCenter(), d: 1.0)
            }
            if i == 0 { continue }
                            
            addAnimationFrame {
                self.dashedSplinePath.animate(from: i - 1, to: i)
            }
        }
        
        addAnimationFrame {
            print("last spacer frame!")
        }
    }
    
    override func cleanup() {
        dashedSplinePath.reset()
        // dont retain nodes, cant rerun the animation without bugs otherwise
        destinationIconNodes = [:]
        floatingLabels = [:]
    }
}

