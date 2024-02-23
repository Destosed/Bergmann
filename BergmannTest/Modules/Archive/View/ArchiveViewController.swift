//
//  ArchiveArchiveViewController.swift
//  BergmannTest
//
//  Created by Nikita L on 23/02/2024.
//

import UIKit

protocol ArchiveViewInput: AnyObject {
    func update(with records: [ConversionRecord])
    func showFilterAlert()
}

final class ArchiveViewController: ViewController {

    // MARK: - Nested Types

    private enum Locals {

        static let cellIdentifier = "ConversionRateCell"
    }

    // MARK: - Public Properties

    var presenter: ArchiveViewOutput?

    // MARK: - Private Properties

    private var displayedRecords: [ConversionRecord] = []

    private let tableView = UITableView()

    // MARK: - Life cycle

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawSelf()
        configureNavigationBar()
        presenter?.viewIsReady()
    }


    // MARK: - Drawing

    private func drawSelf() {
        title = "Archive"

        view.backgroundColor = #colorLiteral(red: 0.1960784197, green: 0.1960784197, blue: 0.1960784197, alpha: 1)

        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Locals.cellIdentifier)
        tableView.allowsSelection = false

        view.addSubview(tableView)

        tableView.autoPinEdgesToSuperviewSafeArea()
    }

    // MARK: - Private Methods

    func configureNavigationBar() {
        let archiveButton = UIBarButtonItem(
            image: .init(systemName: "line.3.horizontal.decrease.circle"),
            style: .plain,
            target: self,
            action: #selector(didTapFilterButton)
        )

        let clearButton = UIBarButtonItem(
            image: .init(systemName: "trash"),
            style: .plain,
            target: self,
            action: #selector(didTapClearButton)
        )
        
        navigationItem.rightBarButtonItems = [clearButton, archiveButton]
    }

    private func configure(cell: UITableViewCell, for model: ConversionRecord) {
        guard
            let fromRate = model.fromRate,
            let toRate = model.toRate,
            let fromAmount = model.fromAmount,
            let toAmount = model.toAmount
        else {
            return
        }
        
        cell.backgroundColor = .clear
        cell.textLabel?.text = "\(fromAmount) \(fromRate) → \(toAmount) \(toRate)"
        cell.textLabel?.textColor = .white
    }

    // MARK: - Actions

    @objc private func didTapFilterButton() {
        presenter?.didTapFilterButton()
    }

    @objc private func didTapClearButton() {
        presenter?.didTapClearButon()
    }
}

// MARK: - ArchiveViewInput

extension ArchiveViewController: ArchiveViewInput {
    
    func update(with records: [ConversionRecord]) {
        displayedRecords = records
        tableView.reloadData()
    }

    func showFilterAlert() {
        let alertController = UIAlertController(title: "Filter", message: nil, preferredStyle: .alert)

        alertController.addAction(
            .init(
                title: "Apply",
                style: .default,
                handler: { _ in
                    guard
                        let fromTextField = alertController.textFields?.first,
                        let toTextField = alertController.textFields?.last
                    else {
                        return
                    }

                    self.presenter?.didApplyFilter(
                        fromRate: fromTextField.text,
                        toRate: toTextField.text
                    )
                }
            )
        )
        
        alertController.addAction(.init(title: "Cancel", style: .cancel))

        alertController.addTextField { $0.placeholder = "From..." }
        alertController.addTextField { $0.placeholder = "To..." }

        present(alertController, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ArchiveViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        displayedRecords.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Locals.cellIdentifier, for: indexPath)
        
        configure(cell: cell, for: displayedRecords[indexPath.row])

        return cell
    }
}
