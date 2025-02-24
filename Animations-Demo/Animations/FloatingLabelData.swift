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
[.VPS:CGPoint(x:-300,y:200),
 .SSH:CGPoint(x:-100,y:180),
 .Unicorn:CGPoint(x: 10, y: -200),
 .Nginx:CGPoint(x: 70, y: -100)
]

// Floating label data
let deployJourneyDescriptionData: [(String, String, DestinationIconType)] = [
    ("VPS", "Virtual private servers are the land you own on the internet, well more like rent", .VPS),
    ("SSH", "SSH is the protocol used to connect to servers. You need to make SSH keys and keep them safe", .SSH),
    ("Unicorn", "Unicorn is a ruby web server which processes HTTP requests and works with your rails app to make sure you and your visitors can navigate and use your rails application.", .Unicorn),
    
]

let rightDestinationLabels: [DestinationIconType] = [.SSH, .Nginx]
