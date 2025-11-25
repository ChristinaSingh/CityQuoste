

import UIKit
import SwiftyJSON

class PuzzleCollectionViewController: UICollectionViewController {
    
    var puzzle:[UIImage] = []
    var puzzleresolved:[UIImage] = []

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

    override func viewDidLoad() {
        super.viewDidLoad()
        showProgressBar()

//dicCurrentQuestion["final_puzzle_image"].stringValue
        let url = URL(string: dicCurrentQuestion["Jigsaw_puzzle_image"].stringValue)!
        downloadImage(from: url)

        if dicCurrentQuestion["custom_ans"].stringValue != "" {
            strCustom = "custom"
            isAnswer = dicCurrentQuestion["custom_ans"].stringValue
        } else {
            isAnswer = dicCurrentQuestion["option_Ans"].stringValue
        }


    }
    func calWhn()  {
        
        let sd = slice(image: puzzueDImage, into: 3)
        puzzle = sd.shuffled()
        puzzleresolved = sd
        print("\(puzzle)")
        print("puzzlepuzzle \(puzzle.count)")
        self.collectionView.reloadData()
        
        collectionView.dragInteractionEnabled = true
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: "Puzzle", CenterImage: "", RightTitle: "Preview", RightImage: "", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")

    }
 
    override func rightClick() {
        

        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "ShowFinalIPreviewVC") as! ShowFinalIPreviewVC
            objVC.strImage = dicCurrentQuestion["Jigsaw_puzzle_image"].stringValue
        self.navigationController?.pushViewController(objVC, animated: false)

    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true

    }

    @objc func showHintImage() {
        
        self.navigationController?.popViewController(animated: true)

    }
    
    @objc func removeHintImage() {
        self.view.sendSubviewToBack(hintImage)
        self.collectionView.isHidden = false
        navigationItem.leftBarButtonItem?.isEnabled = false
        
    }
    
    @objc func moveToNextPuzzle() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if index < puzzle.count {
            return puzzle.count
        } else {
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
        cell.puzzleImage.image = puzzle[indexPath.item]
        
        print("puzzle[indexPath.item] \(puzzle[indexPath.item])")

        return cell
    }
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.puzzueDImage = UIImage(data: data)
                
                if self?.puzzueDImage != nil {
                    self?.calWhn()
                    self!.hideProgressBar()

                    GlobalConstant.showAlertMessage(withOkButtonAndTitle: "INSTRUCTIONS", andMessage: "Mantén pulsado con fuerza una pieza del rompecabezas y desliza para mover las piezas.", on: self!)

                } else {
                    GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: "Image Not geting in puzzle format", on: self!)

                }
            }
        }
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
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
    func slice(image: UIImage, into howMany: Int) -> [UIImage] {
        let width: CGFloat
        let height: CGFloat

        switch image.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            width = image.size.height
            height = image.size.width
        default:
            width = image.size.width
            height = image.size.height
        }

        let tileWidth = Int(width / CGFloat(howMany))
        let tileHeight = Int(height / CGFloat(howMany))

        let scale = Int(image.scale)
        var images = [UIImage]()

        let cgImage = image.cgImage!

        var adjustedHeight = tileHeight

        var y = 0
        for row in 0 ..< howMany {
            if row == (howMany - 1) {
                adjustedHeight = Int(height) - y
            }
            var adjustedWidth = tileWidth
            var x = 0
            for column in 0 ..< howMany {
                if column == (howMany - 1) {
                    adjustedWidth = Int(width) - x
                }
                let origin = CGPoint(x: x * scale, y: y * scale)
                let size = CGSize(width: adjustedWidth * scale, height: adjustedHeight * scale)
                let tileCgImage = cgImage.cropping(to: CGRect(origin: origin, size: size))!
                images.append(UIImage(cgImage: tileCgImage, scale: image.scale, orientation: image.imageOrientation))
                x += tileWidth
            }
            y += tileHeight
        }
        return images
    }

    
}

extension PuzzleCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        if puzzle[index].title == "Soldier" {
//            return UIEdgeInsets(top: 40, left: 16, bottom: 40, right: 16)
//        } else if puzzle[index].title == "Charuzard" {
//            return UIEdgeInsets(top: 40, left: 15, bottom: 40, right: 15)
//        } else {
            return UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0)
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        var customCollectionWidth: CGFloat!
//        if puzzle[index].title == "Soldier" {
//            customCollectionWidth = collectionViewWidth/4 - 8
//        } else if puzzle[index].title == "Charuzard" {
            customCollectionWidth = collectionViewWidth/3 - 1
//        } else {
//            customCollectionWidth = collectionViewWidth/2 - 10
//        }
        return CGSize(width: customCollectionWidth, height: customCollectionWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension PuzzleCollectionViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = self.puzzle[indexPath.item]
        let itemProvider = NSItemProvider(object: item as UIImage)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = dragItem
        return [dragItem]
    }
}

extension PuzzleCollectionViewController: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
        if puzzle == puzzleresolved {
            Alert.showSolvedPuzzleAlert(on: self)
            collectionView.dragInteractionEnabled = false
            WebAddAnswer()
//            if index == puzzle.count - 1 {
//                navigationItem.rightBarButtonItem?.isEnabled = false
//            } else {
//                navigationItem.rightBarButtonItem?.isEnabled = true
//            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        var destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item: row - 1, section: 0)
        }
        
        if coordinator.proposal.operation == .move {
            self.reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
            self.collectionView.reloadData()
        }
    }
    
    fileprivate func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath:IndexPath, collectionView: UICollectionView) {
        
        if let item = coordinator.items.first,
            let sourceIndexPath = item.sourceIndexPath {

            collectionView.performBatchUpdates({
                puzzle.swapAt(sourceIndexPath.item, destinationIndexPath.item)
                collectionView.reloadItems(at: [sourceIndexPath,destinationIndexPath])

            }, completion: nil)

            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
    }
}
