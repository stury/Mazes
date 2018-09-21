//
//  MasterViewController.swift
//  Amaze
//
//  Created by Scott Tury on 9/18/18.
//  Copyright © 2018 self. All rights reserved.
//

import UIKit
import MazeKit

struct AvailableMaze : Codable {
    let type : String
    let image : String
}

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects : [AvailableMaze] = [AvailableMaze]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        // Load in the plist describing what we're showing in the list!
        if let resource = Bundle.main.url(forResource: "Mazes", withExtension: "plist") {
            do {
                if let data = try? Data(contentsOf: resource) {
                    let decoder = PropertyListDecoder()
                    let contents : [AvailableMaze] = try decoder.decode([AvailableMaze].self, from: data)
                    print( contents )
                    objects = contents
                }
            }
            catch {
                print( error )
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    func insertNewObject(_ sender: Any) {
//        objects.insert(NSDate(), at: 0)
//        let indexPath = IndexPath(row: 0, section: 0)
//        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    func mazeHelper( for title: String ) -> MazeHelper? {
        var result : MazeHelper?
        
        switch title {
        case "Circular":
            result = CircularMazeHelper()
        case "Triangular":
            result = TriangularMazeHelper()
        case "Pyramid":
            result = PyramidMazeHelper()
        case "Hexagonal":
            result = HexagonalMazeHelper()
        //case "Rectangular":
        default:
            result = MazeHelper()
        }
        
        return result
    }
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                
                // Based on the Row, we'll want to create different MazeHelper objects for the DetailViewController to use.
                controller.helper = mazeHelper(for: object.type)
                
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ChooseMazeCell
        
        let object = objects[indexPath.row]
        if let cell = cell {
            cell.message.text = object.type
            cell.example.image = UIImage(named: object.image)
            return cell
        }
        else {
            let cell = UITableViewCell()
            cell.imageView?.image = UIImage(named: object.image)
            cell.textLabel?.text = object.type
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

