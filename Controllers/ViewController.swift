//
//  ViewController.swift
//  SolutisLogin
//
//  Created by Virtual Machine on 07/10/21.
//

import UIKit
import Alamofire
import KeychainAccess
import CPF_CNPJ_Validator
import Navajo_Swift

class ViewController: UIViewController {
    //MARK: - IBOUTLETS
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var lbResult1: UILabel!
    
    @IBOutlet weak var aiSpinner: UIActivityIndicatorView!
    
    @IBOutlet weak var lbTeste: UILabel!
    
    @IBOutlet weak var tfUser: UITextField!
    
    @IBOutlet weak var lbError: UILabel!
    
    @IBOutlet weak var lbSenhaInvalida: UILabel!
    
    @IBOutlet weak var swRememberPass: UISwitch!
    
    //MARK: - VARS
    var user2 = User()
    let apiRequest = APIRequest()
    let keychain = Keychain(service: "br.com.treinamento.SolutisLogin")
    
    //MARK: - DIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        tfPassword.text = keychain["PassKey"]
        if keychain["PassKey"] == nil {
            tfPassword.text = ""
        }else{
            swRememberPass.isOn = true
        }
    }
    //MARK: - FUNCTION
    @IBAction func tfUserTurnBlack(_ sender: Any) {
        tfUser.textColor=UIColor.black
        tfPassword.textColor=UIColor.black
        self.tfPassword.textColor = UIColor.black
        self.lbError.isHidden=true
    }
    @IBAction func tfPasswordTurnBlack(_ sender: Any) {
        tfPassword.textColor=UIColor.black
        tfUser.textColor=UIColor.black
        self.tfPassword.textColor = UIColor.black
        self.lbError.isHidden=true
    }
    @IBAction func btnLogin(_ sender: Any) {
        aiSpinner.startAnimating()
        btnLogin.isEnabled = false
        
        let user = tfUser.text!
        let password = tfPassword.text!
        
        if Utils().loginValidator(user: user, password: password){
            APIRequest().doLogin(user: user, password: password) { result in
                switch result{
                case .success(let user):
                    DispatchQueue.main.async {
                        //SUCESSO
                        if self.swRememberPass.isOn{
                            let passKey = self.tfPassword.text
                            self.keychain["PassKey"] = passKey
                         }else{
                             let passKey:String? = nil
                            self.keychain["PassKey"] = nil
                         }

                        let success = BooleanValidator().validate(cpf: user.cpf!)
                        if success == true{
                            print("CPF VALIDO")
                        }else{
                            print("CPF INVALIDO")
                        
                         self.aiSpinner.stopAnimating()
                         self.btnLogin.isEnabled = true
                        
                        self.user2 = user
                        self.performSegue(withIdentifier: "telaExtrato", sender: nil)
                    }
                }
                case .failure(let error):
                  //ERRO
                    self.aiSpinner.stopAnimating()
                    self.btnLogin.isEnabled = true
                    let alert = UIAlertController(title: "Error!", message: "Someting went wrong. Please try again later.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
//                    print(error)
                }
            }

        }else{
            aiSpinner.startAnimating()
            lbError.isHidden=false
            tfUser.textColor = UIColor.red
            tfPassword.textColor = UIColor.red
            aiSpinner.stopAnimating()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        if segue.identifier == "telaExtrato" {
            let index = segue.destination as! extratoViewController
            index.user = self.user2
        }
    }
}

    



