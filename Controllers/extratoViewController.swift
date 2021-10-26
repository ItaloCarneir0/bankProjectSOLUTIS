//
//  extratoViewController.swift
//  SolutisLogin
//
//  Created by Virtual Machine on 13/10/21.
//

import Foundation
import Alamofire


class extratoViewController: UIViewController {
    
    
    @IBOutlet weak var lbExtratoNome: UILabel!
    
    @IBOutlet weak var lbExtratoCPF: UILabel!
    
    @IBOutlet weak var lbExtratoSaldo: UILabel!
    
    
    @IBAction func btLogout(_ sender: Any) {
        user?.nome = nil
        user?.cpf = nil
        user?.saldo = nil
        user?.token = nil
    }
    
    
    func getExtrato(){
        let url = "https://api.mobile.test.solutis.xyz/extrato"
        let headers: HTTPHeaders = [
            "key": "token",
            "token": "5EB63BBBE01EEED093CB22BB8F5ACDC3"]
        
        AF.request(url,method: .get, parameters: nil, headers: headers).responseJSON {
            response in
            
            print(response)
        }
    }
    
    
    
    @IBAction func btTeste(_ sender: Any) {
        getExtrato()
    }
    
    
    
    
    var texto: String?
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        lbExtratoNome.text = user!.nome!
        lbExtratoCPF.text = user!.cpf!
        lbExtratoSaldo.text = String(user!.saldo!)
    }
    
    
    
    
    

}
