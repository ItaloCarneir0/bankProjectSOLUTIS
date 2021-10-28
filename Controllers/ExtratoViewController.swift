//
//  extratoViewController.swift
//  SolutisLogin
//
//  Created by Virtual Machine on 13/10/21.
//

import Foundation
import Alamofire
import SwiftDate

class ExtratoViewController: UIViewController, UITableViewDataSource {
   
    //MARK: - IBOUTLETS
    @IBOutlet weak var lbExtratoNome: UILabel!
    
    @IBOutlet weak var lbExtratoCPF: UILabel!
    
    @IBOutlet weak var lbExtratoSaldo: UILabel!
    
    @IBOutlet weak var aiSpinner2: UIActivityIndicatorView!
    
    @IBOutlet weak var tbExtrato: UITableView!
    
    //MARK: - VARS
    var statamentResponse = StatementResponse()
    var extrato: [StatementResponse] = []
    var user: User?
    var user2 = User()
    var apiRequest: APIRequest?
    var dataFormating = dataFormater()
    let utils = Utils()
    
    //MARK: - DIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        lbExtratoNome.adjustsFontSizeToFitWidth = true
        lbExtratoNome.minimumScaleFactor = 5
        lbExtratoNome.numberOfLines = 0
        tbExtrato.delegate = self
        tbExtrato.dataSource = self
        lbExtratoNome.text = user?.nome
        lbExtratoCPF.text = utils.formatCPF(cpf: (user?.cpf)!)
        lbExtratoSaldo.text = utils.formatBalance(value: (user?.saldo)!)
        getExtrato(token: (user?.token)!)
    }
    
    //MARK: - FUNCTIONS
    func getExtrato(token : String){
        APIRequest().getExtrato(token: token) { result in
            
            switch result{
            case .success(let respostaExtrato):
                DispatchQueue.main.async {
                    self.extrato = respostaExtrato
                    self.tbExtrato.reloadData()
                }
                    
            case .failure(let error):
                let alert = UIAlertController(title: "Erro!", message: "Ocorreu algo de errado. Tente novamente mais tarde.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print(error)
            }
        }
    }
    
    @IBAction func btLogout(_ sender: Any) {
        user?.nome = nil
        user?.cpf = nil
        user?.saldo = nil
        user?.token = nil
        let alert = UIAlertController(title: "Logout", message: "Tem certeza que deseja sair?", preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "Sim", style: UIAlertAction.Style.destructive, handler: { action in
            self.performSegue(withIdentifier: "telaLogin", sender: nil)
        }))
        alert.addAction(UIAlertAction(title: "Não", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showExtrato(){
        tbExtrato.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        if segue.identifier == "telaLogin" {
            let index = segue.destination as! ViewController
            index.user2 = self.user2
        }
    }
}

extension ExtratoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.extrato.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbExtrato.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ExtratoCustomCell
        let row = extrato[indexPath.row]
        
        if let myNumber = row.valor {
            if myNumber < 0{
                
                cell.lbExtratoValor.text = "- \(utils.formatBalance(value: myNumber))"
                cell.lbExtratoValor.textColor = UIColor .systemRed
                cell.lbExtratoStatus.text = "Pagamento"
            }else{
                cell.lbExtratoValor.text = utils.formatBalance(value: myNumber)
                cell.lbExtratoValor.textColor = UIColor .systemGreen
                cell.lbExtratoStatus.text = "Recebimento"
            }

            let passwordToFormate = row.data!
            let date = DateInRegion(passwordToFormate)
            let formattedString = date!.toFormat("dd/MM/yyyy", locale: Locales.english)
            
            cell.lbExtratoData.text = formattedString
            cell.lbExtratoDesc.text = row.descricao
        }
        return cell
    }
}
