//
//  ViewController.swift
//  W3ather
//
//  Created by Nguyen Quoc Huy on 7/29/20.
//  Copyright © 2020 Nguyen Quoc Huy. All rights reserved.
//

import UIKit
import MapKit
extension Date {
    var hour: Int { return Calendar.current.component(.hour, from: self) } // get hour only from Date
}
class ViewController: UIViewController, UISearchBarDelegate{
    var timer = Timer()
    
    @IBOutlet weak var backgroundView: UIImageView!
    
    
    @IBAction func searchBtnPressed(_ sender: UIBarButtonItem) {
        //tạo viewController search bằng code
        let searchController=UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate=self
        
        present(searchController, animated: true, completion: nil)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {//kích search thì sẽ trigger
        //Không cho user tương tác với màn hình sau khi nhấn search
        self.view.isUserInteractionEnabled = true
                               
        //Hide search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        //Create the search request
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text//lấy text từ searchBar cho vào searchRequest
        let activeSearch=MKLocalSearch(request: searchRequest)
        activeSearch.start { (reponse, error) in
            if reponse == nil{
                print("ERROR")
            }
            else{
                // Remove annotation form map( annotation: chú thích)
                print(reponse?.boundingRegion.center.latitude)
                print(reponse?.boundingRegion.center.longitude)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Change Background
        changeBackground()
    }
    
    func changeBackground(){
        // check if day or night shift
        let hour=Date().hour
        if hour<18 && hour>6{   //DayTime
            backgroundView.image=UIImage(named: "DayBackground")
            navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9818513989, green: 0.7714535594, blue: 0.3961427212, alpha: 1)
        }
        else{//Night time
            backgroundView.image=UIImage(named: "NightBackGround")
            navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.3051784337, green: 0.344889164, blue: 0.7166694999, alpha: 1)

        }
    }
    
    
}

