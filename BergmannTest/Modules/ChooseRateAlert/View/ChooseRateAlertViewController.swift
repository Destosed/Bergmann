//
//  ChooseRateAlertChooseRateAlertViewController.swift
//  BergmannTest
//
//  Created by Nikita L on 22/02/2024.
//

import UIKit
import PureLayout

protocol ChooseRateAlertViewInput: AnyObject {
    func configure(rates: [String], selectedRate: String)
}

final class ChooseRateAlertViewController: ViewController {


    // MARK: - Properties

    var presenter: ChooseRateAlertViewOutput?

    // MARK: - Private Properties

    private var rates: [String] = []

    private let pickerView = UIPickerView()


    // MARK: - Life cycle

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawSelf()
        presenter?.viewIsReady()
    }


    // MARK: - Drawing

    private func drawSelf() {
        view.backgroundColor = .gray.withAlphaComponent(0.5)

        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 20

        pickerView.delegate = self
        pickerView.dataSource = self
        
        let buttonsStackView = UIStackView()
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 0
        buttonsStackView.distribution = .fillEqually
        
        let cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.addTarget(self, action: #selector(onCancelButtonDidTapped), for: .touchUpInside)

        let confirmButton = UIButton()
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.setTitleColor(.black, for: .normal)
        confirmButton.addTarget(self, action: #selector(onConfirmButtonDidTapped), for: .touchUpInside)

        view.addSubview(container)
        container.addSubview(pickerView)
        container.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(confirmButton)

        container.autoCenterInSuperview()
        
        pickerView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)

        buttonsStackView.autoPinEdge(.top, to: .bottom, of: pickerView)
        buttonsStackView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
    }

    // MARK: - Actions

    @objc private func onCancelButtonDidTapped() {
        presenter?.onCancelButtonDidTapped()
    }

    @objc private func onConfirmButtonDidTapped() {
        presenter?.onConfirmButtonDidTapped()
    }
}


// MARK: - ChooseRateAlertViewInput

extension ChooseRateAlertViewController: ChooseRateAlertViewInput {
    
    func configure(rates: [String], selectedRate: String) {
        self.rates = rates

        pickerView.reloadAllComponents()
        pickerView.selectRow(
            rates.firstIndex(where: { $0 == selectedRate }) ?? 0,
            inComponent: 0,
            animated: false
        )
    }
}

// MARK: - UIPickerViewDelegate

extension ChooseRateAlertViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.presenter?.didSelect(rate: rates[row])
    }
}

// MARK: - UIPickerViewDataSource

extension ChooseRateAlertViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        rates.count
    }

    func pickerView(_ pickerView: UIPickerView, 
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return rates[row]
    }
}
