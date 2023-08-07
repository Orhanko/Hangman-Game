//
//  ViewController.swift
//  Hangman Game
//
//  Created by Orhan Pojskic on 24.07.2023..

import UIKit

class ViewController: UIViewController {
    var window: UIWindow?
    var textPoljeUpitnici: UILabel!
    var rezultat: UILabel!
    var rezultatPrviDio = 0
    var rezultatDrugiDio: Int!
    var unosSlova: UITextField!
    var nizRijeci = [String]()
    var rijecZaPogoditi: String!
    var rijecZaPogoditiUpitnik = ""
    var resetDugme = UIButton(type: .system)
    var unesenaSlova = Set<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Hangman Game"
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else {
                return
            }
            self.nizRijeci = self.ucitajRijeciUNiz()
        }
        navigationController?.navigationBar.prefersLargeTitles = true
        unosSlovaSetUp()
        textPoljeUpitniciSetUp()
        rijecZaPogoditi = nizRijeci[0]
        upitniciSetUp()
        rezultatSetUp()
        resetDugmeSetUp()
        constraintsSetUp()
        }

}

extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        unosSlova.resignFirstResponder()
        rjesenje(using: unosSlova.text ?? "")
        unosSlova.text = ""
        return true
    }
    
    func rjesenje(using unos: String){
        var rjesenje = ""
        let stanjePrije = textPoljeUpitnici.text
        rjesenje = ""
        unesenaSlova.insert(unos)
        for slovo in rijecZaPogoditi{
            let slovoo = String(slovo)
            if unesenaSlova.contains(slovoo){
                rjesenje += " \(slovoo) "
            }else{
                rjesenje += " _ "
            }
        }
        if let stanjePrije = stanjePrije{
            if stanjePrije == rjesenje{
                rezultatPrviDio += 1
            }
        }
        textPoljeUpitnici.text? = rjesenje
        outputResult()
        provjeraTacnogRezultata(using: rjesenje)
        provjeraNeuspjelihPokusaja()
    }
    
    func provjeraNeuspjelihPokusaja(){
        if rezultatPrviDio == 7{
            
            let vc = UIAlertController(title: "THE END", message: "Too many attempts!\n \"\(rijecZaPogoditi ?? "")\" was the result", preferredStyle: .alert)
                        vc.addAction(UIAlertAction(title: "OK", style: .default, handler: reset))
                        present(vc, animated: true)
                        outputResult()
        }
    }
    func provjeraTacnogRezultata(using rjesenje: String){
        let replaced = rjesenje.replacingOccurrences(of: " ", with: "")
        
        
        
        if replaced == rijecZaPogoditi{
            let vc = UIAlertController(title: "SUCCESS", message: "You have done it!", preferredStyle: .alert)
            vc.addAction(UIAlertAction(title: "Next word", style: .default, handler: reset))
            present(vc, animated: true)
        }
    }
    
    func resetDugmeSetUp(){
        resetDugme.setTitle("Reset", for: .normal)
        resetDugme.translatesAutoresizingMaskIntoConstraints = false
        resetDugme.layer.borderColor = UIColor.placeholderText.cgColor
        
        resetDugme.addTarget(self, action: #selector(resetKliknuto), for: .touchUpInside)
        view.addSubview(resetDugme)
    }
    
    func unosSlovaSetUp(){
        unosSlova = UITextField()
        unosSlova.placeholder = "Enter the quessing letter..."
        unosSlova.translatesAutoresizingMaskIntoConstraints = false
        unosSlova.borderStyle = UITextField.BorderStyle.roundedRect
        unosSlova.returnKeyType = .done
        unosSlova.delegate = self
        unosSlova.autocapitalizationType = .none
        view.addSubview(unosSlova)
    }
    
    @objc func resetKliknuto(_ sender: UIButton){
        let vc = UIAlertController(title: "RESET", message: "Are you sure you want to reset?", preferredStyle: .alert)
        
        
        vc.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: reset))
        vc.addAction(UIAlertAction(title: "No", style: .default))
        present(vc, animated: true)
    }
    
    func reset(action: UIAlertAction){
        rezultatPrviDio = 0
        nizRijeci.shuffle()
        rijecZaPogoditi = nizRijeci[0]
        unesenaSlova.removeAll()
        outputResult()
        rijecZaPogoditiUpitnik = ""
        upitniciSetUp()
    }
    
    func rezultatSetUp(){
        rezultat = UILabel()
        rezultatDrugiDio = 7
        outputResult()
        rezultat.translatesAutoresizingMaskIntoConstraints = false
        rezultat.textColor =  .placeholderText
        rezultat.font = .boldSystemFont(ofSize: 20)
        view.addSubview(rezultat)
    }
    
    func textPoljeUpitniciSetUp(){
        textPoljeUpitnici = UILabel()
        textPoljeUpitnici.translatesAutoresizingMaskIntoConstraints = false
        textPoljeUpitnici.font = .systemFont(ofSize: 30)
        view.addSubview(textPoljeUpitnici)
    }
    
    
    func upitniciSetUp(){
        for _ in rijecZaPogoditi{
            rijecZaPogoditiUpitnik += " _ "
        }
        textPoljeUpitnici.text = rijecZaPogoditiUpitnik
    }
    
    func constraintsSetUp(){
        NSLayoutConstraint.activate([
            textPoljeUpitnici.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            textPoljeUpitnici.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            unosSlova.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            unosSlova.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            rezultat.topAnchor.constraint(equalTo: textPoljeUpitnici.bottomAnchor, constant: 50),
            rezultat.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            unosSlova.topAnchor.constraint(equalTo: rezultat.bottomAnchor, constant: 50),
            resetDugme.topAnchor.constraint(equalTo: unosSlova.bottomAnchor, constant: 50),
            resetDugme.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = unosSlova.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 1
    }

    @objc func ucitajRijeciUNiz() -> [String]{
            if let rijeciFileURL = Bundle.main.url(forResource: "words", withExtension: "txt"){
                if let rijeciSadrzaj = try? String(contentsOf: rijeciFileURL){
                    nizRijeci = rijeciSadrzaj.components(separatedBy: "\n")
                }
            }
        nizRijeci.remove(at: nizRijeci.count-1)
        nizRijeci.shuffle()
        return nizRijeci
    }
    
    func outputResult(){
        if let rezDrugiDio = rezultatDrugiDio{
                rezultat.text = "Number of attempts: \(rezultatPrviDio)/\(rezDrugiDio)"
        }
    }
}
