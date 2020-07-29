//
//  ViewController.swift
//  W3ather
//
//  Created by Nguyen Quoc Huy on 7/29/20.
//  Copyright © 2020 Nguyen Quoc Huy. All rights reserved.
//

import UIKit
extension Date {
    var hour: Int { return Calendar.current.component(.hour, from: self) } // get hour only from Date
}
class ViewController: UIViewController {
    var timer = Timer()
    
    @IBOutlet weak var backgroundView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        changeBackground()
    }
    

    @objc func changeBackground(){
        // check if day or night shift
        let hour=Date().hour
        
        if hour<18 && hour>6{   //DayTime
            backgroundView.image=UIImage(named: "DayBackground")
        }
        else{//Night time
            backgroundView.image=UIImage(named: "NightBackGround")
        }
        // schedule the timer
        
    }

}

