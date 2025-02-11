import SpriteKit

class DeployJourneyAnimation: Animation {
    
    var bgImage: SKNode!
    var pathNode: SKShapeNode!
    
    let snakePts: [Float] =
    [175.96630859375, 301.2537841796875,
    166.5041961669922, 304.3199157714844,
    252.41085815429688, 355.89569091796875,
    335.1018981933594, 238.66452026367188,
    465.4582824707031, 335.59783935546875]
    func makeFromData(points: [Float]) -> [CGPoint] {
        let outCount = Int(floorf(Float(points.count / 2)))
        var out = [CGPoint].init(repeating: CGPoint(0.0), count: outCount )
        for i in 0..<outCount {
            let srcInd = i * 2
            out[i].x = CGFloat(points[srcInd])
            out[i].y = CGFloat(points[srcInd + 1])
        }
        return out
    }
    override func setupNodes() {
        self.bgImage = SKSpriteNode(imageNamed: "middle-earth-3rd-age.png")
//        var points = [CGPoint].init(repeating: CGPoint(0.0), count: 5)
//        points[0].x = 0
//        points[1].y = -4
        var points = makeFromData(points: snakePts)
        
        self.pathNode = SKShapeNode(splinePoints: &points, count: points.count)
//        SKShapeNode(
        bgImage.position = self.scene!.getCenter()
        pathNode.position = self.scene!.getCenter()
        appendNode(bgImage)
        appendNode(pathNode)
    }
    override func setupAnimationCode() {
        addAnimationFrame {
          print("initialized")
        }
        addAnimationFrame {
            (self.scene as! AnimationScene).zoomCam(s: 2.0, d: 1.0)
            (self.scene as! AnimationScene).moveCam(to: self.bgImage.position + CGPoint(x: 300, y: 200), d: 1.0)

        }
        addAnimationFrame {
            print("cleanup frame")
        }
    }
}

