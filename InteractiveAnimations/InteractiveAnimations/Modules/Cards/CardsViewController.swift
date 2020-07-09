//
//  CardsViewController.swift
//  CredApp
//
//  Created by Priya Arora on 23/06/20.
//  Copyright © 2020 deeporg. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController, UITableViewDataSource, CardTableViewDelegate {
    private enum Constants  {
        static let cellId = "cardCell"
        static let backgroundColor = UIColor(red: 17.0/255, green: 19.0/255, blue: 28.0/255, alpha: 1)
        static let titleColor = UIColor(red: 150.0/255, green: 195.0/255, blue: 213.0/255, alpha: 1)
        static let btnTextColor = UIColor(red: 27.0/255, green: 33.0/255, blue: 46.0/255, alpha: 1)
        static let titleStr = "cards"
        static let titleFontSize: CGFloat = 40
        static let addNewStr = "+ Add new"
        static let tableRowHeight: CGFloat = 260
        static let addNewBtnCornerRadius: CGFloat = 10
        static let titleLeadingSpacing: CGFloat = 30
        static let titleTopSpacing: CGFloat = 100
        static let addNewBtnTrailingSpacing: CGFloat = -30
        static let addNewBtnHeight: CGFloat = 44
        static let addNewBtnWidth: CGFloat = 100
        static let tableTopSpacing: CGFloat = 20
    }
    
    private lazy var titleLable: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = Constants.titleStr
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: Constants.titleFontSize)
        titleLabel.textColor = Constants.titleColor
        return titleLabel
    }()
    
    private lazy var addNewButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = Constants.backgroundColor
        btn.layer.cornerRadius = Constants.addNewBtnCornerRadius
        btn.setTitle(Constants.addNewStr, for: .normal)
        btn.titleLabel?.textColor = Constants.btnTextColor
        return btn
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.backgroundColor = Constants.backgroundColor
        tableView.delegate = self
        tableView.rowHeight = Constants.tableRowHeight
        tableView.register(CardCell.self, forCellReuseIdentifier: Constants.cellId)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.backgroundColor
        setupView()
        animateAtLaunch()
    }
    
    // MARK - ADD Subview and Constraints
    private func setupView() {
        view.addSubview(tableView)
        view.addSubview(titleLable)
        view.addSubview(addNewButton)
        
        NSLayoutConstraint.activate([
            titleLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.titleLeadingSpacing),
            titleLable.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.titleTopSpacing),
        ])
        
        NSLayoutConstraint.activate([
            addNewButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.addNewBtnTrailingSpacing),
            addNewButton.centerYAnchor.constraint(equalTo: titleLable.centerYAnchor),
            addNewButton.heightAnchor.constraint(equalToConstant: Constants.addNewBtnHeight),
            addNewButton.widthAnchor.constraint(equalToConstant: Constants.addNewBtnWidth),
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: addNewButton.bottomAnchor, constant: Constants.tableTopSpacing),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Table Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath) as! CardCell
        
        // to simulate dynamic actions, max upto 3
        if indexPath.row % 2 == 0 {
            cell.addActions(["Pay Now","View Details", "Pay Later"])
        } else {
            cell.addActions(["Pay Now","View Details"])
        }
        
        cell.backgroundColor = Constants.backgroundColor
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let cell = tableView.cellForRow(at: indexPath) as! CardCell
        cell.animateCardToCenterIfNeeded()
    }
    
    func didSelectActionAtIndex(_ actionIndex: Int, cellIndexPath: IndexPath) {
        let alertCntrl = UIAlertController(title: "Alert", message: "Selected Option at Index :\(actionIndex)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertCntrl.addAction(okAction)
        self.present(alertCntrl, animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let tableView = scrollView as? UITableView {
            if let visibleCells = tableView.visibleCells as? [CardCell] {
                for cell in visibleCells {
                    cell.animateCardToCenterIfNeeded()
                }
            }
        }
    }
    
    // MARK: - Private Methods
    private func animateAtLaunch() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            let visibleCells = self.tableView.visibleCells
            if visibleCells.count > 0 {
                let cell = self.tableView.visibleCells[0] as! CardCell
                cell.showLaunchAnimation()
            }
        }
    }
}
