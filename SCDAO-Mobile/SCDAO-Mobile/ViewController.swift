//
//  ViewController.swift
//  SCDAO-Mobile
//
//  Created by Jeffrey Jin on 7/6/21.
//

import UIKit

class ViewController: UIViewController {
    
    func doWork(){
        print("current thread is \(Thread.current)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
          // Dispose of any resources that can be recreated.
      }
    @IBAction func showPopup(_ sender: AnyObject) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! PopUpViewController
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
    
  
    
    
}// end of class

//
//class SecondViewController: UIViewController {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//    
//    @IBAction func showPopFilter(_ sender: AnyObject) {
//        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopupFilter") as! Filter
//        self.addChild(popOverVC)
//        popOverVC.view.frame = self.view.frame
//        self.view.addSubview(popOverVC.view)
//        popOverVC.didMove(toParent: self)
//    }
//    
//     
//}
