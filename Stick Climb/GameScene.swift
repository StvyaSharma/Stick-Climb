//
//  GameScene.swift
//  Stick Climb
//
//  Created by Stvya Sharma on 18/05/21.
//

import SpriteKit
import GameplayKit
import AVFoundation
import CoreData



public class GameScene: SKScene, SKPhysicsContactDelegate {
//: ### Physics
    struct PhysicsCategory{
        static let Player: UInt32 = 1
        static let Obstacles: UInt32 = 2
    }
    private var bear = SKSpriteNode()
     private var bearWalkingFrames: [SKTexture] = []
    var direction : CGFloat = 0.0
    
    let player = SKShapeNode(circleOfRadius: 20)
    let obstacleSpacing: CGFloat = 800
    let cameraNode = SKCameraNode()
    let HighScoreLabel = SKLabelNode()
    let backButtonLabel = SKLabelNode()
    var highscore  = 0
//: ### Starting Function
    public func didBegin(_ contact: SKPhysicsContact) {
        if let nodeA = contact.bodyA.node as? SKShapeNode, let nodeB = contact.bodyB.node as? SKShapeNode{
            if nodeA.fillColor != nodeB.fillColor{
                player.physicsBody?.velocity.dy = 0
                player.removeFromParent()
                bear.removeFromParent()
                score = 0
                HighScoreLabel.text = String("High Score : \(highscore)")
                backButtonLabel.text = "Back"
                scoreLabel.text = String(score)
                let colours = [UIColor.white]
                addPlayer(colour: colours.randomElement()!)
            }
            if nodeA.fillColor == nodeB.fillColor{
                score += 1
                self.sound(sound: "Color Switch Bounce", type: "mp3", loops: 0)
                
                if highscore < score {
                    highscore = score
                }
                
                HighScoreLabel.text = String("High Score : \(highscore)")
                scoreLabel.text = String(score)
                
            }
        }
    }
//: ### Adding Player
    func addPlayer(colour: UIColor){
        player.fillColor = colour
        player.strokeColor = player.fillColor
        player.position = CGPoint(x: 0, y: -300)
        //Physics Properties
        direction = bear.xScale
        let playerBody = SKPhysicsBody(circleOfRadius: 15)
        playerBody.mass = 1.5
        playerBody.categoryBitMask = PhysicsCategory.Player
        playerBody.collisionBitMask = 4
        player.physicsBody = playerBody
        //Add to scene
        let bearAnimatedAtlas = SKTextureAtlas(named: "stickman")
          var walkFrames: [SKTexture] = []

          let numImages = bearAnimatedAtlas.textureNames.count
          for i in 1...numImages {
            let bearTextureName = "stickman\(i)"
            walkFrames.append(bearAnimatedAtlas.textureNamed(bearTextureName))
          }
          bearWalkingFrames = walkFrames
        let firstFrameTexture = bearWalkingFrames[0]
        bear = SKSpriteNode(texture: firstFrameTexture)
        bear.size = CGSize(width: 100, height: 100)
        player.addChild(bear)
        bear.run(SKAction.repeatForever(
            SKAction.animate(with: bearWalkingFrames,
                             timePerFrame: 0.1,
                             resize: false,
                             restore: true)),
            withKey:"walkingInPlaceBear")
        bear.zRotation = 1

        addChild(player)
    }

