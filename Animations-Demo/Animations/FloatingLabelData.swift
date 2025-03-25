import SpriteKit

enum DestinationIconType {
    case VPS
    case Mina
    case SSH
    case Ruby
    case Postgres
    case DeployTool
    case Unicorn
    case Nginx
    case HTTPS
}

// Icons
let destinationOrder: [DestinationIconType] = [.VPS, .SSH, .Ruby, .Postgres, .DeployTool, .Unicorn, .Nginx, .HTTPS]

let destinationFileNames: [DestinationIconType:String] =
[
 .VPS:"digital-ocean-logo.png",
 .SSH:"ssh-console.png",
 .Ruby: "ruby-logo.png",
 .Postgres: "postgres-logo.png",
 .DeployTool: "mina-deploy.png",
 .Unicorn:"unicorn-logo.png",
 .Nginx:"nginx_logo_dark.png",
 .HTTPS: "certbot-logo.png"
]

let destinationPositions: [DestinationIconType:CGPoint] =
[.VPS:CGPoint(x:-285,y:112),
 .SSH:CGPoint(x:-136, y:136),
 .Ruby:CGPoint(x:44, y:130),
 .Postgres:CGPoint(x:15,y:-20),
 .DeployTool:CGPoint(x:107,y:-83),
 .Unicorn:CGPoint(x: 197, y: -146),
 .Nginx:CGPoint(x:305, y:-380),
 .HTTPS:CGPoint(x:372,y:-331),
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
     "• Add a deploy key from your server to your github repository for read access",
     .SSH),
    ("Ruby",
     "• Download dependencies on your server \n" +
     "• ruby version manager \n" +
     "• postgres \n" +
     "• firewall (ufw) \n",
     .Ruby),
    ("Database",
     "• Postgresql \n" +
     "• Create a postgres user \n" +
     "• Configure your rails app to use postgres \n",
     .Postgres),
    ("Deploy Tool",
     "• Automate! please use a deploy tool \n" +
     "• Mina deploy ruby gem \n" +
     "• This tutorial wont use docker",
     .DeployTool),
    ("Web server",
     "• Unicorn is a ruby web server \n" +
     "• processes HTTP requests \n" +
     "• Routes traffic in and out of the Rails application",
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
