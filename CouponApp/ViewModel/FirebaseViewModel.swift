//
//  FirebaseViewModel.swift
//  CouponApp
//
//  Created by Ashmika Gujarathi on 23/11/19.
//  Copyright © 2019 Ashmika. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseDatabase




final class FirebaseViewModel
{
   let firebaseAuthManager: FirebaseAuthManager = FirebaseAuthManager()
    
   var user = User()
    

   func registerUser(email: String?, password: String?, completion: @escaping(() -> Void), failure: @escaping((_ error: String) -> Void))
   {
    
    
        firebaseAuthManager.register(email: email!, password: password!) { (authResult, error) in
            if let authResult = authResult, let emailString = authResult.user.email
            {
                completion()
                print("Email" ,authResult.user.email!)
                
                guard let newUserStatus = authResult.additionalUserInfo?.isNewUser else {return}
                //test the value in the debugger
                print("\nIs new user? \(newUserStatus)\n")
                
                let userDefaults = UserDefaults.standard
                userDefaults.set(authResult.user.email, forKey: "Email")
                userDefaults.set(authResult.user.uid, forKey: "UId")
                userDefaults.set(authResult.additionalUserInfo?.isNewUser, forKey: "isNewUser")
                
                userDefaults.synchronize()
                
                print(UserDefaults.standard.value(forKey: "isNewUser"))
                
                if newUserStatus == true
                {
                    //provide your alert prompt
                    print("new user")
                    
                    let credit = "50"
                    let isCreditUse = false
                    
                    let userData = ["credit": credit, "isCreditUse": isCreditUse] as [String : Any]
                    let ref = Database.database().reference()
                    
                    ref.child("users").child(authResult.user.uid).setValue(userData)
                    
                }
                else
                {
                    //transition view to continue to the app
                    print("not new user")
                }
                
            }
            else
            {
                if let error: Error = error{
                    failure(error.localizedDescription)
             }
            }
        }
    }
    
    func signUpUser(email: String?, password: String?, completion: @escaping(() -> Void), failure: @escaping((_ error: String) -> Void))
    {
        
        self.user.email = email
        self.user.password = password
        
        firebaseAuthManager.sign(email: email!, password: password!) { (authResult, error) in
            if let authResult = authResult, let emailString = authResult.user.email
            {
                
                completion()
                print("Email" ,authResult.user.email!)
                
                let userDefaults = UserDefaults.standard
                
                userDefaults.set(authResult.additionalUserInfo?.isNewUser, forKey: "isNewUser")
                
                userDefaults.synchronize()
                
               
                
            }
            else
            {
                if let error: Error = error{
                    failure(error.localizedDescription)
                }
            }
        }
    }
    
    
    
    func logOutUser(completion: @escaping(() -> Void), failure: @escaping((_ error: String) -> Void))
    {
        firebaseAuthManager.signOut(completion: {
            completion()
        }) { (error) in
            
        }
    }
   
    func getCurrentUser() -> String
    {
        var currentUser = firebaseAuthManager.getCurrentUser()
        if let indexSender = (currentUser.range(of: "@")?.lowerBound){
            currentUser = String(currentUser.prefix(upTo: indexSender))
        }
        return currentUser
    }

    
    
}

