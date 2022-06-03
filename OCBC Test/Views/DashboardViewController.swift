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
        
        let accountHolder = UserDefaults.standard.string(forKey: "account_holder")
        
        let balanceURL = URL(string: "https://green-thumb-64168.uc.r.appspot.com/balance")
        
        let transactionURL = URL(string: "https://green-thumb-64168.uc.r.appspot.com/transactions")
        
        let header = HTTPHeaders(["Content-Type":"application/json", "Accept":"application/json", "Authorization": userToken])
        
                           
        AF.request(balanceURL!, method: .get, headers: header).response(completionHandler: { response in
            
            guard let data = response.data else { return }
            
            do {
                let decoder = JSONDecoder()
                let balanceResponse = try decoder.decode(BalanceResponse.self, from: data)
                    print(balanceResponse)
                self.labelAmountBalance.text = "\(balanceResponse.balance)"
                self.labelNumberOfAccount.text = "\(balanceResponse.accountNo)"
                self.labelAccountHolder.text = accountHolder
            } catch let error {
                print("Error Request: \(error.localizedDescription)")
            }
        })
        
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