    func addRestrictBlock(yHeight : Int, width : Int , xaxis : Int){
        let path = UIBezierPath(roundedRect: CGRect(x:-width/2, y: -width/2, width: width, height: 20), cornerRadius: 20)
        let obstacle = SKNode()
        let colours = UIColor.black
        let section = SKShapeNode(path: path.cgPath)
        section.position = CGPoint(x: 0, y: 0)
        section.fillColor = colours
        section.strokeColor = colours
            //Physics Properties
            let sectionBody = SKPhysicsBody(polygonFrom: path.cgPath)
            sectionBody.categoryBitMask = PhysicsCategory.Obstacles
            sectionBody.collisionBitMask = 0
            sectionBody.contactTestBitMask = PhysicsCategory.Player
            sectionBody.affectedByGravity = false
            section.physicsBody = sectionBody
            //Add to Obstacle
            obstacle.addChild(section)
        
        obstacle.position = CGPoint(x: xaxis, y: yHeight)
        addChild(obstacle)
 
    }
    func addPassingBlock(yHeight : Int, width : Int , xaxis : Int){
        let path = UIBezierPath(roundedRect: CGRect(x:-width/2, y: -width/2, width: width, height: 20), cornerRadius: 20)
        let obstacle = SKNode()
        let colours = UIColor.white
        let section = SKShapeNode(path: path.cgPath)
        section.position = CGPoint(x: 0, y: 0)
        section.fillColor = colours
        section.strokeColor = colours
            //Physics Properties
            let sectionBody = SKPhysicsBody(polygonFrom: path.cgPath)
            sectionBody.categoryBitMask = PhysicsCategory.Obstacles
            sectionBody.collisionBitMask = 0
            sectionBody.contactTestBitMask = PhysicsCategory.Player
            sectionBody.affectedByGravity = false
            section.physicsBody = sectionBody
            //Add to Obstacle
            obstacle.addChild(section)
        
        obstacle.position = CGPoint(x: xaxis, y: yHeight)
        addChild(obstacle)
 
    }
    
    func addLineBlock(yheight: Int , width : Int , xaxis : Int){
        addPassingBlock(yHeight: yheight, width: width, xaxis: xaxis  - 420)
        addRestrictBlock(yHeight: yheight, width: width, xaxis: xaxis )
        addPassingBlock(yHeight: yheight, width: width, xaxis: xaxis + 420)
        
    }
    
    func addRectObstacle(xaxis : Int, yHeight : Int){
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 100, height: 100), cornerRadius: 0)
        let obstacle = SKNode()
        
            let colours = UIColor.black
            let section = SKShapeNode(path: path.cgPath)
            section.position = CGPoint(x: 0, y: 0)
            section.fillColor = colours
            section.strokeColor = colours
            //Physics Properties
            let sectionBody = SKPhysicsBody(polygonFrom: path.cgPath)
            sectionBody.categoryBitMask = PhysicsCategory.Obstacles
            sectionBody.collisionBitMask = 0
            sectionBody.contactTestBitMask = PhysicsCategory.Player
            sectionBody.affectedByGravity = false
            section.physicsBody = sectionBody
        
            obstacle.addChild(section)

        obstacle.position = CGPoint(x: xaxis, y: yHeight)
        obstacle.zRotation  = 0.7
        addChild(obstacle)

    }
    func addSpikes(xaxis: Int, yHeight: Int , passingblock : Int) {
        addRectObstacle(xaxis: xaxis, yHeight: yHeight)
        addRectObstacle(xaxis: xaxis,  yHeight: yHeight + 70)
        addRectObstacle(xaxis: xaxis,  yHeight: yHeight + 140)
        addRectObstacle(xaxis: xaxis,  yHeight: yHeight + 210)
        addRectObstacle(xaxis: xaxis,  yHeight: yHeight + 280)
        addPassingBlock(yHeight: yHeight + 400, width: 400, xaxis: xaxis + passingblock)
    }
    func addMidRect(yHeight : Int){
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 300, height: 1000), cornerRadius: 20)
        let obstacle = SKNode()
        
            let colours = UIColor.black
            let section = SKShapeNode(path: path.cgPath)
            section.position = CGPoint(x: 0, y: 0)
            section.fillColor = colours
            section.strokeColor = colours
            //Physics Properties
            let sectionBody = SKPhysicsBody(polygonFrom: path.cgPath)
            sectionBody.categoryBitMask = PhysicsCategory.Obstacles
            sectionBody.collisionBitMask = 0
            sectionBody.contactTestBitMask = PhysicsCategory.Player
            sectionBody.affectedByGravity = false
            section.physicsBody = sectionBody
        
            obstacle.addChild(section)

        obstacle.position = CGPoint(x: -150, y: yHeight)
        addChild(obstacle)

    }
    func addingbottom(yheight: Int , xaxis : Int) {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 0, height: 0), cornerRadius: 20)
        let obstacle = SKNode()
        
            let colours = UIColor.black
            let section = SKShapeNode(path: path.cgPath)
            section.position = CGPoint(x: 0, y: 0)
            section.fillColor = colours
            section.strokeColor = colours
            //Physics Properties
            let sectionBody = SKPhysicsBody(polygonFrom: path.cgPath)
            sectionBody.categoryBitMask = PhysicsCategory.Obstacles
            sectionBody.collisionBitMask = 0
            sectionBody.contactTestBitMask = PhysicsCategory.Player
            sectionBody.affectedByGravity = false
            section.physicsBody = sectionBody
        let bottom = SKSpriteNode(imageNamed: "background")
        bottom.size = CGSize(width: 190, height: 1000)
        obstacle.addChild(bottom)
            obstacle.addChild(section)

        obstacle.position = CGPoint(x: xaxis , y: yheight)
        addChild(obstacle)

        

    }
    
    
  

