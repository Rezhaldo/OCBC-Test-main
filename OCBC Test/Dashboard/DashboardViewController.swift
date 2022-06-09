//
//  DashboardViewController.swift
//  OCBC Test
//
//  Created by Kevin Chilmi Rezhaldo on 21/05/22.
//

import UIKit
import Alamofire

class DashboardViewController: UIViewController {

    @IBOutlet weak var tableViewTransactionHistory: UITableView!
    @IBOutlet weak var labelAmountBalance: UILabel!
    @IBOutlet weak var labelNumberOfAccount: UILabel!
    @IBOutlet weak var labelAccountHolder: UILabel!
    @IBOutlet weak var buttonLogout: UIButton!
    @IBOutlet weak var viewTopCard: UIView!
    @IBOutlet weak var buttonMakeTransfer: UIButton!
    
    var transactionData: TransactionResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.view.backgroundColor = UIColor(named: "dasar")
        viewTopCard.backgroundColor = UIColor.white
        viewTopCard.layer.shadowOffset = CGSize (width:10, height:10)
        viewTopCard.layer.shadowRadius = 5
        viewTopCard.layer.shadowOpacity = 0.3
        
        tableViewTransactionHistory.register(UINib(nibName: "TransactionTableViewCell", bundle: Bundle(for: TransactionTableViewCell.self)), forCellReuseIdentifier: "TransactionCell")
        tableViewTransactionHistory.delegate = self
        tableViewTransactionHistory.dataSource = self
        
        let userToken = UserDefaults.standard.string(forKey: "user_token") ?? ""
        
        APIManager.shareInstance.callingBalanceAPI(completionHandeler: { response in
            
            switch response {
            case.success(let json):
                if let objJson = json as? BalanceResponse {
                    let getBalance = objJson.balance
                    print("You get",objJson.balance, objJson.accountNo)
                    self.labelAmountBalance.text = "\(getBalance)"
                    
                }
                if let username = UserDefaults.standard.string(forKey: "account_holder") {
                    self.labelAccountHolder.text = username
                    print("teste \(username)")
                    
                }
                
                if let accountNo = UserDefaults.standard.string(forKey: "accountNo") {
                    self.labelNumberOfAccount.text = accountNo
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        })
        

        
        let transactionURL = URL(string: "https://green-thumb-64168.uc.r.appspot.com/transactions")
        
        let header = HTTPHeaders(["Content-Type":"application/json", "Accept":"application/json", "Authorization": userToken])
        
                           
        
        AF.request(transactionURL!, method: .get, headers: header).response(completionHandler: { response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let transactionResponse = try decoder.decode(TransactionResponse.self, from: data)
                self.transactionData = transactionResponse
                self.tableViewTransactionHistory.reloadData()
            } catch let error {
                print("Error Request: \(error.localizedDescription)")
            }
        })
    }
    
    @IBAction func buttonLogoutInTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return transactionData?.data.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionData?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionTableViewCell
        
        if let tran = transactionData?.data[indexPath.row] {
            cell.setData(data: tran)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateFormatterGet = DateFormatter()
        
        var date: Date = Date()
        
        dateFormatterGet.dateFormat = "yyyy-MM-dd-'T'HH:mm:ss.sssZ"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
//        if let data = transactionData?.data, data.count > 0 {
//            print("there is data")
//        } else {
//            print("there is no data")
//        }
        
        if let tran = transactionData?.data[section] {
            if let dateStr = tran.transactionDate {
                if let date1 = dateFormatterGet.date(from: dateStr) {
                    date = date1
                }
            }
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd,yyyy"
        return formatter.string(from: date)
    }
    
}
