//
//  ViewController.swift
//  DreamLister
//
//  Created by Abhishek's iMac on 7/21/17.
//  Copyright © 2017 abhishek. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentcontrol: UISegmentedControl!

    var controller : NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //generateTestData()
        attemptFetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections{
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections{
            let sectionsInfo = sections[section]
            return sectionsInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? ItemCell {
            configureCell(cell: cell, indexPath: indexPath)
            return cell
        }else{
            return  UITableViewCell()
        }
    }
    
    func configureCell (cell: ItemCell, indexPath : IndexPath){
        let item = controller.object(at: indexPath)
        cell.configureCell(item: item)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = controller.fetchedObjects, objs.count > 0 {
            let item = objs[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailsVC" {
            if let destination = segue.destination as? ItemDetailsVC{
                if let item = sender as? Item{
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    @IBAction func segmentValueChange(_ sender: Any) {
        attemptFetch()
        tableView.reloadData()
    }
    
    
    
    func attemptFetch(){
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        
        if segmentcontrol.selectedSegmentIndex == 0{
            fetchRequest.sortDescriptors = [dateSort]
        }else if segmentcontrol.selectedSegmentIndex == 1 {
            fetchRequest.sortDescriptors = [priceSort]
        }else {
            fetchRequest.sortDescriptors = [titleSort]
        }
        
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        self.controller = controller
        
        
        do{
            try controller.performFetch()
        }catch{
            let err = error as NSError
            print(err.description)
        }
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        print("Here called\(type)")
        
        switch(type){
        case .insert:
            if let indexpath = newIndexPath {
                tableView.insertRows(at: [indexpath], with: .fade)
            }
            break
        case .delete:
            print("delete called")
            if let indexpath = indexPath{
                tableView.deleteRows(at: [indexpath], with: .fade)
            }
            break;
            
        case .update:
            if let indexpath = indexPath{
                let cell = tableView.cellForRow(at: indexpath) as! ItemCell
                //update the cell
                configureCell(cell: cell, indexPath: indexPath!)
            }
            break;
            
        case .move:
            if let indexpath = newIndexPath{
                tableView.deleteRows(at: [indexpath], with: .fade)
            }
            if let indexpath = newIndexPath{
                tableView.insertRows(at: [indexpath], with: .fade)
            }
            break;
        }
        
    }
    
    
    
    func generateTestData(){
        let item1 = Item(context: context)
        item1.title = "Mac book pro pro"
        item1.price = 1800
        item1.details = "This is the new and the most powerful mac book the world has ever seen"
        
        let item2 = Item(context: context)
        item2.title = "Mac book pro pro"
        item2.price = 1800
        item2.details = "This is the new and the most powerful mac book the world has ever seen"
        
        let item3 = Item(context: context)
        item3.title = "Mac book pro pro"
        item3.price = 1800
        item3.details = "This is the new and the most powerful mac book the world has ever seen"
        
        ad.saveContext()
    }
    
    
    
    
    
    
    

}

