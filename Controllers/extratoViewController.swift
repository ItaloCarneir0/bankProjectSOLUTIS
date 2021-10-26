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
    var extrato: [StatementResponse] = []
    var texto: String?
    var user: User?
    //MARK: - DIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        tbExtrato.delegate = self
        tbExtrato.dataSource = self
        lbExtratoNome.text = user!.nome!
        lbExtratoCPF.text = user!.cpf!
        lbExtratoSaldo.text = "R$ "+String(user!.saldo!)
        getExtrato()
        showExtrato()
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
                    print(self.extrato[0].data)
                    print(self.extrato[0].descricao)
                    print(self.extrato[0].valor)
        
                    print("extrato")
                    DispatchQueue.main.async {
                        self.tbExtrato.reloadData()
                    }
                    
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
        tbExtrato.reloadData()
    }
}

extension extratoViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(extrato.count)
        return extrato.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbExtrato.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! extratoCustomCell
        let row = extrato[indexPath.row]
        
        if let myNumber = row.valor {
            if myNumber < 0{
                let number = "\(myNumber)"
                let numberPreFormated = number.replacingOccurrences(of: "-", with: "")
                let numberFormated = numberPreFormated.replacingOccurrences(of: ".", with: ",")
    
                cell.lbExtratoValor.text = "- R$ \(numberFormated)"
                cell.lbExtratoValor.textColor = UIColor .systemRed
                cell.lbExtratoStatus.text = "Pagamento"
            }else{
                let number = "\(myNumber)"
                let numberPreFormated = number.replacingOccurrences(of: "-", with: "")
                let numberFormated = numberPreFormated.replacingOccurrences(of: ".", with: ",")
                
                cell.lbExtratoValor.text = "R$ \(numberFormated)"
                cell.lbExtratoValor.textColor = UIColor .systemGreen
                cell.lbExtratoStatus.text = "Recebimento"
            }
            cell.lbExtratoDesc.text = row.descricao
        }
        return cell
        
    }
}
