//
//  RecipeTableViewController.swift
//  hw3-recipes-app
//
//  Created by codeplus on 2/19/20.
//  Copyright © 2020 CS290. All rights reserved.
//

import UIKit

class RecipeTableViewController: UITableViewController {

    var queryText: String = ""
    
    struct Recipe: Codable {
        var title: String
        var href: String
        var ingredients: String
        var thumbnail: String
    }
    
    struct Wrapper: Codable {
        let title: String
        let version: Double
        let href: String
        let results: [Recipe]
    }

    var allRecipes: [Recipe] = []
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.rowHeight = 90;
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        if Reachability.isConnectedToNetwork(){
                   print("connected")
                    getRecipeData()
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

    // MARK: - Table view data source
    
    func getRecipeData() {
        let mySession = URLSession(configuration: URLSessionConfiguration.default)
        
        var items = queryText.split(separator: " ")
        var itemsQuery = ""
        for item in items{
            itemsQuery+=item+","
        }
        let url = URL(string: "http://www.recipepuppy.com/api/?i=" + itemsQuery)!
        
        let task = mySession.dataTask(with: url) {data, response, error in
            guard error == nil else {
                print("error: \(error!)")
                return
            }
            
            guard let recipeData = data else {
                print("No data")
                return
            }
            
            print(recipeData)
            let decoder = JSONDecoder()
            
            do {
                var results = try decoder.decode(Wrapper.self, from: recipeData)
                self.allRecipes = results.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    if self.allRecipes.count == 0 {
                                                      let alert = UIAlertController(title:"No matching recipes found", message: "Please update your search and try again.", preferredStyle: .alert)
                                                      alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                                                      NSLog("The \"OK\" alert occured.")
                                                      }))
                                                      self.present(alert, animated: true, completion: nil)
                                                  }
                }
               
            }
            catch {
                print("error: \(error)")
            }
        }
        
        task.resume()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allRecipes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeTableViewCell
        
        cell.recipeTitleLabel.text = allRecipes[indexPath.row].title.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        cell.recipeIngredientsLabel.text = allRecipes[indexPath.row].ingredients
        cell.url = allRecipes[indexPath.row].href
        let ingredients = allRecipes[indexPath.row].ingredients.split(separator: ",")
        if (ingredients.count > 4) {
            cell.difficultyIndicator.backgroundColor = UIColor(red: 245/255, green: 232/255, blue: 115/255, alpha: 1.0)
        }
        else if (ingredients.count > 6) {
            cell.difficultyIndicator.backgroundColor = UIColor(red: 245/255, green: 124/255, blue: 115/255, alpha: 1.0)
        }
        else {
            cell.difficultyIndicator.backgroundColor = UIColor(red: 184/255, green: 245/255, blue: 115/255, alpha: 1.0)
        }
        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! RecipeFocusViewController
        let myRow = tableView!.indexPathForSelectedRow
        let currCell = tableView!.cellForRow(at: myRow!) as! RecipeTableViewCell
        destVC.recipeTitleText = (currCell.recipeTitleLabel!.text)!
        destVC.recipeIngredientsText = (currCell.recipeIngredientsLabel!.text)!
        destVC.url = (currCell.url)
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }


}