//: ### Circle Obstacle
    let scoreLabel = SKLabelNode()
    var score = 0
//: ### Function to add Obstacles
    func addObstacle() {
        addingbottom(yheight: -100, xaxis: -350)
        addingbottom(yheight: -100, xaxis: 350)
        var i = 200
        var lol = 0
        while lol < 100{
            let x = Int.random(in: 0...8)
            switch x {
            case 0:
                addLineBlock(yheight: i, width: 400 , xaxis: -100)
                addingbottom(yheight: i, xaxis: -350)
                addingbottom(yheight: i, xaxis: 350)
                i += 1000
            case 1:
                addLineBlock(yheight: i, width: 400, xaxis: -50)
                addingbottom(yheight: i, xaxis: -350)
                addingbottom(yheight: i, xaxis: 350)
                i += 1000
            case 2:
                addLineBlock(yheight: i, width: 400, xaxis: 100)
                addingbottom(yheight: i, xaxis: -350)
                addingbottom(yheight: i, xaxis: 350)
                i += 1000
            case 3:
                addLineBlock(yheight: i, width: 400, xaxis: -200)
                addingbottom(yheight: i, xaxis: -350)
                addingbottom(yheight: i, xaxis: 350)
                i += 1000
            case 4:
                addSpikes(xaxis: -200, yHeight: i , passingblock: 280)
                addingbottom(yheight: i, xaxis: -350)
                addingbottom(yheight: i, xaxis: 350)
                i += 1000
            case 5:
                addSpikes(xaxis: 200, yHeight: i, passingblock: -280)
                addingbottom(yheight: i, xaxis: -350)
                addingbottom(yheight: i, xaxis: 350)
                i += 1000
            case 6 :
                addSpikes(xaxis: -200, yHeight: i , passingblock: 280)
                addingbottom(yheight: i, xaxis: -350)
                addingbottom(yheight: i, xaxis: 350)
                i += 500
                addSpikes(xaxis: 200, yHeight: i, passingblock: -280)
                addingbottom(yheight: i, xaxis: -350)
                addingbottom(yheight: i, xaxis: 350)
                i += 1000
            case 7 :
                addSpikes(xaxis: 200, yHeight: i, passingblock: -280)
                addingbottom(yheight: i, xaxis: -350)
                addingbottom(yheight: i, xaxis: 350)
                i += 500
                addSpikes(xaxis: -200, yHeight: i , passingblock: 280)
                addingbottom(yheight: i, xaxis: -350)
                addingbottom(yheight: i, xaxis: 350)
                i += 1000
            case 8:
                addMidRect(yHeight: i)
                addingbottom(yheight: i, xaxis: -350)
                addingbottom(yheight: i, xaxis: 350)
                addingbottom(yheight: i + 1000, xaxis: -350)
                addingbottom(yheight: i + 1000, xaxis: 350)
                i += 2000
                

           

            default:
                print("NUll")
            }
            lol += 1
        }
            
        
    }
    
    let colours = [UIColor.yellow, UIColor.red, UIColor.blue, UIColor.purple]
