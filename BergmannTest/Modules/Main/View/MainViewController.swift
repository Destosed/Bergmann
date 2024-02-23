//
//  MainMainViewController.swift
//  BergmannTest
//
//  Created by Nikita L on 21/02/2024.
//

import UIKit
import PureLayout

protocol MainViewInput: AnyObject {
    func configure(with model: MainViewModel)
}

final class MainViewController: ViewController {


    // MARK: - Properties

    var presenter: MainViewOutput?

    var currencyService = DefaultCurrencyService.shared

    // MARK: - Private Properties

    private let lastUpdateLabel = UILabel()
    private let refreshImageView = UIImageView()

    private let fromRateView = RateView(with: .from)
    private let   toRateView = RateView(with: .to)

    private let swapImageView = UIImageView()
    
    private let fromTextField = UITextField()
    private let   toTextField = UITextField()

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
        title = "Main"

        view.backgroundColor = #colorLiteral(red: 0.1960784197, green: 0.1960784197, blue: 0.1960784197, alpha: 1)

        lastUpdateLabel.textColor = .white
        lastUpdateLabel.text = "Last update: " + RateDateFormatter.shared.string(from: Date())

        refreshImageView.isUserInteractionEnabled = true
        refreshImageView.image = UIImage(named: "refresh")?
            .withRenderingMode(.alwaysOriginal).withTintColor(.white)
        refreshImageView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(didTapRefreshButton))
        )

        let fromStackView = UIStackView()
        fromStackView.axis = .vertical
        fromStackView.spacing = 10

        fromRateView.delegate = self

        fromTextField.textColor = .white
        fromTextField.attributedPlaceholder = NSAttributedString(
            string: "From",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        fromTextField.keyboardType = .numberPad
        fromTextField.borderStyle = .none
        fromTextField.font = .systemFont(ofSize: 30, weight: .bold)
        fromTextField.addBottomBorder()
        fromTextField.delegate = self

        let bar = UIToolbar()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneEditting))
        bar.items = [space, done]
        bar.sizeToFit()
        fromTextField.inputAccessoryView = bar

        swapImageView.isUserInteractionEnabled = true
        swapImageView.image = .init(named: "swap")?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.white)
        swapImageView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(didTapSwapButton))
        )

        let toStackView = UIStackView()
        toStackView.axis = .vertical
        toStackView.spacing = 10

        toTextField.isEnabled = false
        toTextField.textColor = .white
        toTextField.keyboardType = .numberPad
        toTextField.borderStyle = .none
        toTextField.font = .systemFont(ofSize: 30, weight: .bold)
        toTextField.addBottomBorder()
        toTextField.attributedPlaceholder = NSAttributedString(
            string: "To",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )

        toRateView.delegate = self

        let ratesIndicatorStackView = UIStackView()
        ratesIndicatorStackView.axis = .horizontal
        ratesIndicatorStackView.distribution = .fill
        ratesIndicatorStackView.alignment = .center
        ratesIndicatorStackView.spacing = 10

        view.addSubview(ratesIndicatorStackView)
        view.addSubview(lastUpdateLabel)
        view.addSubview(refreshImageView)

        fromStackView.addArrangedSubview(fromRateView)
        fromStackView.addArrangedSubview(fromTextField)

        toStackView.addArrangedSubview(toRateView)
        toStackView.addArrangedSubview(toTextField)

        ratesIndicatorStackView.addArrangedSubview(fromStackView)
        ratesIndicatorStackView.addArrangedSubview(swapImageView)
        ratesIndicatorStackView.addArrangedSubview(toStackView)

        lastUpdateLabel.autoPinEdge(.bottom, to: .top, of: ratesIndicatorStackView, withOffset: -30)
        lastUpdateLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 25)
        lastUpdateLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 25)

        refreshImageView.autoSetDimensions(to: .init(width: 17, height: 17))
        refreshImageView.autoPinEdge(toSuperviewEdge: .right, withInset: 25)
        refreshImageView.autoPinEdge(.top, to: .top, of: lastUpdateLabel, withOffset: 0, relation: .equal)
        refreshImageView.autoPinEdge(.bottom, to: .bottom, of: lastUpdateLabel, withOffset: 0, relation: .equal)
        
        fromRateView.autoSetDimensions(to: .init(width: 150, height: 35))
//        fromRateView.autoSetDimension(.height, toSize: 35)
        fromTextField.autoSetDimension(.height, toSize: 50)

        swapImageView.autoSetDimensions(to: .init(width: 30, height: 30))
        
        toRateView.autoSetDimensions(to: .init(width: 150, height: 35))
//        toRateView.autoSetDimension(.height, toSize: 35)
        toTextField.autoSetDimension(.height, toSize: 50)

        ratesIndicatorStackView.autoPinEdge(toSuperviewEdge: .left, withInset: 25)
        ratesIndicatorStackView.autoPinEdge(toSuperviewEdge: .right, withInset: 25)
        ratesIndicatorStackView.autoAlignAxis(toSuperviewAxis: .horizontal)
    }

    // MARK: - Private Methods

    func configureNavigationBar() {
        let archiveButton = UIBarButtonItem(
            image: .init(systemName: "archivebox.fill"),
            style: .plain,
            target: self,
            action: #selector(didTapArchiveButton)
        )

        navigationItem.rightBarButtonItem = archiveButton
    }

    private func setRefreshAnimation(to isEnabled: Bool) {
        if isEnabled {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = -Double.pi * 2
            rotationAnimation.duration = 1.5
            rotationAnimation.repeatCount = 1
            
            refreshImageView.layer.add(rotationAnimation, forKey: nil)
        } else {
            refreshImageView.layer.removeAllAnimations()
        }
    }
    
    // MARK: - Actions

    @objc private func didTapFromRateView() {
        presenter?.didTapRateView(with: .from)
    }

    @objc private func didTapToRateView() {
        presenter?.didTapRateView(with: .to)
    }

    @objc private func doneEditting() {
        fromTextField.resignFirstResponder()
        presenter?.didEndEditting()
    }

    @objc private func didTapArchiveButton() {
        presenter?.didTapArchiveButton()
    }

    @objc private func didTapRefreshButton() {
        setRefreshAnimation(to: true)

        presenter?.didTapRefresh()
    }

    @objc private func didTapSwapButton() {
        presenter?.didTapSwapButton()
    }
}


// MARK: - MainViewInput

extension MainViewController: MainViewInput {
    
    func configure(with model: MainViewModel) {
        fromRateView.changeRate(to: model.fromRate)
        toRateView.changeRate(to: model.toRate)

        fromTextField.text = model.amount
        toTextField.text = model.convertedAmount
        
        lastUpdateLabel.text = model.lastUpdateText
    }
}

// MARK: - RateViewDelegate

extension MainViewController: RateViewDelegate {
    
    func didTapRateView(with type: RateViewType) {
        presenter?.didTapRateView(with: type)
    }
}

// MARK: - UITextFieldDelegate

extension MainViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, 
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)

        presenter?.textFieldDidUpdate(string: updatedString)
        
        return true
    }
}

extension UITextField {
    func addBottomBorder() {
        borderStyle = .none
        
        let separatorView = UIView()
        separatorView.backgroundColor = .gray
        addSubview(separatorView)

        separatorView.autoMatch(.width, to: .width, of: separatorView)
        separatorView.autoSetDimension(.height, toSize: 1)
        separatorView.autoPinEdge(.left, to: .left, of: self)
        separatorView.autoPinEdge(.right, to: .right, of: self)
        separatorView.autoPinEdge(.top, to: .bottom, of: self)
    }
}
