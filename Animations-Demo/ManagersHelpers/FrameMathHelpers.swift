
import SpriteKit
import simd

extension CGFloat: SIMDScalar {
    public typealias SIMDMaskScalar = Int
    
    public typealias SIMD2Storage = SIMD2<CGFloat>
    
    public typealias SIMD4Storage = SIMD4<CGFloat>
    
    public typealias SIMD8Storage = SIMD8<CGFloat>
    
    public typealias SIMD16Storage = SIMD16<CGFloat>
    
    public typealias SIMD32Storage = SIMD32<CGFloat>
    
    public typealias SIMD64Storage = SIMD64<CGFloat>
    
}

typealias cg_float2 = SIMD2<CGFloat>

extension NSColor {
    convenience init(_ from: float4) {
        self.init(red: CGFloat(from.x), green: CGFloat(from.y), blue: CGFloat(from.z), alpha: CGFloat(from.w))
    }
}

extension CGVector {
    init(_ from: CGPoint) {
        self.init(dx: from.x, dy: from.y)
    }
}

extension CGPoint {
    init(_ from: CGVector) {
        self.init(x: from.dx, y: from.dy)
    }
}


extension CGVector: SIMDStorage {
    
    init(_ repeating: CGFloat) {
        self.init(dx: repeating, dy: repeating)
    }
    
    public static func * (lhs: CGVector, rhs: CGVector) -> CGFloat {
        return lhs.dx * rhs.dx + lhs.dy * rhs.dy
    }
    public static func / (lhs: CGVector, rhs: CGFloat) -> CGVector {
        return CGVector(dx : lhs.dx / rhs ,dy: lhs.dy / rhs)
    }
    
    public var magnitude: CGFloat {
        return  self * self / sqrt( self * self )
    }
    // didnt work with simd ?
    public static func + (lhs: CGVector, rhs: CGVector) -> CGVector {
        return CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }
    public static func - (lhs: CGVector, rhs: CGVector) -> CGVector {
        return CGVector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
    }
    // tried to have simd handle these automatically, but it didnt work
    
    public var scalarCount: Int { return 2 }
    
    public subscript(index: Int) -> CGFloat {
        get {
            if (index == 0) { return dx }
            if (index == 1) { return dy }
            return 0
        }
        set(newValue) {
            if (index == 0) { dx = newValue }
            if (index == 1) { dy = newValue }
        }
    }
    
    public typealias Scalar = CGFloat
}

extension CGPoint: SIMDStorage {
    init(_ repeating: CGFloat) {
        self.init(x: repeating, y: repeating)
    }
    
    init(_ x: Double, _ y: Double) {
        self.init(x: CGFloat(x), y: CGFloat(y))
    }
    
    public static func * (lhs: CGPoint, rhs: CGPoint) -> CGFloat {
        return lhs.x * rhs.x + lhs.y * rhs.y
    }
    
    public static func * (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(lhs.x * rhs , lhs.y * rhs)
    }
    public static func * (lhs: CGFloat, rhs: CGPoint) -> CGPoint {
        return CGPoint(lhs * rhs.x , lhs * rhs.y)
    }

    public static func / (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(x : lhs.x / rhs ,y: lhs.y / rhs)
    }
    
    public var normalized: CGPoint {
        return self / self.magnitude
    }
    
    public var magnitude: CGFloat {
        return sqrt( self * self )
    }
    
    public var toSIMDFloat: SIMD2<Float> {
        return SIMD2<Float>(Float(self.x), Float(self.y))
    }
    
    // didnt work with simd ?
    public static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    public static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    // tried to have simd handle these automatically, but it didnt work
    
    public var scalarCount: Int { return 2 }
    
    public subscript(index: Int) -> CGFloat {
        get {
            if (index == 0) { return x }
            if (index == 1) { return y }
            return 0
        }
        set(newValue) {
            if (index == 0) { x = newValue }
            if (index == 1) { y = newValue }
        }
    }
    
    public typealias Scalar = CGFloat
}

extension CGSize {
    init(_ from: CGFloat) {
        self.init(width: from, height: from)
    }
}

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


// It's dumb how this doesnt come out of box.
//extension CGPoint: FloatingPoint { }