//: ### Movement of Player
    public override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity.dy = 6
        
        

        
        
        addPlayer(colour: .white)
        addObstacle()
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = player.position
        scoreLabel.position = CGPoint(x: 0, y: 500)
        scoreLabel.fontColor = .black
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontSize = 100
        scoreLabel.text = String(score)
        backButtonLabel.fontColor = .black
        backButtonLabel.position = CGPoint(x: 300, y: 600)
        backButtonLabel.fontSize = 50
        backButtonLabel.fontName = "AvenirNext-Bold"
        HighScoreLabel.position = CGPoint(x:0, y:-600)
        HighScoreLabel.fontName = "AvenirNext-Bold"
        HighScoreLabel.fontSize = 50
        HighScoreLabel.fontColor = .black
        HighScoreLabel.text = String("High Score : \(highscore)")
        backButtonLabel.text = "Back"
        
        cameraNode.addChild(scoreLabel)
        cameraNode.addChild(backButtonLabel)
        cameraNode.addChild(HighScoreLabel)

        sound(sound: "Color Jump theme", type: "m4a", loops: 1)
    }
    public override func update(_ currentTime: TimeInterval) {
        let playerPositionInCamera = cameraNode.convert(player.position, to: self)
        if playerPositionInCamera.y > 0 && !cameraNode.hasActions(){
            cameraNode.position.y = player.position.y + 500
        }
        if player.position.y <= -750 {
            player.physicsBody?.isDynamic = true
            
        }
        
        if player.position.x < -200 {
            player.position.x = -200
            player.physicsBody?.affectedByGravity = false
            player.physicsBody?.velocity.dx = 0
        }
        if player.position.x != -200 {
            player.physicsBody?.affectedByGravity = true
        }
        if player.position.x > 200 {
            player.position.x = 200
            player.physicsBody?.affectedByGravity = false
            player.physicsBody?.velocity.dx = 0
        }
        if player.position.x != 200 {
            player.physicsBody?.affectedByGravity = true
        }
        player.physicsBody?.velocity.dy = 400
    }
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            if location.x < frame.midX {
                player.physicsBody?.affectedByGravity = true
                physicsWorld.gravity.dx = -12
                player.physicsBody?.velocity.dx = -700
                bear.xScale = -1 * direction
                bear.zRotation = 4


            }else if location.x > frame.midX {
                player.physicsBody?.affectedByGravity = true
                physicsWorld.gravity.dx = 12
                player.physicsBody?.velocity.dx = 700
                bear.xScale = direction
                bear.zRotation = 1


            }
        }
        
    }
//: ### Color Jump Music
    var arrayOfPlayers = [AVAudioPlayer]()
    func sound(sound: String, type: String, loops: Int) {
        do {
            if let bundle = Bundle.main.path(forResource: sound, ofType: type) {
                let alertSound = NSURL(fileURLWithPath: bundle)
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
                try AVAudioSession.sharedInstance().setActive(true)
                let audioPlayer = try AVAudioPlayer(contentsOf: alertSound as URL)
                audioPlayer.numberOfLoops = loops
                arrayOfPlayers.append(audioPlayer)
                arrayOfPlayers.last?.prepareToPlay()
                arrayOfPlayers.last?.play()
            }
        } catch {
            print(error)
        }
    }
    
}
