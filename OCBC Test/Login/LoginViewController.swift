//
//  ViewController.swift
//  OCBC Test
//
//  Created by Kevin Chilmi Rezhaldo on 19/05/22.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var textFieldUsernameEntry: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var labelAlertUsername: UILabel!
    @IBOutlet weak var labelAlertPassword: UILabel!
    @IBOutlet weak var viewLoginBackground: UIView!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var buttonRegister: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.white
        
        //LoginBackground
        loginViewBackground()

        //TextFieldViewBackground
        textFieldViewBackground()
        
        textFieldUsernameEntry.delegate = self
        textFieldPassword.delegate = self
        
        //ButtonLogin/RegisterView
        buttonLoginView()

    }
    
    func loginViewBackground() {
        viewLoginBackground.backgroundColor = UIColor.white
        viewLoginBackground.layer.borderColor = UIColor.black.cgColor
        viewLoginBackground.layer.borderWidth = 0.25
        viewLoginBackground.layer.shadowOffset = CGSize (width:10, height:10)
        viewLoginBackground.layer.shadowRadius = 5
        viewLoginBackground.layer.shadowOpacity = 0.3
    }
    
    func textFieldViewBackground() {
        textFieldUsernameEntry.layer.shadowOffset = CGSize(width: 5, height: 5)
        textFieldPassword.layer.shadowOffset = CGSize(width: 5, height: 5)
        textFieldUsernameEntry.layer.shadowRadius = 3
        textFieldUsernameEntry.layer.shadowOpacity = 0.2
        textFieldPassword.layer.shadowRadius = 3
        textFieldPassword.layer.shadowOpacity = 0.2
        
        textFieldPassword.isSecureTextEntry = true
        
    }
    
    func buttonLoginView() {
        buttonLogin.layer.shadowOffset = CGSize(width: 10, height: 10)
        buttonLogin.layer.shadowRadius = 3
        buttonLogin.layer.shadowOpacity = 0.2
        buttonRegister.layer.shadowOffset = CGSize(width: 10, height: 10)
        buttonRegister.layer.shadowRadius = 3
        buttonRegister.layer.shadowOpacity = 0.2
    }
    
    func textFieldShouldReturn (_ textField: UITextField) -> Bool {
        self.textFieldUsernameEntry.resignFirstResponder()
        self.textFieldPassword.resignFirstResponder()
        
        return true
    }
    
    
    @IBAction func buttonLoginInTapped(_ sender: Any) {
        
        guard let username = textFieldUsernameEntry.text else {return}
        guard let password = textFieldPassword.text else {return}
        
        if textFieldUsernameEntry.hasText{
            labelAlertUsername.isHidden = true
        }else{
            labelAlertUsername.isHidden = false
        }
        
        if textFieldPassword.hasText{
            labelAlertPassword.isHidden =  true
        }else{
            labelAlertPassword.isHidden = false
        }
        
        
        let modelLogin = LoginRequest(username: username, password: password)
        APIManager.shareInstance.callingLoginAPI(login: modelLogin, completion: {response in
            
            switch response{
            case .success(let json):
                if let objJson = json as? LoginResponse {
                    let username = objJson.username
                    let token = objJson.token
                    let accountNo = objJson.accountNo
                    
                    UserDefaults.standard.set(accountNo, forKey: "accountNo")
                    UserDefaults.standard.set(username, forKey: "account_holder")
                    UserDefaults.standard.set(token, forKey: "user_token")
                    
                }
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let dashboardViewController = storyBoard.instantiateViewController(withIdentifier: "dashboard") as! DashboardViewController
                dashboardViewController.modalPresentationStyle = .fullScreen
                self.present(dashboardViewController, animated: true)
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        })

      
    }
    
    
    @IBAction func buttonRegisterInTapped(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Register", bundle: nil)
        let registerViewController = storyBoard.instantiateViewController(withIdentifier: "register") as! RegisterViewController
        registerViewController.modalPresentationStyle = .fullScreen
        self.present(registerViewController, animated: true, completion: nil)
        
    }
    
    
}

