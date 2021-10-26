//
//  dataFormater.swift
//  SolutisLogin
//
//  Created by Virtual Machine on 25/10/21.
//

import Foundation

class dataFormater{
    func formatCPF(cpf: String, completionHander : (@escaping (Result<[User], APIErros>) -> Void)){
        
        if cpf.count == 11{
            let stringCPF = cpf as! String
            let stringArray = [stringCPF]
            let characterArray = stringArray.flatMap { $0 }
            let stringArray2 = characterArray.map { String($0) }
        
            let formatedCPF: [String] = [
            "\(stringArray2[0])", "\(stringArray2[1])", "\(stringArray2[2]).","\(stringArray2[3])", "\(stringArray2[4])","\(stringArray2[5]).","\(stringArray2[6])","\(stringArray2[7])","\(stringArray2[8])-","\(stringArray2[9])","\(stringArray2[10])"
        ]
            
        }else if cpf.count == 14{
            let stringCPF = cpf as! String
        let stringArray = [stringCPF]
        let characterArray = stringArray.flatMap { $0 }
        let stringArray2 = characterArray.map { String($0) }
            
        let formatedCPF: [String] = [
            "\(stringArray2[0])", "\(stringArray2[1]).", "\(stringArray2[2])","\(stringArray2[3])", "\(stringArray2[4]).","\(stringArray2[5])","\(stringArray2[6])","\(stringArray2[7])/","\(stringArray2[8])","\(stringArray2[9])","\(stringArray2[10])","\(stringArray2[11])-","\(stringArray2[12])","\(stringArray2[13])"
        ]
            }
      }
   
}
