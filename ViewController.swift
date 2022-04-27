import UIKit
import CoreData

class ViewController: UIViewController {
    
    let TIMELIMIT                     = 15.0
    var users: [NSManagedObject]      = []
    var loginedUser: NSManagedObject? = nil
    let appDelegate                   = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    // Переход к форме авторизации
    @IBAction func login(_ sender: Any) {
        let loginVC = storyboard?.instantiateViewController(identifier: "LoginViewController")
        if let login = loginVC {
            let managedContext = appDelegate.persistentContainer.viewContext
            loginedUser?.setValue(false, forKey: "isLogin")
            
            do {
                try managedContext.save()
            } catch {
                print("Main (24): ", error)
            }
            
            present(login, animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Logins")
        
        do {
            users = try managedContext.fetch(fetchRequest) as? [NSManagedObject] ?? []
        } catch {
            print("Main (37): ", error)
        }
        
        // Поиск пользователя, который залогинен
        //var loginedUser: NSManagedObject?  = nil
        for user in users {
            if user.value(forKey: "isLogin") as? Bool ?? false {
                if Date().timeIntervalSince(user.value(forKey: "lastLoginDate") as! Date) < TIMELIMIT {
                    loginedUser = user
                } else {
                    user.setValue(false, forKey: "isLogin")
                }
            }
        }
        
        // Сохранение изменений
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch {
                print("Main (53): ", error)
            }
        }
        
        // Если залогиненного пользователя нет, открывается окно авторизации
        if loginedUser == nil {
            login(self)
        } else {
            if let name = loginedUser?.value(forKey: "login") as? String {
                greetingLabel.text = "Привет, " + name
            }
            loginButton.setTitle("Выйти", for: .normal)
        }
    }


}

