//
//  ViewController.swift
//  SolutisLogin
//
//  Created by Virtual Machine on 07/10/21.
//

import UIKit
import Alamofire


class ViewController: UIViewController {
    
    func doLogin()
    {
        let user = tfUser.text!
        let pass = tfPassword.text!

        let parameters = [
                "username": user,
                "password": pass
            ]
            let url = "https://api.mobile.test.solutis.xyz/login"
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON {
                    response in
                    switch (response.result) {
                    case .success:
                        print(response)
                        self.lbError.isHidden=false
                        break
                    case .failure:
                        print(Error.self)
                    }
                }
        
    }
    
    
    
    let loginsManager = loginManager()
    
    
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var lbResult1: UILabel!
    
    
    @IBOutlet weak var lbTeste: UILabel!
    

    @IBOutlet weak var tfUser: UITextField!
    
    
    @IBOutlet weak var lbError: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    
    @IBAction func btnLogin(_ sender: Any)
    {
        doLogin()
    }
}
    
        
        
    



