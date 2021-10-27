//
//  Validators.swift
//  SolutisLogin
//
//  Created by Virtual Machine on 20/10/21.
//

import Foundation
import UIKit

class Utils {
    
    func formatBalance(value: Double) -> String {
        
            let stringBalance = String(format: "%.2f", value)
            var formatedBalance = stringBalance.replacingOccurrences(of: ".", with: ",")
            formatedBalance = stringBalance.replacingOccurrences(of: "-", with: "")
            return formatedBalance
    }
    
    
    func loginValidator(user: String, password: String) -> Bool {
        //PASSWORD VALIDATION
        let passwordRegEx = "^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{7}$"
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        
        //EMAIL VALIDATION
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)

        
        if emailPred.evaluate(with: user) && passwordPred.evaluate(with: password) {
            return true
        }else{
            return false
        }
    }
    
    func formatCPF(cpf: String) -> String {
        
        if cpf.count == 11{
            let stringCPF = cpf
            let stringArray = [stringCPF]
            let characterArray = stringArray.flatMap { $0 }
            let stringArray2 = characterArray.map { String($0) }
            
            let formatedCPF: [String] = [
                "\(stringArray2[0])", "\(stringArray2[1])", "\(stringArray2[2]).","\(stringArray2[3])", "\(stringArray2[4])","\(stringArray2[5]).","\(stringArray2[6])","\(stringArray2[7])","\(stringArray2[8])-","\(stringArray2[9])","\(stringArray2[10])"
            ]

            return formatedCPF.reduce(into: "") { total, next in
                total += next
            }
            
        }else if cpf.count == 14{
            let stringCPF = cpf
            let stringArray = [stringCPF]
            let characterArray = stringArray.flatMap { $0 }
            let stringArray2 = characterArray.map { String($0) }
            
            let formatedCPF: [String] = [
                "\(stringArray2[0])", "\(stringArray2[1]).", "\(stringArray2[2])","\(stringArray2[3])", "\(stringArray2[4]).","\(stringArray2[5])","\(stringArray2[6])","\(stringArray2[7])/","\(stringArray2[8])","\(stringArray2[9])","\(stringArray2[10])","\(stringArray2[11])-","\(stringArray2[12])","\(stringArray2[13])"
            ]
            
            return formatedCPF.reduce(into: "") { total, next in
                total += next
            }
        }
        return ""
    }
    
    
    
    
}
