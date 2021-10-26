//
//  extratoViewController.swift
//  SolutisLogin
//
//  Created by Virtual Machine on 13/10/21.
//

import Foundation
import Alamofire
import SwiftDate

class extratoViewController: UIViewController, UITableViewDataSource {
   
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
    
    //MARK: - DIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        lbExtratoNome.adjustsFontSizeToFitWidth = true
        lbExtratoNome.minimumScaleFactor = 5
        lbExtratoNome.numberOfLines = 0
        tbExtrato.delegate = self
        tbExtrato.dataSource = self
        lbExtratoNome.text = user?.nome
        formatCPF()
        if let userBalance = user?.saldo{
            let stringBalance = String(format: "%.2f", userBalance)
            let formatedBalance = stringBalance.replacingOccurrences(of: ".", with: ",")
            lbExtratoSaldo.text = "R$ "+(formatedBalance)
        }
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
                let alert = UIAlertController(title: "Error!", message: "Someting went wrong. Please try again later.", preferredStyle: UIAlertController.Style.alert)
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
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
            self.performSegue(withIdentifier: "telaLogin", sender: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showExtrato(){
        tbExtrato.reloadData()
    }
    
    func formatCPF(){
        if user?.cpf?.count == 11{
        let stringCPF = user?.cpf as! String
        let stringArray = [stringCPF]
        let characterArray = stringArray.flatMap { $0 }
        let stringArray2 = characterArray.map { String($0) }
        
        let formatedCPF: [String] = [
            "\(stringArray2[0])", "\(stringArray2[1])", "\(stringArray2[2]).","\(stringArray2[3])", "\(stringArray2[4])","\(stringArray2[5]).","\(stringArray2[6])","\(stringArray2[7])","\(stringArray2[8])-","\(stringArray2[9])","\(stringArray2[10])"
        ]
        lbExtratoCPF.text = (formatedCPF.joined(separator: ""))
    }else if user?.cpf?.count == 14{
        let stringCPF = user?.cpf as! String
        let stringArray = [stringCPF]
        let characterArray = stringArray.flatMap { $0 }
        let stringArray2 = characterArray.map { String($0) }
    
        let formatedCPF: [String] = [
            "\(stringArray2[0])", "\(stringArray2[1]).", "\(stringArray2[2])","\(stringArray2[3])", "\(stringArray2[4]).","\(stringArray2[5])","\(stringArray2[6])","\(stringArray2[7])/","\(stringArray2[8])","\(stringArray2[9])","\(stringArray2[10])","\(stringArray2[11])-","\(stringArray2[12])","\(stringArray2[13])"
        ]
        lbExtratoCPF.text = (formatedCPF.joined(separator: ""))
            }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        if segue.identifier == "telaLogin" {
            let index = segue.destination as! ViewController
            index.user2 = self.user2
        }
    }
}

extension extratoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.extrato.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbExtrato.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! extratoCustomCell
        let row = extrato[indexPath.row]
        
        if let myNumber = row.valor {
            if myNumber < 0{
                let roundedValue = NSString(format: "%.2f", myNumber)
                let number = "\(roundedValue)"
                let numberPreFormated = number.replacingOccurrences(of: "-", with: "")
                let numberFormated = numberPreFormated.replacingOccurrences(of: ".", with: ",")
                cell.lbExtratoValor.text = "- R$ \(numberFormated)"
                cell.lbExtratoValor.textColor = UIColor .systemRed
                cell.lbExtratoStatus.text = "Pagamento"
            }else{
                let roundedValue = NSString(format: "%.2f", myNumber)
                let number = "\(roundedValue)"
                let numberPreFormated = number.replacingOccurrences(of: "-", with: "")
                let numberFormated = numberPreFormated.replacingOccurrences(of: ".", with: ",")
                
                cell.lbExtratoValor.text = "R$ \(numberFormated)"
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
