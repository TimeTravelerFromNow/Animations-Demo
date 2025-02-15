import SpriteKit

// Initialize a spline node first, then pass the path in here. call animate().
// thanks to Stackoverflow user Fault for helping me solve this with shaders
// https://stackoverflow.com/questions/79434753/animating-dashes-sequentially-over-a-spline-path-in-spritekit-how-can-i-fix-the
class CustomDashedSpline:SKShapeNode {
    var DURATION: TimeInterval = 3.0
    
    //set up shader uniform
    let u_lerp = SKUniform(name: "u_lerp", float:0)
    //shader code
    let shader_lerp_path_distance:SKShader = SKShader(source: """
    //v_path_distance and u_path_length defined at
    //https://developer.apple.com/documentation/spritekit/creating-a-custom-fragment-shader
    void main(){
    //draw based on an animated value (u_lerp) in range 0-1
    if (v_path_distance < (u_path_length * u_lerp)) {
    gl_FragColor = texture2D(u_texture, v_tex_coord); //sample texture and draw fragment 

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
    func lerp(a:CGFloat, b:CGFloat, fraction:CGFloat) -> CGFloat {
        return (b-a) * fraction + a
    }
    private var _dashesPathAnimation: SKAction {
        return SKAction.customAction(withDuration: DURATION) {
        (node : SKNode!, elapsedTime : CGFloat) -> Void in
            let fraction = CGFloat(elapsedTime / CGFloat(self.DURATION))
            let i = self.lerp(a:0, b:1, fraction:fraction)
            self.u_lerp.floatValue = Float(i)
            }
    }

    func animate() {
        setPathDrawProperties()
        self.run(_dashesPathAnimation)
    }

    func setPathDrawProperties() {
        self.lineWidth = 5
        self.strokeColor = .white
        
        
        shader_lerp_path_distance.uniforms = [ u_lerp ]
        self.strokeShader = shader_lerp_path_distance
    }
}
