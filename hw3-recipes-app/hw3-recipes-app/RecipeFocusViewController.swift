//
//  RecipeFocusViewController.swift
//  hw3-recipes-app
//
//  Created by codeplus on 2/24/20.
//  Copyright © 2020 CS290. All rights reserved.
//

import UIKit
import WebKit

class RecipeFocusViewController: UIViewController {

    @IBOutlet weak var recipeWebView: WKWebView!
    var recipeTitleText:String = ""
    var recipeIngredientsText:String = ""
    var url: String = ""
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeIngredientsLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        recipeTitleLabel.text = recipeTitleText
        recipeIngredientsLabel.text = recipeIngredientsText
        // Do any additional setup after loading the view.
        if Reachability.isConnectedToNetwork(){
                         print("connected")
                         let webURL = URL(string: url)
                              print(url)
                              let request = URLRequest(url: webURL!)
                              recipeWebView.load(request)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
