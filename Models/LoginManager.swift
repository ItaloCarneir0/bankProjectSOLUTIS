//
//  LoginAPI.swift
//  SolutisLogin
//
//  Created by Virtual Machine on 08/10/21. 
//

import Foundation

class loginManager {
    
    let logins: [Login]
    
    init() {
        let fileURL = Bundle.main.url(forResource: "solutis.postman_collection", withExtension: "json")!
        let jsonData = try! Data(contentsOf: fileURL)
        let jsonDecoder = JSONDecoder()
        logins = try! jsonDecoder.decode([Login].self, from: jsonData)
    }
    
    func getLogin() -> Login{
        //let index = Int(arc4random_uniform(UInt32(logins.count)))
        return logins[0]
        
        }
}








class LoginAPI
{
    
    
}





