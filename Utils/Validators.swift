//
//  Validators.swift
//  SolutisLogin
//
//  Created by Virtual Machine on 20/10/21.
//

import Foundation

class Validators {
    func loginValidator(user: String, password: String) -> Bool {
        //PASSWORD VALIDATION
        let passwordRegEx = "^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{7}$"
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        
        //EMAIL VALIDATION
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
//        print(emailPred.evaluate(with: user))
//        print(passwordPred.evaluate(with: password))
        
        if emailPred.evaluate(with: user) && passwordPred.evaluate(with: password) {
            return true
        }else{
            return false
        }
    }
}
