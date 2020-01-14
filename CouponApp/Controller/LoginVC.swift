//
//  LoginVC.swift
//  CouponApp
//
//  Created by Ashmika Gujarathi on 04/12/19.
//  Copyright © 2019 Ashmika. All rights reserved.
//

import UIKit
import Firebase
class LoginVC: UIViewController {

    
    @IBOutlet weak var emailtxt: UITextField!
    
    
    @IBOutlet weak var passwordTxt: UITextField!
    
    var viewModel = FirebaseViewModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
        
    }
    
    @IBAction func btnLoginTapped(_ sender: UIButton)
    {
        
        let email = emailtxt.text!
        let password = passwordTxt.text!
        
        if email.isEmpty || password.isEmpty
          {
            let alertController = UIAlertController(title: "Alert", message: "Please Enter value", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
          }
        else
          {
            viewModel.signUpUser(email: emailtxt.text!, password: passwordTxt.text!, completion:
                {
                    
                    print("success")
                    let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    
                    self.navigationController?.pushViewController(homeVC, animated: true)
               
                    
                    
            }) { (error) in
                print(error)
                let alertController = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func btnSignupTapped(_ sender: UIButton)
    {
        let signupVC = storyboard?.instantiateViewController(withIdentifier: "SignupVC") as! SignUpVC
        
        self.navigationController?.pushViewController(signupVC, animated: true)
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
