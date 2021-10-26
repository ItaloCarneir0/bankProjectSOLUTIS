//
//  ViewController.swift
//  SolutisLogin
//
//  Created by Virtual Machine on 07/10/21.
//

import UIKit
import Alamofire
import SwiftyJSON
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
    var user = User()
    let keychain = Keychain(service: "br.com.treinamento.SolutisLogin")
    //MARK: - DIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        tfUser.text = keychain["UserKey"]
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
        doLogin()
        let passwordVal = tfPassword.text!
        let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{,}$"
        let rule = PredicateRule(predicate: NSPredicate(format: "SELF BEGINSWITH %@", passwordRegx))
        let validator = PasswordValidator(rules: [rule])
        if let failingRules = validator.validate(passwordVal) {
            print("INVALID")
            self.tfUser.textColor = UIColor.red
            self.tfPassword.textColor = UIColor.red
        } else {
            print("VALID")
        }

        if swRememberPass.isOn{
            let userKey = tfUser.text
            keychain["UserKey"] = userKey
        }else{
            let userKey:String? = nil
            keychain["UserKey"] = userKey
        }
        btnLogin.isEnabled = false
        aiSpinner.startAnimating()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        if segue.identifier == "telaExtrato" {
            let teste = segue.destination as! extratoViewController
            teste.user = self.user
        }
    }
    func doLogin() {
        let user = tfUser.text!
        let pass = tfPassword.text!
        let parameters =
            [
                "username": user,
                "password": pass
            ]
        let url = "https://api.mobile.test.solutis.xyz/login"
        
//        func validatePassword(){
//            if especialChar.evaluate(with: pass) == true{
//                print("Senha valida")
////                }else{
////                    print("Senha invalida")
////                    lbSenhaInvalida.isHidden = true
////                    self.tfPassword.textColor = UIColor.red
////                }
////            if alphanumericChar.evaluate(with: pass) == true{
////                print("Senha valida")
////            }else{
////                print("Senha invalida")
////            }
//        validatePassword()
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON
        {
                    response in
            switch (response.result)
                {
                    case .success(let value):
                        if let json = value as? [String: Any]
                        {
                            if let nome = json["nome"] as? String
                            {
                                print(nome)
                                self.user.nome = nome
                                self.lbError.isHidden=true
                            }else if (json["nome"]) == nil
                            {
                                self.aiSpinner.startAnimating()
                                self.lbError.isHidden=false
                                self.tfUser.textColor = UIColor.red
                                self.tfPassword.textColor = UIColor.red
                                self.aiSpinner.stopAnimating()
                            }
                            if let cpf = json["cpf"] as? String{
                                print(cpf)
                                let success = BooleanValidator().validate(cpf: cpf)
                                if success == true{
                                    print("CPF VALIDO")
                                }else{
                                    print("CPF INVALIDO")
                                }
                                self.user.cpf = cpf
                                self.lbError.isHidden=true
                            }
                            if let saldo = json["saldo"] as? Double{
                                print(saldo)
                                self.user.saldo = saldo
                                self.lbError.isHidden=true
                            }
                            if let token = json["token"] as? String{
                                print(token)
                                self.user.token = token
                                self.lbError.isHidden=true
                                self.performSegue(withIdentifier: "telaExtrato", sender: nil)
                            }
                            self.aiSpinner.stopAnimating()
                            self.btnLogin.isEnabled = true
                        }
                       // print(response)
                    break
                    case .failure:     
                    print(Error.self)
                }
          }
    }
}

    



