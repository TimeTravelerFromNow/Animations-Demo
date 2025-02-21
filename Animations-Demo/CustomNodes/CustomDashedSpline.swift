import SpriteKit

// Initialize a spline node first, then pass the path in here. call animate().
// thanks to Stackoverflow user Fault for helping me solve this with shaders
// https://stackoverflow.com/questions/79434753/animating-dashes-sequentially-over-a-spline-path-in-spritekit-how-can-i-fix-the
class CustomDashedSpline:SKShapeNode {
    var DURATION: TimeInterval = 1.0
    var startIndex: Int = 0
    var endIndex: Int = 1
    var _fractions: [CGFloat] = []
    //set up shader uniform
    let u_lerp = SKUniform(name: "u_lerp", float:0)
    //shader code
    let shader_lerp_path_distance:SKShader = SKShader(source: """
    //v_path_distance and u_path_length defined at
    //https://developer.apple.com/documentation/spritekit/creating-a-custom-fragment-shader
    void main(){
    //draw based on an animated value (u_lerp) in range 0-1
    if (v_path_distance < (u_path_length * u_lerp)) {
    gl_FragColor = vec4(1.0,0.2,0.2,1.0); //sample texture and draw fragment 
    } else {
    gl_FragColor = 0; //else don't draw
    }
    }
    """)
    var dottedLine: CGPath!
    init(sourcePath: CGPath) {
        super.init()
        self.path = sourcePath.copy(dashingWithPhase: 1, lengths: [10])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // helper: animate a value from 0-1 and update the shader uniform
    func lerp(a:CGFloat, b:CGFloat, percent:CGFloat) -> CGFloat {
        return (b-a) * percent + a
    }
    private var _dashesPathAnimation: SKAction {
        return SKAction.customAction(withDuration: DURATION) {
            (node : SKNode!, elapsedTime : CGFloat) -> Void in
                
                let elapsedAmount = CGFloat(elapsedTime / CGFloat(self.DURATION))
                
                let startFraction = self._fractions[self.startIndex]
                let endFraction = self._fractions[self.endIndex]
                            
                let animationFraction = self.lerp(a: startFraction,
                                                  b: endFraction,
                                                  percent:elapsedAmount)
                self.u_lerp.floatValue = Float(animationFraction)
        }
    }
    
    func animate(from: Int, to: Int) {
        print(" animating from \(from), to: \(to)")
        assert(to < self._fractions.count && to > 0)
        assert(from < self._fractions.count && from >= 0)
        
        self.startIndex = from
        self.endIndex = to
        
        setPathDrawProperties()
        
        self.run(_dashesPathAnimation)
    }
    
    func reset() {
        startIndex = 0 // DANGER bad code
        u_lerp.floatValue = 0.0
    }
    
    func setPathFractions(_ fractions: [Float]) {
        self._fractions = fractions.map { CGFloat($0) }
    }

    func setPathDrawProperties() {
        self.lineWidth = 10
        self.strokeColor = .red
        self.fillColor = .red
        
        shader_lerp_path_distance.uniforms = [ u_lerp ]
        self.strokeShader = shader_lerp_path_distance
    }
}
