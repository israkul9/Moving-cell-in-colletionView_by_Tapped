//
//  ViewController.swift
//  MovingCellCollectionView
//
//  Created by shishir  on 2/6/20.
//  Copyright © 2020 shishir . All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    var images = [String]()
    
    var timer : Timer?
    var mainImages = [UIImage]()
    
     var snapshotView: UIView?
    fileprivate var snapshotIndexPath: IndexPath?
    fileprivate var snapshotPanPoint: CGPoint?
    
    var indicate = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        images.append("1")
        images.append("2")
        images.append("3")
        images.append("4")
        images.append("5")
        images.append("6")
        
        images.append("1")
        images.append("2")
        images.append("3")
        images.append("4")
        images.append("5")
        images.append("6")
        images.append("1")
        
             images.append("2")
             images.append("3")
             images.append("4")
             images.append("5")
             images.append("6")
             
             images.append("1")
             images.append("2")
             images.append("3")
             images.append("4")
             images.append("5")
             images.append("6")
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        
        myCollectionView.register(nib, forCellWithReuseIdentifier: "CollectionViewCell")
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressRecognized(_:)))
          gestureRecognizer.minimumPressDuration = 0.2
          myCollectionView!.addGestureRecognizer(gestureRecognizer)
        
        
        
    }
    
    @objc func longPressRecognized(_ recognizer: UILongPressGestureRecognizer) {
        
      
       let location = recognizer.location(in: myCollectionView)
        
         print(location.x," --- ",location.y)
       let indexPath = myCollectionView?.indexPathForItem(at: location)
       
       switch recognizer.state {
       case UIGestureRecognizerState.began:
         guard let indexPath = indexPath else { return }
         
         let cell = cellForRow(at: indexPath)
         snapshotView = cell.snapshotView(afterScreenUpdates: true)
         
         snapshotView?.frame.origin.x = location.x-40
          snapshotView?.frame.origin.y = location.y-90
         
         
        
         
        
         myCollectionView!.addSubview(snapshotView!)
         cell.contentView.alpha = 0.0
         
         UIView.animate(withDuration: 0.2, animations: {
            
           self.snapshotView?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
           self.snapshotView?.alpha = 0.9
            
            
         })
         
         snapshotPanPoint = location
         snapshotIndexPath = indexPath
       case UIGestureRecognizerState.changed:
         guard let snapshotPanPoint = snapshotPanPoint else { return }
         
         let translation = CGPoint(x: location.x - snapshotPanPoint.x, y: location.y - snapshotPanPoint.y)
         snapshotView?.center.x += translation.x
         snapshotView?.center.y += translation.y
         self.snapshotPanPoint = location
         
         guard let indexPath = indexPath else { return }
         
         exchangeImageAtIndex(snapshotIndexPath!.item, withImageAtIndex: indexPath.item)
         myCollectionView!.moveItem(at: snapshotIndexPath!, to: indexPath)
         snapshotIndexPath = indexPath
       default:
         guard let snapshotIndexPath = snapshotIndexPath else { return }
         let cell = cellForRow(at: snapshotIndexPath)
         UIView.animate(
           withDuration: 0.2,
           animations: {
             self.snapshotView?.center = cell.center
             self.snapshotView?.transform = CGAffineTransform.identity
             self.snapshotView?.alpha = 1.0
           },
           completion: { finished in
             cell.contentView.alpha = 1.0
             self.snapshotView?.removeFromSuperview()
             self.snapshotView = nil
         })
         self.snapshotIndexPath = nil
         self.snapshotPanPoint = nil
       }
     }
    
    
    
    fileprivate func cellForRow(at indexPath: IndexPath) -> CollectionViewCell {
       return myCollectionView?.cellForItem(at: indexPath) as! CollectionViewCell
     }
    
    func exchangeImageAtIndex(_ index: Int, withImageAtIndex otherIndex: Int) {
      if index != otherIndex {
        
        
        print(index," ",otherIndex)
        
        
        let img1 = images[index]
        images[index] = images[otherIndex]
        images[otherIndex] = img1
        
        
        
      //  swap(&images[index], &images[otherIndex])
      }
    }

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.imageView.image = UIImage(named: images[indexPath.row])
        
        cell.layer.cornerRadius = 9
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
    return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         
        return 10
        
    }
    
    func vibratePhone() {
          let counter = 1
          switch counter {
          case 1, 2:
              AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
          default:
              timer?.invalidate()
          }
      }

    func vibrate() {
          //counter = 0
        timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: "vibratePhone", userInfo: nil, repeats: true)
      }
    
    
    func vibrate2() {
        
          AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate) {
              AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            
          }
        indicate = 0
      }
}

