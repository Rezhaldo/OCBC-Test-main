//
//  RegisterViewController.swift
//  OCBC Test
//
//  Created by Kevin Chilmi Rezhaldo on 22/05/22.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {

    @IBOutlet weak var viewBackgroundRegister: UIView!
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldConfirmPassword: UITextField!
    @IBOutlet weak var buttonRegister: UIButton!
    @IBOutlet weak var labelAlertUsername: UILabel!
    @IBOutlet weak var labelAlertPassword: UILabel!
    @IBOutlet weak var labelAlertConfirmPassword: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        RegisterView()
    }
    
    @IBAction func buttonCancelInTapped(_ sender: Any) {
        self.dismiss(animated: true)

    }
    
    @IBAction func buttonRegisterInTapped(_ sender: Any) {
        if textFieldUsername.hasText {
            labelAlertUsername.isHidden = true
        } else {
            labelAlertUsername.isHidden = false
        }
        
        if textFieldPassword.hasText {
            labelAlertPassword.isHidden = true
        } else {
            labelAlertPassword.isHidden = false
        }
        
        if textFieldConfirmPassword.text == textFieldPassword.text {
            labelAlertConfirmPassword.isHidden = true
        } else {
            labelAlertConfirmPassword.isHidden = false
        }
        
        let registerRequest = RegisterRequest(username: textFieldUsername.text ?? "", password: textFieldPassword.text ?? "")
        
        let header = HTTPHeaders(["Content-Type":"application/json", "Accept":"application/json"])
        let registerUrl = URL(string: "https://green-thumb-64168.uc.r.appspot.com/register")
        
        AF.request(registerUrl!, method: .post, parameters: registerRequest, encoder: JSONParameterEncoder.default, headers: header).response(completionHandler: { response in
            
            guard let data = response.data else { return }
            
            do {
                let decoder = JSONDecoder()
                let registerResponse =
                try decoder.decode(RegisterResponse.self, from: data)
                print(registerResponse)
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let dashboardViewController = storyBoard.instantiateViewController(withIdentifier: "login") as! LoginViewController
                dashboardViewController.modalPresentationStyle = .fullScreen
                self.present(dashboardViewController, animated: true, completion: nil)
                
            } catch let error {
                print("Error Request: \(error.localizedDescription)")
            }
        })
    }
    
    func RegisterView() {
        viewBackgroundRegister.backgroundColor = UIColor.white
        viewBackgroundRegister.layer.borderColor = UIColor.black.cgColor
        viewBackgroundRegister.layer.borderWidth = 0.25
        viewBackgroundRegister.layer.shadowOffset = CGSize (width:10, height:10)
        viewBackgroundRegister.layer.shadowRadius = 5
        viewBackgroundRegister.layer.shadowOpacity = 0.3
        
        textFieldUsername.layer.shadowOffset = CGSize(width: 5, height: 5)
        textFieldUsername.layer.shadowRadius = 3
        textFieldUsername.layer.shadowOpacity = 0.2
        textFieldPassword.layer.shadowOffset = CGSize(width: 5, height: 5)
        textFieldPassword.layer.shadowRadius = 3
        textFieldPassword.layer.shadowOpacity = 0.2
        textFieldPassword.isSecureTextEntry = true
        textFieldConfirmPassword.layer.shadowOffset = CGSize(width: 5, height: 5)
        textFieldConfirmPassword.layer.shadowRadius = 3
        textFieldConfirmPassword.layer.shadowOpacity = 0.2
        textFieldConfirmPassword.isSecureTextEntry = true
    }


}
