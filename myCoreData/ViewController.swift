//
//  ViewController.swift
//  myCoreData
//
//  Created by ezeepay on 09/03/18.
//  Copyright © 2018 ezeepay. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet var tblVw: UITableView!
    
    var people: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "NameDict")
        
        do {
            
            people = try managedContext.fetch(fetchReq)
        } catch let error {
            
            print(error)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let person = people[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath)
        
        cell.textLabel?.text = "\(person.value(forKeyPath: "name") as! String) \(person.value(forKeyPath: "age") as! Int32)"
        return cell
    }
    
    @IBAction func removeAllData(_ sender: Any) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "NameDict")


        if let result = try? managedContext.fetch(fetchReq) {
            for object in result {
                managedContext.delete(object)
            }
        }
        
//        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
//        fetchRequest.predicate = Predicate.init(format: "profileID==\(withID)")
//        let object = try! context.fetch(fetchRequest)
//        context.delete(object)
        
        do {
            try managedContext.save() // <- remember to put this :)
        } catch let error {
            print(error)
        }

        
        people.removeAll()
        tblVw.reloadData()
    }
    
    @IBAction func adduser(_ sender: Any) {
        
        let alert = UIAlertController(title: "New Name",
                                      message: "Add a new name",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            
            guard let textField = alert.textFields?.first, let nameToSave = textField.text, let textField2 = alert.textFields?.last, let ageToSave = textField2.text else {
                return
            }
            
            self.saveToCoreDate(name: nameToSave, age: Int32(ageToSave)!)
            self.tblVw.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        alert.addTextField()
        alert.textFields?.last?.keyboardType = .numberPad
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func saveToCoreDate(name: String, age: Int32) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "NameDict", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        
        person.setValue(name, forKeyPath: "name")
        person.setValue(age, forKeyPath: "age")
        
        do {
            
            try managedContext.save()
            people.append(person)
        } catch let error {
            
            print(error)
        }
        
    }
}

