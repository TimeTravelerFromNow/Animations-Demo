
import SpriteKit

extension SKNode : Frameable {
    func padIn(_ frame: SKNode, _ percentX: CGFloat, _ percentY: CGFloat) {
        self.position = frame.position
        self.xScale = ( 1 - percentX )
        self.yScale = 1 - percentY
    }
    
    
    func getCenter() -> CGPoint {
        return CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
    }
    
    func ndcToScene(_ coords: inout [CGPoint]) {
        for i in 0..<coords.count {
            coords[i].x = ( coords[i].x + 1 ) * self.frame.width / 2
            coords[i].y = ( coords[i].y + 1 ) * self.frame.height / 2
        }
    }
}

protocol Frameable {
    func getCenter() -> CGPoint
    
    func padIn(_ frame: SKNode, _ percentX: CGFloat, _ percentY: CGFloat)
}
