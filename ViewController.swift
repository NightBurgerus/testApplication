//
//  ViewController.swift
//  Application
//
//  Created by Паша Терехов on 24.04.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    
    var users: [NSManagedObject] = []
    
    // Переход к форме авторизации
    @IBAction func login(_ sender: Any) {
        let loginVC = storyboard?.instantiateViewController(identifier: "LoginViewController")
        if let login = loginVC {
            present(login, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContex = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Users")
        
        do {
            let objects = try managedContex.fetch(fetchRequest)
            if objects.count != 0 {
                users = objects as! [NSManagedObject]
            }
        } catch {
            print("37: ", error)
        }
        
        var loginDate: TimeInterval? = nil
        
        // Поиск наименьшего интервала с момента авторизации до текущего времени
        for user in users {
            if loginDate == nil {
                loginDate = Date().timeIntervalSince(user.value(forKey: "lastLoginDate") as! Date)
            } else {
                if Date().timeIntervalSince(user.value(forKey: "lastLoginDate") as! Date) < loginDate! {
                    loginDate = Date().timeIntervalSince(user.value(forKey: "lastLoginDate") as! Date)
                }
            }
        }

        
        // Если зарегистрированных пользователей нет, либо с момента последней авторизации прошло
        // 15 секунд, то переход на экран авторизации
        
        if users.count == 0  || loginDate ?? 0.0 > 15.0 {
            let loginVC = storyboard?.instantiateViewController(identifier: "LoginViewController")
            if let login = loginVC {
                present(login, animated: false, completion: nil)
            }
        }
        
    }


}

