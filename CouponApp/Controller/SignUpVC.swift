//
//  SignUpVC.swift
//  CouponApp
//
//  Created by Ashmika Gujarathi on 23/11/19.
//  Copyright © 2019 Ashmika. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController , UITextFieldDelegate
{
    
    
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet weak var rePassTxt: UITextField!
    
    var viewModel = FirebaseViewModel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        emailTxt.delegate = self
        passwordTxt.delegate = self
        rePassTxt.delegate = self
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {

        emailTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
        rePassTxt.resignFirstResponder()
        return true
        
    }

    @IBAction func btnSignupTapped(_ sender: Any)
    {
        
        let email = emailTxt.text!
        let password = passwordTxt.text!
        let rePassword = rePassTxt.text!
        
        
        let response = Validation.shared.validate(values: (ValidationType.email, email, email), (ValidationType.password, password, password), (ValidationType.rePassword, rePassword, password))
        switch response
        {
            case .success:
                viewModel.registerUser(email: email, password: password, completion:
                {
                    let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    
                    self.navigationController?.pushViewController(homeVC, animated: true)
                    
                }) {
                    (error) in
                    print("error")
                }
            
            

            case .failure(_, let message):
                print(message.localized())
                let alertController = UIAlertController(title: "Alert", message: message.localized(), preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
        }
        
       
    }
    
    
    @IBAction func btnBacktoLoginTapped(_ sender: Any)
    {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    
    /*
     
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
