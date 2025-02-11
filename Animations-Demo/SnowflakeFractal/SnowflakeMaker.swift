// porting from my Metal Chroma Snowflake Project
// MARK: I was being lazy and copied the code.
// It could be rewritten to only provide what is needed for the animations,
// but I am saving myself some time doing this.
import simd
import CoreGraphics

final class SnowflakeMaker {
    private var _time: Float = 0
    private let snowflakeColor = float4(0.85,0.86, 0.9, 1.0)
    
    
    private var vertices:  [ CustomVertex ] = []
    
    private var _indices: [ uint32 ] = []
    // need to store indices in the order of the sides on the outside
    private var _outsideIndices: [ uint32 ] = []
    
    var iterationNo: Int = 0
    
    func kochIteration() {
        // new vertex amount
        let newVertexCount = _outsideIndices.count + _outsideIndices.count * 3
        
        var newIndexArr = [ uint32 ].init(repeating: 0, count: newVertexCount)
        var newVerticesArr = [ CustomVertex ].init(repeating: CustomVertex(position: float3(0,0,0), color: float4(0.5,0.5,1.0,1.0)), count: newVertexCount)
        
        var newOutsideIndicesArr = newIndexArr
        
        //save old indices only for drawing new triangles
        for i in 0..<_indices.count {
            newIndexArr[i] = _indices[i]
            newVerticesArr[i] = vertices[i]
        }
        
        var newTriOffset = 1
        var newIndexOffset = uint32(_outsideIndices.count)
        // construct new positions, save the triangle
        for i in 0..<_outsideIndices.count - 1 {
            let firstIndex = Int(_outsideIndices[i])
            let secondIndex = Int(_outsideIndices[i + 1])
            let newTriangle = _newTri(v0: vertices[firstIndex].position, v1: vertices[secondIndex].position )
            
            newVerticesArr[Int(newIndexOffset)]     = CustomVertex(position: newTriangle[0], color: snowflakeColor)
            newVerticesArr[Int(newIndexOffset) + 1] = CustomVertex(position: newTriangle[1], color: snowflakeColor)
            newVerticesArr[Int(newIndexOffset) + 2] = CustomVertex(position: newTriangle[2], color: snowflakeColor)
            
            // populate new outside indices array in place
            newOutsideIndicesArr[newTriOffset - 1] = _outsideIndices[i]// old index ( using - 1 )
            newOutsideIndicesArr[newTriOffset] = newIndexOffset
            newOutsideIndicesArr[newTriOffset + 1] = newIndexOffset + 1
            newOutsideIndicesArr[newTriOffset + 2] = newIndexOffset + 2
            newOutsideIndicesArr[newTriOffset + 3] = _outsideIndices[i + 1]// old index
            
            // store these new indices for the drawing index buffer
            newIndexArr[Int(newIndexOffset)] = newIndexOffset
            newIndexArr[Int(newIndexOffset) + 1] = newIndexOffset + 1
            newIndexArr[Int(newIndexOffset) + 2] = newIndexOffset + 2
            
            newTriOffset += 4 // skip existing index by adding 4
            newIndexOffset += 3 // we only added 3 new vertices
        }
        // finish the triangle by adding the triangle between the first and last vertex
        
        let newTriangle = _newTri(v0: vertices[_outsideIndices.count - 1].position, v1: vertices[0].position )
        
        newVerticesArr[Int(newIndexOffset)]     = CustomVertex(position: newTriangle[0], color: snowflakeColor)
        newVerticesArr[Int(newIndexOffset) + 1] = CustomVertex(position: newTriangle[1], color: snowflakeColor)
        newVerticesArr[Int(newIndexOffset) + 2] = CustomVertex(position: newTriangle[2], color: snowflakeColor)
        // old vertex already stored in very first iteration
        
        
        newOutsideIndicesArr[newTriOffset - 1] = _outsideIndices[_outsideIndices.count - 1]// old index
        newOutsideIndicesArr[newTriOffset] = newIndexOffset
        newOutsideIndicesArr[newTriOffset + 1] = newIndexOffset + 1
        newOutsideIndicesArr[newTriOffset + 2] = newIndexOffset + 2
        // old index already made in very first iteration ( should == 0 )
        newIndexArr[Int(newIndexOffset)] = newIndexOffset
        newIndexArr[Int(newIndexOffset) + 1] = newIndexOffset + 1
        newIndexArr[Int(newIndexOffset) + 2] = newIndexOffset + 2
        // done with last triangle
        
        //override stored variables and write buffers
        _indices = newIndexArr
        _outsideIndices = newOutsideIndicesArr
        vertices = newVerticesArr
        
        if (iterationNo == 0) {
            //MARK: where we set first the fractal data., Zeroeth is in scene makeSnowflake()
            FractalData.firstIteration = vertices.map() { CGPoint(x: CGFloat($0.position.x),y: CGFloat($0.position.y)) }
            FractalData.firstIndices = _indices.map() { Int($0) }
            FractalData.outterIs_1 = _outsideIndices.map() { Int($0) }
        }
        if (iterationNo == 1) {
            //MARK: where we set the second fractal data.
            FractalData.secondIteration = vertices.map() { CGPoint(x: CGFloat($0.position.x),y: CGFloat($0.position.y)) }
            FractalData.secondIndices = _indices.map() { Int($0) }
            FractalData.outterIs_2 = _outsideIndices.map() { Int($0)}
        }
        
        if (iterationNo == 2) {
            //MARK: where we set the second fractal data.
            FractalData.thirdIteration = vertices.map() { CGPoint(x: CGFloat($0.position.x),y: CGFloat($0.position.y)) }
            FractalData.thirdIndices = _indices.map() { Int($0) }
            FractalData.outterIs_3 = _outsideIndices.map() { Int($0)}
        }
        iterationNo += 1
    }
    
    func resetTriangle() {
        
        //MARK: only thing I need to change is make the initial triangle in scene coordinates
        let zeroethCoords: [CustomVertex] = FractalData.zeroIteration.map() {
            CustomVertex(
                position: float3(Float($0.x), Float($0.y), 0.0),
                color: float4(0)
            )}
        
        vertices = zeroethCoords
        
        _indices = [
            0, 1, 2
        ]
        _outsideIndices = [
            0 , 1, 2
        ]
        iterationNo = 0
    }
    
    private func _newTri(v0 : float3, v1: float3) -> [float3] {
        var triOut = [float3].init(repeating: float3(0), count: 3)
        let sideV = v1 - v0
        let sideVLength = sqrt(sideV.x * sideV.x + sideV.y * sideV.y)
        
        triOut[0] = v0 + sideV / 3
        //        /  |
        //      /    | h      tan(60) = h / base = h / ( 0.5 * ( sideVLength / 3 ) )
        //    /60deg_|        h = tan(60) * all_that
        let h = tan( .pi / 3) * ( sideVLength / 6)
        triOut[1] = v0 + 0.5 * sideV + h * normalize(ninetyDegRotated(sideV))
        triOut[2] = v0 + 2 * sideV / 3
        return triOut
    }
    
    func ninetyDegRotated(_ sideVector: float3) -> float3 {
        let ninetyDegRotMat: [[Float]] = [
            [ 0, 1 ], // cos(pi/2) , - sin(pi/2)
            [ -1, 0 ]       //  sin(pi/2) , cos(pi/2)
        ]
        
        return float3( sideVector.y * ninetyDegRotMat[0][1], sideVector.x * ninetyDegRotMat[1][0] , sideVector.z )
    }
    
    init() {
        resetTriangle()
    }
}
