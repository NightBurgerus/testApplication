//
//  LoginViewController.swift
//  Application
//
//  Created by Паша Терехов on 24.04.2022.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    @IBAction func loginTapped(_ sender: Any) {
        if loginTextField.text!.count == 0 || passwordTextField.text!.count == 0{
            errorLabel.text = "Не заполнено одно из полей"
            return
        }
        
        var users: [NSManagedObject] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Users")
        
        do {
            let objects = try managedContext.fetch(fetchRequest)
            users = objects as? [NSManagedObject] ?? []
        } catch {
            print("login (34): ", error)
        }
        
        
        var hasUser = false
        for user in users {
            if user.value(forKey: "login") as! String == loginTextField.text! && user.value(forKey: "password") as! String == passwordTextField.text! {
                user.setValue(Date(), forKey: "lastLoginDate")
                
                // Сохранение изменений даты последнего входа
                do {
                    try managedContext.save()
                } catch {
                    print("login (47): ", error)
                }
                
                hasUser = true
                break
            }
        }
        
        if hasUser {
            dismiss(animated: true, completion: nil)
        } else {
            errorLabel.text = "Неверный логин или пароль"
        }
    }
    
    @IBAction func register(_ sender: Any) {
        
        let registerVC = storyboard?.instantiateViewController(identifier: "RegistrationViewController")
        if let register = registerVC {
            present(register, animated: false, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
