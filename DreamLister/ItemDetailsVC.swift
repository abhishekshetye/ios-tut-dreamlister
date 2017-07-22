//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Abhishek's iMac on 7/22/17.
//  Copyright © 2017 abhishek. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var texttitle: UITextField!
    @IBOutlet weak var details: UITextField!
    @IBOutlet weak var ThumbImage: UIImageView!
    @IBOutlet weak var ImageButton: UIButton!
    @IBOutlet weak var picker: UIPickerView!
    
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    var stores = [Store]()
    
    @IBAction func deletePressed(_ sender: Any) {
        
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func ImageButtonPressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil )
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        storeData()
        navigationController?.popViewController(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            ThumbImage.image = image
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if let topItem = self.navigationController?.navigationBar.topItem{
            
            navigationController?.navigationBar.tintColor = UIColor.darkGray
            
            topItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        }
        picker.dataSource = self
        picker.delegate = self
        
//        let store1 = Store(context: context)
//        store1.name = "Best Buy"
//        let store2 = Store(context: context)
//        store2.name = "Amazon"
//        let store3 = Store(context: context)
//        store3.name = "Wallmart"
//        let store4 = Store(context: context)
//        store4.name = "Flipkart"
//        ad.saveContext()
        
        getStores()
        if itemToEdit != nil {
            loadItemData()
        }
        
    }
    
    func storeData(){
        let item: Item!
        if itemToEdit != nil {
            item = itemToEdit
        }else{
            item = Item(context: context)
            item.created = NSDate()
        }
        
        let picture = Image(context : context)
        picture.image = ThumbImage.image
        item.toImage = picture

        if let title = texttitle.text{
            item.title = title
        }
        
        if let prc = price.text{
            item.price = (prc as NSString).doubleValue
        }
        
        if let det = details.text{
            item.details = det
        }
        
        item.toStore = stores[picker.selectedRow(inComponent:0)]
        
        ad.saveContext()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        return store.name
    }
   
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //update when selected
    }
    
    func getStores(){
        let fetchReq : NSFetchRequest<Store> = Store.fetchRequest()
        do{
            try self.stores =  context.fetch(fetchReq)
            self.picker.reloadAllComponents()
            
        }catch{
            //handle error
        }
    }
    
    
    func loadItemData(){
        if let ite = itemToEdit{
            texttitle.text = ite.title
            price.text = String(describing: ite.price)
            details.text = ite.details
            if let img = ite.toImage?.image as? UIImage {
                ThumbImage.image = img
            }
            let str = ite.toStore
            var index = 0
            repeat{
                if str == stores[index] {
                    picker.selectRow(index, inComponent: 0, animated: true)
                    break
                }
                index+=1
            }while(index < stores.count )
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
}
