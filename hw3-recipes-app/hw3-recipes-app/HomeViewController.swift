//
//  HomeViewController.swift
//  hw3-recipes-app
//
//  Created by codeplus on 2/19/20.
//  Copyright © 2020 CS290. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var queryTextField: UITextField!
    @IBOutlet weak var letsGoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        letsGoButton.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
        if Reachability.isConnectedToNetwork(){
            print("connected")
        }
        else{
            print("no connection")
            let alert = UIAlertController(title:"Network offline", message: "Please check your connection and try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destVC = segue.destination as! RecipeTableViewController
        let myQueryText = queryTextField.text
        destVC.queryText = myQueryText ?? ""
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
