//
//  RegistrationViewController.swift
//  Application
//
//  Created by Паша Терехов on 24.04.2022.
//

import UIKit
import CoreData

class RegistrationViewController: UIViewController {

    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var loginTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func registerTapped(_ sender: Any) {
        if nameTextField.text!.count == 0 || loginTextField.text!.count == 0 || passwordTextField.text!.count == 0 {
            print("Empry fields")
            return
        }
        
        var users: [NSManagedObject] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Users")
        
        do {
            let objects = try managedContext.fetch(fetchRequest) as? [NSManagedObject] ?? []
            users = objects
        } catch {
            print("register (36):")
        }
        
        for user in users {
            if user.value(forKey: "login") as! String == loginTextField.text! {
                print("Такой пользователь уже существует")
                return
            }
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "Users", in: managedContext)
        let user   = NSManagedObject.init(entity: entity!, insertInto: managedContext)
        
        user.setValue(nameTextField.text!, forKey: "name")
        user.setValue(loginTextField.text!, forKey: "login")
        user.setValue(passwordTextField.text!, forKey: "password")
        user.setValue(Date(), forKey: "registrationDate")
        
        let alert = UIAlertController(title: "Регистрация", message: "Регистрация прошла успешно", preferredStyle: .alert)
        let okAlert = UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction) in
            // Сохранение
            do {
                try managedContext.save()
            } catch {
                print("login (47): ", error)
            }
            
            self.dismiss(animated: false, completion: nil)
        })
        alert.addAction(okAlert)
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func backTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
