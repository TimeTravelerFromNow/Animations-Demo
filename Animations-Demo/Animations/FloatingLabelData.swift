import SpriteKit

// Icons
let destinationOrder: [DestinationIconType] = [.VPS, .SSH, .Unicorn, .Nginx]

let destinationFileNames: [DestinationIconType:String] =
[.VPS:"digital-ocean-logo.png",
 .SSH:"ssh-console.png",
 .Unicorn:"unicorn-logo.png",
 .Nginx:"nginx_logo_dark.png"
]

let destinationPositions: [DestinationIconType:CGPoint] =
[.VPS:CGPoint(x:-285,y:112),
 .SSH:CGPoint(x:-41,y:146),
 .Unicorn:CGPoint(x: 15, y: -22),
 .Nginx:CGPoint(x: 197, y: -146)
// -285.3383483886719 112.75836181640625
// -41.01458740234375 146.278564453125
// 15.02838134765625 -22.486572265625
// 197.6529541015625 -145.98910522460938
// 192.98876953125 -274.9796447753906
// 292.0914306640625 -268.319580078125
// 304.8082275390625 -378.8586730957031
// 372.109619140625 -331.6553955078125
]

// Floating label data
let deployJourneyDescriptionData: [(String, String, DestinationIconType)] = [
    ("VPS", "Virtual private servers are the land you own on the internet, well more like rent", .VPS),
    ("SSH", "SSH is the protocol used to connect to servers. You need to make SSH keys and keep them safe", .SSH),
    ("Unicorn", "Unicorn is a ruby web server which processes HTTP requests and works with your rails app to make sure you and your visitors can navigate and use your rails application.", .Unicorn),
    ("Nginx", "Nginx is a common server proxy which routes traffic to your IP to the unicorn servers", .Nginx)
    
]

let rightDestinationLabels: [DestinationIconType] = [.SSH, .Nginx]
