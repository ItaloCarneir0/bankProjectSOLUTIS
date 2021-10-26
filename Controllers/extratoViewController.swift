//
//  extratoViewController.swift
//  SolutisLogin
//
//  Created by Virtual Machine on 13/10/21.
//

import Foundation
import Alamofire
import SwiftyJSON

class extratoViewController: UIViewController {
    //MARK: - IBOUTLETS
    
    @IBOutlet weak var lbExtratoNome: UILabel!
    
    @IBOutlet weak var lbExtratoCPF: UILabel!
    
    @IBOutlet weak var lbExtratoSaldo: UILabel!
    
    @IBOutlet weak var aiSpinner2: UIActivityIndicatorView!
    
    @IBOutlet weak var tbExtrato: UITableView!
    
    //MARK: - VARS
    var statamentResponse = StatementResponse()
    var extrato = [StatementResponse()]
    var texto: String?
    var user: User?
//    var cell = customCell()
    //MARK: - DIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        tbExtrato.delegate = self
        tbExtrato.dataSource = self
        lbExtratoNome.text = user!.nome!
        lbExtratoCPF.text = user!.cpf!
        lbExtratoSaldo.text = "R$ "+String(user!.saldo!)
        getExtrato()
    }
    //MARK: - FUNCTIONS
    @IBAction func btLogout(_ sender: Any) {
//        aiSpinner2.startAnimating()
        user?.nome = nil
        user?.cpf = nil
        user?.saldo = nil
        user?.token = nil
//        aiSpinner2.stopAnimating()
    }
    func getExtrato(){
        let url = "https://api.mobile.test.solutis.xyz/extrato"
        let headers: HTTPHeaders = [
            "key": "token",
            "token": String((user?.token)!)]
        
        AF.request(url,method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON{
            response in
            switch response.result{
            case .success:
                if let json = response.value as? [[String: Any]]{
                    for celula in json{
                        let extrato2 = StatementResponse()
                        extrato2.data = celula["data"] as! String
                        extrato2.descricao = celula["descricao"] as! String
                        extrato2.valor = celula["valor"] as! Double
                        
                        self.extrato.append(extrato2)
                }
                    print(self.extrato[1].data)
                    print(self.extrato[1].descricao)
                    print(self.extrato[1].valor)
        
                }
                    break
                case .failure(let error):
                    print(error)
                }
            }
      }
    func showExtrato(){
//       let customCell = customCell()
       
//        customCell.lbValor.text = "1.2"
    }
}

extension extratoViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbExtrato.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                return cell
    }
}
