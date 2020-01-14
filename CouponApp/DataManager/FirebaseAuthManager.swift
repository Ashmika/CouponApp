//
//  File.swift
//  CouponApp
//
//  Created by Ashmika Gujarathi on 25/11/19.
//  Copyright © 2019 Ashmika. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth


class FirebaseAuthManager
{
    
    init()
    {
        
    }
    
    func sign(email: String?, password: String?, completion: @escaping((_ authResult: AuthDataResult?, _ error: Error?) -> Void))
    {
        Auth.auth().signIn(withEmail: email ?? "", password: password ?? "") { (user, error) in
            completion(user, error)
        }
    }
    
    func signOut(completion: @escaping(() -> Void), failure: @escaping((_ error: String) -> Void)){
        do {
            try Auth.auth().signOut()
            completion()
        } catch {
            failure(error.localizedDescription)
        }
    }
    
    func register(email: String?, password: String?, completion: @escaping((_ authResult: AuthDataResult?, _ error: Error?) -> Void)){
        print(email!,password!)
        Auth.auth().createUser(withEmail:email!, password: password!) { (authResult, error) in
            completion(authResult, error)
        }
    }
    
    func getCurrentUser() -> String
    {
        return Auth.auth().currentUser?.email ?? ""
    }
    
   
    
}

