//
//  ViewController.swift
//  faceidProject
//
//  Created by Ruben Ramirez on 1/13/20.
//  Copyright © 2020 Ruben Ramirez. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet weak var btnBiometric: UIButton!
    let context = LAContext()
    var strAlert = String()
    var error:NSError?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            switch context.biometryType {
                case .faceID:
                    btnBiometric.setImage(UIImage(named: "faceid.png"), for: UIControl.State.normal)
                    self.strAlert = "Identificarse con FaceID"
                    break
                case .touchID:
                    btnBiometric.setImage(UIImage(named: "touchid.png"), for: UIControl.State.normal)
                    self.strAlert = "Identificarse con TouchID"
                    break
                case .none:
                    print("No Biometric")
                    break
            }
        }else{
            if let err = error{
                let stralert = self.errorMessage(errorCode: err._code)
                self.notifyUser("Error", err: stralert)
            }
        }
    }
    
    func notifyUser(_ msg:String, err:String?){
        let alert = UIAlertController(title: msg, message: err, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func errorMessage(errorCode:Int) -> String{
        var strMessage = ""
        switch errorCode {
        case LAError.authenticationFailed.rawValue:
            strMessage = "Falló la autentificación"
            break
        case LAError.userCancel.rawValue:
            strMessage = "El usuario cancelo la identificación"
            break
        case LAError.userFallback.rawValue:
            strMessage = "Fallo en la aplicación"
            break
        case LAError.systemCancel.rawValue:
            strMessage = "El sistema cerro la identificación"
            break
        case LAError.passcodeNotSet.rawValue:
            strMessage = "No se completo la identificación"
            break
        case LAError.biometryNotAvailable.rawValue:
            strMessage = "Sensor biometrico no disponible"
            break
        case LAError.appCancel.rawValue:
            strMessage = "La aplicación cerro la identificación"
            break
        case LAError.invalidContext.rawValue:
            strMessage = "Contexto invalido"
            break
        default:
            strMessage = "Error no conocido"
            break
        }
        
        return strMessage
    }
    
    func goTOoNext(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controlador = storyBoard.instantiateViewController(identifier: "start")
        self.present(controlador, animated: true, completion: nil)
    }

    @IBAction func loginUser(_ sender: Any) {
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error){
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: self.strAlert, reply: { [unowned self] (success, error) -> Void in
                DispatchQueue.main.async {
                    if(success){
                        self.goTOoNext()
                    }else{
                        if let err = error{
                            let strMessage = self.errorMessage(errorCode: err._code)
                            self.notifyUser("Error", err: strMessage)
                        }
                    }
                }
            })
        }else{
            if let err = error {
                let strMessage = self.errorMessage(errorCode: err.code)
                self.notifyUser("Error", err: strMessage)
            }
        }
    }
}

