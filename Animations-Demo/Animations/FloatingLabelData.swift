import SpriteKit

enum DestinationIconType {
    case VPS
    case Mina
    case SSH
    case Postgres
    case Unicorn
    case Nginx
    case HTTPS
    case Ruby
}

// Icons
let destinationOrder: [DestinationIconType] = [.VPS, .SSH, .Ruby, .Unicorn, .Nginx, .HTTPS]

let destinationFileNames: [DestinationIconType:String] =
[
 .VPS:"digital-ocean-logo.png",
 .SSH:"ssh-console.png",
 .Unicorn:"unicorn-logo.png",
 .Nginx:"nginx_logo_dark.png",
 .Ruby: "ruby-logo.png",
 .HTTPS: "certbot-logo.png"
]

let destinationPositions: [DestinationIconType:CGPoint] =
[.VPS:CGPoint(x:-285,y:112),
 .SSH:CGPoint(x:-136, y:136),
 .Ruby:CGPoint(x:44, y:130),
 .Unicorn:CGPoint(x: 15, y: -22),
 .Nginx:CGPoint(x: 197, y: -146),
 .HTTPS:CGPoint(x:305, y:-380)
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
    ("VPS", 
     "• Virtual private servers \n" +
     "• Internet land for rent \n " +
     "• Digital ocean, Hetzner, Vultr"
     , .VPS),
    ("SSH",
     "• SSH is the protocol used to connect to servers \n" +
     "• Make SSH keys and keep them safe \n" +
     "• Add a deploy key from github to your server",
     .SSH),
    ("Ruby",
     "• Download dependencies on your server \n" +
     "• ruby version manager \n" +
     "• postgres \n" +
     "• firewall (ufw) \n",
     .Ruby),
    ("Unicorn",
     "• Unicorn is a ruby web server \n" +
     "• processes HTTP requests \n" +
     "• routes traffic to your Rails application",
     .Unicorn),
    ("Nginx",
     "• Nginx is a widely used server proxy which routes traffic to the unicorn servers",
     .Nginx),
    ("HTTPS",
     "• Certbot makes generating HTTPS certificates easier than ever \n" +
     "• Set up automatic renewal",
     .HTTPS
    )
]

let rightDestinationLabels: [DestinationIconType] = [.Ruby, .Nginx]
