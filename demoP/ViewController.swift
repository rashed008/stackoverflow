//
//  ViewController.swift
//  demoP
//
//  Created by Akramul Haque on 11/3/19.
//  Copyright © 2019 AABPD. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import SDWebImage

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var AllImage: [String] = []
    var boolValue = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        downloadJson()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Found - \(AllImage.count)")
        return AllImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        // cell.myImage.image = UIImage(named: AllImage[indexPath.row])
        NKPlaceholderImage(image: UIImage(named: "placeholder"), imageView: cell.myImage, imgUrl: AllImage[indexPath.row]) { (image) in }
        return cell
    }
    
    //MARK: Image
    func downloadJson(){
        var access_token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjEwMjc2LCJpc3MiOiJodHRwczovL2hvbWlpdGVzdC5jby56YS9hcGkvbG9naW4iLCJpYXQiOjE1NTIxOTYwMjIsImV4cCI6MTU1NDc4ODAyMiwibmJmIjoxNTUyMTk2MDIyLCJqdGkiOiJBeTY5R0JkZDA5dWdFTDBhIn0.czpQQsC08vuTB8iGdTeEjjQUmzl6I5Cs0VQ8WeA5VaY"
        let headers = ["Authorization": "Bearer "+access_token+"", "Content-Type": "application/json"]
        Alamofire.request("https://homiitest.co.za/api/gallery", method: .get,  parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if response.result.isSuccess{
                print(response)
                
                let swiftyJson = JSON(response.data!)
                
                let productTemplate = swiftyJson["data"].array
                print("hello there - \(productTemplate)")
                
                for product in productTemplate! {
                    // print(product["image_medium"].stringValue)
                    
                    if let data = product["data"].bool {
                        continue
                    } else
                    {
                        print("I am in this block")
                        self.AllImage.append(product["data"].stringValue)
                        print("this is data - \(product["data"].stringValue)")
                    }
                    self.collectionView!.reloadData()
                }
                
            }
            
        }
        
    }
    
    
    
    
    func NKPlaceholderImage(image:UIImage?, imageView:UIImageView?,imgUrl:String,compate:@escaping (UIImage?) -> Void){
        
        if image != nil && imageView != nil {
            imageView!.image = image!
        }
        
        var urlcatch = imgUrl.replacingOccurrences(of: "/", with: "#")
        let documentpath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        urlcatch = documentpath + "/" + "\(urlcatch)"
        
        let image = UIImage(contentsOfFile:urlcatch)
        if image != nil && imageView != nil
        {
            imageView!.image = image!
            compate(image)
            
        }else{
            
            if let url = URL(string: imgUrl){
                
                DispatchQueue.global(qos: .background).async {
                    () -> Void in
                    let imgdata = NSData(contentsOf: url)
                    DispatchQueue.main.async {
                        () -> Void in
                        imgdata?.write(toFile: urlcatch, atomically: true)
                        let image = UIImage(contentsOfFile:urlcatch)
                        compate(image)
                        if image != nil  {
                            if imageView != nil  {
                                imageView!.image = image!
                            }
                        }
                    }
                }
            }
        }
    }
    
}


