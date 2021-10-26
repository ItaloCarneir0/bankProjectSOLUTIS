//
//  APIRequest.swift
//  SolutisLogin
//
//  Created by Virtual Machine on 20/10/21.
//

import Foundation
import Alamofire

enum APIErros: String, Error {
    case errorTreatment = "error"
}

class APIRequest {
    
    func doLogin(user: String, password: String, completionHander : (@escaping (Result<User, APIErros>) -> Void)){

        let parameters =
            [
                "username": user,
                "password": password
            ]
        let url = "https://api.mobile.test.solutis.xyz/login"
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON
        {
            response in
            switch (response.result) {
            case .success(let value):
                if response.response?.statusCode == 200{
                    if let json = value as? [String: Any]{
                        
                        let data = User(nome: (json["nome"] as? String)!, cpf: json["cpf"] as? String, saldo: (json["saldo"] as? Double)!, token: (json["token"] as? String)!)
                        
                        completionHander(.success(data))
                    }
                }else if response.response?.statusCode == 401{
                    completionHander(.failure(APIErros.errorTreatment))
                }
                break
            case .failure:
                print(Error.self)
                
            }
        }
    }
    
    func getExtrato(token: String, completionHander : (@escaping (Result<[StatementResponse], APIErros>) -> Void)){
        
        var extrato: [StatementResponse] = []
        
        let url = "https://api.mobile.test.solutis.xyz/extrato"
        let headers: HTTPHeaders = [
            "token": token]

        AF.request(url, method: .get, headers: headers).responseJSON{
            response in
            switch response.result{
            case .success:
                if let json = response.value as? [[String: Any]]{
                    for jsonCell in json{
                        let extratoValue = StatementResponse()
                        extratoValue.data = (jsonCell["data"] as! String)
                        extratoValue.descricao = (jsonCell["descricao"] as! String)
                        extratoValue.valor = (jsonCell["valor"] as! Double)
                        extrato.append(extratoValue)
                    }
                    completionHander(.success(extrato))
            }
                    break
                case .failure(let error):
                    print(error)
                }
            }
      }
    
}

