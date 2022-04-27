import UIKit
import CoreData

class LoginViewController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    // Проверка логина и пароля
    @IBAction func loginTapped(_ sender: Any) {
        if loginTextField.text!.count == 0 || passwordTextField.text!.count == 0{
            errorLabel.text = "Не заполнено одно из полей"
            return
        }
        
        var users: [NSManagedObject] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Users")
        
        do {
            let objects = try managedContext.fetch(fetchRequest)
            users = objects as? [NSManagedObject] ?? []
        } catch {
            print("login (34): ", error)
        }
        
        var hasUser = false
        for user in users {
            if user.value(forKey: "login") as! String == loginTextField.text! && user.value(forKey: "password") as! String == passwordTextField.text! {
                hasUser = true
                break
            }
        }
        
        if hasUser {
            // Если пользователь с таким логином и паролем найден, то в сущности "Logins"
            // необходимо обновить данные (что пользователь авторизовался: isLogin,
            // дата последнего входа: lastLoginDate)
            
            fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Logins")
            
            do {
                users = try managedContext.fetch(fetchRequest) as? [NSManagedObject] ?? []
            } catch {
                print("login (53): ", error)
            }
            
            var person: NSManagedObject? = nil
            for user in users {
                if user.value(forKey: "login") as? String ?? "" == loginTextField.text! {
                    person = user
                    break
                }
            }
            
            // Если пользователь с данным логином ранее не авторизовывался,
            // то в сущность добавляется новый объект
            if person == nil {
                let entity   = NSEntityDescription.entity(forEntityName: "Logins", in: managedContext)
                person       = NSManagedObject.init(entity: entity!, insertInto: managedContext)
                
                person!.setValue(loginTextField.text!, forKey: "login")
            }
            
            person!.setValue(Date(), forKey: "lastLoginDate")
            person!.setValue(true, forKey: "isLogin")
            
            // Сохранение изменений
            if managedContext.hasChanges {
                do {
                    try managedContext.save()
                } catch {
                    print("Main (53): ", error)
                }
            }
            
            dismiss(animated: true, completion: nil)
        } else {
            errorLabel.text = "Неверный логин или пароль"
        }
    }
    
    // Переход на экран регистрации
    @IBAction func register(_ sender: Any) {
        let registerVC = storyboard?.instantiateViewController(identifier: "RegistrationViewController")
        if let register = registerVC {
            errorLabel.text        = ""
            loginTextField.text    = ""
            passwordTextField.text = ""
            present(register, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.cornerRadius = 10
        loginButton.layer.borderColor  = UIColor.darkGray.cgColor
    }
    

}
