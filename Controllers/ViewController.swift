//
//  ViewController.swift
//  SolutisLogin
//
//  Created by Virtual Machine on 07/10/21.
//

import UIKit
import Alamofire


class ViewController: UIViewController {
    
    var user = User()
    
    func doLogin()
    {
        let user = tfUser.text!
        let pass = tfPassword.text!

        let parameters =
            [
                "username": user,
                "password": pass
            ]
        let url = "https://api.mobile.test.solutis.xyz/login"
        
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
                        }
                       // print(response)
                    break
                    case .failure:
                    print(Error.self)
                }
          }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        if segue.identifier == "telaExtrato"{
            let teste = segue.destination as! extratoViewController
            teste.user = self.user
        }
        
    }
    
    let loginsManager = loginManager()
    
    
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var lbResult1: UILabel!
    
    @IBOutlet weak var aiSpinner: UIActivityIndicatorView!
    
    @IBOutlet weak var lbTeste: UILabel!
    
    @IBOutlet weak var tfUser: UITextField!
    
    @IBOutlet weak var lbError: UILabel!
    
    
    @IBAction func tfUserTurnBlack(_ sender: Any) {
        tfUser.textColor=UIColor.black
        tfPassword.textColor=UIColor.black
        self.lbError.isHidden=true    }
    
    @IBAction func tfPasswordTurnBlack(_ sender: Any) {
        tfPassword.textColor=UIColor.black
        tfUser.textColor=UIColor.black
        self.lbError.isHidden=true    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func btnLogin(_ sender: Any)
    {
        doLogin()
        aiSpinner.startAnimating()
    }
}

    



