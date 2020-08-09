//
//  AddItemTableViewController.swift
//  ToDoList
//
//  Created by User on 6/30/20.
//  Copyright © 2020 Aidin. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingItem: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem, flag: Bool)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishDeleting item: ChecklistItem)
}


class ItemDetailViewController: UITableViewController {
     weak var delegate: ItemDetailViewControllerDelegate?
    weak var todoList: ToDoList?
    weak var itemToEdit: ChecklistItem?
    weak var itemToDelete: ChecklistItem?
    let default1 = UserDefaults.standard
    var flag = true
   

   
    
    @IBOutlet weak var deleteButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func deleteButton(_ sender: Any) {
        if let item = itemToEdit{  //the condition for detecting if this button will be used for editing
            flag = true
            delegate?.itemDetailViewController(self, didFinishEditingItem: item, flag: flag)
        }
    }
    
    
    @IBAction func doneButton(_ sender: Any) {
        if let item = itemToEdit, let text = textField.text{
            item.text = text
            flag = false
            delegate?.itemDetailViewController(self, didFinishEditingItem: item, flag: flag)
        }else{
            if let item = todoList?.newToDo(){
                if let textFieldText = textField.text{
                    item.text = textFieldText
                }
                item.checked = false
                delegate?.itemDetailViewController(self, didFinishAddingItem: item)
                UserDefaults.standard.set(try? PropertyListEncoder().encode(todoList?.toDos), forKey:"items")

            }
            
        }
        
    }
    @IBAction func cancelButton(_ sender: Any) {
           delegate?.itemDetailViewControllerDidCancel(self)
       }
    override func viewDidLoad() {
        super.viewDidLoad()
        todoList?.loadData()
        if let item = itemToEdit{
            title = "Edit item"
            textField.text = item.text
            addBarButton.isEnabled = true
        }
        
        navigationItem.largeTitleDisplayMode = .never
    }

    
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }

}

extension ItemDetailViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text,
            let stringRange = Range(range, in: oldText) else{
                return false
        }
        
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        if newText.isEmpty{
            addBarButton.isEnabled = false
        } else{
            addBarButton.isEnabled = true
        }
        return true
    }
    
}
