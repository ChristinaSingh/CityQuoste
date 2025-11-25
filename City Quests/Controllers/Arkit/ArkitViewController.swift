//
//  ArkitViewController.swift
//  City Quests
//
//  Created by Gajendra on 24/07/24.
//

import UIKit
import SpriteKit
import ARKit
import SwiftyJSON

class ArkitViewController: UIViewController , ARSKViewDelegate {
    
    @IBOutlet var sceneView: ARSKView!
    
    var index: Int = 0
    var gameTimer: Timer?
    var hintImage = UIImageView()

    var dicCurrentQuestion:JSON!
    var arroption:[String] = []
    var isIndex:Int! = -1
    var arroptionAdnswer:[String] = ["A","B","C","D"]
    var isAnswer:String! = ""
    var strCustom:String! = "no"
    var puzzueDImage:UIImage!
    var totalBallon:Int! = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and node count
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        
        // Load the SKScene from 'Scene.sks'
        if let scene = SKScene(fileNamed: "Scene") {
            sceneView.presentScene(scene)
        }
        
        if dicCurrentQuestion["custom_ans"].stringValue != "" {
            strCustom = "custom"
            isAnswer = dicCurrentQuestion["custom_ans"].stringValue
        } else {
            isAnswer = dicCurrentQuestion["option_Ans"].stringValue
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
   
        setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: "Find ballon", CenterImage: "", RightTitle: "", RightImage: "Dotss", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")

        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
        GlobalConstant.showAlertMessage(withOkButtonAndTitle: "Instruction", andMessage: "Whenever you type anywhere on the screen, you will see a balloon. You can add balloons anywhere like this. You have to add minimum 5 balloons to complete this task.", on: self)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
        

    }
    override func leftClick() {
        
    }

    override func rightClick() {
        GlobalConstant.showAlertMessage(withOkButtonAndTitle: "Instruction", andMessage: "Whenever you type anywhere on the screen, you will see a balloon. You can add balloons anywhere like this. You have to add minimum 5 balloons to complete this task.", on: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    //MARK:API
    func WebAddAnswer() {
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        paramsDict["event_id"]     =   dicCurrentQuestion["event_id"].stringValue as AnyObject
        paramsDict["event_game_id"]     =   dicCurrentQuestion["id"].stringValue as AnyObject
        paramsDict["event_code"]     =    kappDelegate.strEventCode as AnyObject
        paramsDict["ans"]     =   isAnswer as AnyObject
        paramsDict["custom_type"]     =   strCustom as AnyObject
        paramsDict["level"]     =   kappDelegate.strLevelId as AnyObject

        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.event_instructions_game_ans.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1" || swiftyJsonVar["status"].stringValue == "2") {
                    self.navigationController?.popViewController(animated: true)

                } else {
                    GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: "Wrong Answer 2 Min Time Penalty Added", on: self)
                    WebAddPenality(strepn: "2")
                }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }
    func WebAddPenality(strepn:String) {

        var paramsDict:[String:AnyObject] = [:]
        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        paramsDict["event_id"]     =   dicCurrentQuestion["event_id"].stringValue as AnyObject
        paramsDict["event_instructions_id"]     =   dicCurrentQuestion["id"].stringValue as AnyObject
        paramsDict["event_code"]     =    kappDelegate.strEventCode as AnyObject
        paramsDict["ans"]     =   isAnswer as AnyObject
        paramsDict["time"]     =   strepn as AnyObject
        paramsDict["hint_type"]     =   "2" as AnyObject
        paramsDict["level"]     =   kappDelegate.strLevelId as AnyObject

        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.add_hint.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    
                } else {

                }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }

    // MARK: - ARSKViewDelegate
    
    func view(_ view: ARSKView, didUpdate node: SKNode, for anchor: ARAnchor) {
//        totalBallon -= 1
//        print("\(anchor.identifier)")
        print("totalBallon \(totalBallon ?? 0)")

        if totalBallon == 5 {
            totalBallon = 0
            WebAddAnswer()
        }
    }
    func view(_ view: ARSKView, didRemove node: SKNode, for anchor: ARAnchor) {
     //   totalBallon -= 1
        print("\(anchor.identifier)")
        print("totalBallon didRemoveNode \(totalBallon ?? 0)")

    }
    func view(_ view: ARSKView, willUpdate node: SKNode, for anchor: ARAnchor) {
        print("totalBallon willUpdate \(totalBallon ?? 0)")

    }

    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        // Create and configure a node for the anchor added to the view's session.
        let spriteNode = SKSpriteNode(imageNamed: "Zoon")
        
        let fadeOut = SKAction.fadeOut(withDuration: 2.6)
        let fadeIn = SKAction.fadeIn(withDuration: 2.6)
        let fade = SKAction.sequence([fadeOut, fadeIn])
        let fadeForever = SKAction.repeatForever(fade)
        
        let pulseUp = SKAction.scale(to: 5.0, duration: 1.0)
        let pulseDown = SKAction.scale(to: 3.0, duration: 1.0)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        let pulseForever = SKAction.repeatForever(pulse)
        
        //execute both actions simultaneously
        let group = SKAction.group([fadeForever, pulseForever])
        spriteNode.run(group)
        print("totalBallon addd \(totalBallon ?? 0)")
        totalBallon += 1
        
       
        return spriteNode;
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
