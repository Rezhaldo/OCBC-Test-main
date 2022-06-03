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
        if textFieldPassword.hasText && textFieldUsernameEntry.hasText {
//            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let dashboardViewController = storyBoard.instantiateViewController(withIdentifier: "dashboard") as! DashboardViewController
//            dashboardViewController.modalPresentationStyle = .fullScreen
//            self.present(dashboardViewController, animated: true, completion: nil)
        }
        
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
        
        loginMethod()

      
    }
    
    
    @IBAction func buttonRegisterInTapped(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let registerViewController = storyBoard.instantiateViewController(withIdentifier: "register") as! RegisterViewController
        registerViewController.modalPresentationStyle = .fullScreen
        self.present(registerViewController, animated: true, completion: nil)
        
    }
    
    func loginMethod() {
        let loginRequest = LoginRequest(username: textFieldUsernameEntry.text ?? "", password: textFieldPassword.text ?? "")
        let header = HTTPHeaders(["Content-Type":"application/json", "Accept":"application/json"])
        let loginUrl = URL(string: "https://green-thumb-64168.uc.r.appspot.com/login")
//        Alamofire.Session().request(loginUrl, method: .post, parameters: loginRequest, encoder: JSONEncoding.default, headers: "").responseJSON(completionHandler: { response in
//
//        } )
        
        AF.request(loginUrl!, method: .post, parameters: loginRequest, encoder: JSONParameterEncoder.default, headers: header).response(completionHandler: { response in
//            print("response \(response.debugDescription)")
            guard let data = response.data else { return }
            
            do {
                let decoder = JSONDecoder()
                let loginResponse = try decoder.decode(LoginResponse.self, from: data)
                print("Success request: \(loginResponse)")
                
                UserDefaults.standard.set(loginResponse.token, forKey: "user_token")
                
                UserDefaults.standard.set(loginResponse.accountNo, forKey: "account_number")
                
                UserDefaults.standard.set(loginResponse.username, forKey: "account_holder")
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let dashboardViewController = storyBoard.instantiateViewController(withIdentifier: "dashboard") as! DashboardViewController
                dashboardViewController.modalPresentationStyle = .fullScreen
                self.present(dashboardViewController, animated: true, completion: nil)
                
            } catch let error {
                print("Error request: \(error.localizedDescription)")
            }
        })
        
        //        Alamofire.Session().request(loginUrl!, method: .post, parameters: loginRequest, encoder: JSONParameterEncoder.default, headers: header).response(completionHandler: { response in
        //            print("response \(response.debugDescription)")
        //            guard let data = response.data else { return }
        //
        //            do {
        //                let decoder = JSONDecoder()
        //                let loginResponse = try decoder.decode(LoginResponse.self, from: data)
        //                print("Success request: \(loginResponse)")
        //
        //            } catch let error {
        //                print("Error request: \(error.localizedDescription)")
        //            }
        //        })
    }
    
}

