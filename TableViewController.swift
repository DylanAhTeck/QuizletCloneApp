//
//  TableTableViewController.swift
//  AhTeckDylanHW6
//
//  Created by Dylan  Ah Teck on 11/1/19.
//  Copyright © 2019 Dylan  Ah Teck. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    private var model = FlashcardsModel.shared

    

        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

  
    
    //
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView?.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return model.numberOfFlashcards()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flashcard", for: indexPath)
        
        
        // Configure the cell...
        if let label = cell.textLabel {
            //label.text = "Row \(indexPath.row + 1)"

            if let flashcard = model.flashcard(at: indexPath.row)
            {
                label.text = flashcard.getQuestion()
                if let subtitle = cell.detailTextLabel {
                    subtitle.text = flashcard.getAnswer()
                }
            }
        }
        //else {print ("null")}
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

  
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Deleting is a two-step process
            // Must first delete from data source
            // and then delete from view
            
            // Delete the row from the data source (i.e., model)
            model.removeFlashcard(at: indexPath.row)
            
            // Delete from tableview
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Alternate way to delete from tableview
            // tableView.reloadData()
        }
    }

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        model.rearrageFlashcards(from: fromIndexPath.row, to: to.row)

    }
 

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

 
}
