//
//  ViewController.swift
//  collectionViewDemo
//
//  Created by iWizards XI on 09/07/19.
//  Copyright © 2019 iWizards XI. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController{
    
    @IBOutlet var collectionView: UICollectionView!
    
    var ref : DatabaseReference?
    var arrNumber = [String]()
    var arrnName = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Inserting into firebase real time database
        ref = Database.database().reference()
        collectionView.delegate = self
        collectionView.dataSource = self
        ref?.child("collectionView/Data5/name").setValue("Sourav")
        ref?.child("collectionView/Data5/number").setValue("5")
        collectionView.transform = CGAffineTransform.init(rotationAngle: (-(CGFloat)(Double.pi)))
        self.retrieveData { (response) in
            self.collectionView.reloadData()
        }
        
    }
    
    public func retrieveData(completion: @escaping(String) -> ()) {
        ref = Database.database().reference()
        ref?.child("collectionView").observe(.value, with: { (data) in
            if data.childrenCount > 0 {
                for artists in data.children.allObjects as! [DataSnapshot] {
                    let collectionViewObject = artists.value as? [String: AnyObject]
                    let name  = collectionViewObject?["name"]
                    self.arrnName.append(name as! String)
                    let number = collectionViewObject?["number"]
                    if let unwrapped = number {
                        self.arrNumber.append("\(unwrapped)")
                    }
                }
                completion("complete")
            }
        })
    }
    
}

extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrNumber.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"collectionCell", for: indexPath as IndexPath)
        
        let lblnumber = cell.contentView.viewWithTag(1) as! UILabel
        let lblname = cell.contentView.viewWithTag(2) as! UILabel
        cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        
        lblname.text = arrnName[indexPath.row]
        lblnumber.text = arrNumber[indexPath.row]
        
        return cell
        
    }
    
}

