//
//  ViewController.swift
//  apiONcollection
//
//  Created by IOS on 31/12/22.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
  //variabel to get api data
    var json = [String:Any]()
  // variable to get api data on collectionView
    var js = [String:Any]()
  //for a collection scroll count not nesseari
    var jD = [Int]()
    
  //timer add
    var timer = Timer()
    var counter = 0
    

    @IBOutlet weak var apiPG: UIPageControl!
    @IBOutlet weak var ApiColl: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //colelction view frame height and witgh
           let direct = UICollectionViewFlowLayout()
           let celSize = CGSize(width: 300, height: 300)
           direct.itemSize = celSize
           direct.scrollDirection = .horizontal
           self.ApiColl.collectionViewLayout = direct
         
      //page controller
        apiPG.numberOfPages = self.js.count
        apiPG.currentPage = 0
        
      //function call
        self.apiCall()
        
      //add action for timing and auto scrolling
        apiPG.numberOfPages = self.js.count
        apiPG.currentPage = 0
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
        
    }
 //api function call
    func apiCall(){
        let url = URL(string: "https://reqres.in/api/users/2")
        var urlReq = URLRequest(url: url!)
        urlReq.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: urlReq) { data, response, error in
            if let err = error{
                print(err.localizedDescription)
            }
            if let resp = response{
                print(resp)
            }
            do{
                self.json = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                self.js = self.json["data"] as! [String:Any]
            }
            catch let err as NSError {
                print(err.localizedDescription)
            }
        }
        task.resume()
    }
  
  //collection view information
  
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.js.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApiCollectionViewCell", for: indexPath) as! ApiCollectionViewCell
       // cell.backgroundColor = .blue
        
        cell.idLB.text = "\(self.js["id"]!)"
        cell.NameLB.text = "\(self.js["first_name"]!)"
        let imgURL = URL(string: "\(self.js["avatar"]!)")
        let data = NSData(contentsOf: imgURL!)
        cell.apiIMg.image = UIImage(data: data! as Data)
        return cell
    }
    
  //change password  
    @objc func changeImage() {
        if counter < self.js.count {
            let index = IndexPath.init(item: counter-1, section: 0)
            self.ApiColl.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            apiPG.currentPage = counter
            counter += 1
        } else {
                counter = 0
                let index = IndexPath.init(item: counter, section: 0)
                self.ApiColl.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
                apiPG.currentPage = counter
                counter = 0
            }
    }
   

}

