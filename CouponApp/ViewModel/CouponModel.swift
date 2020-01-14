//
//  CouponModel.swift
//  CouponApp
//
//  Created by Ashmika Gujarathi on 08/12/19.
//  Copyright © 2019 Ashmika. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase


final class CouponModel: NSObject
{
    
    var ref: DatabaseReference!
    var dataToStore = [String: String]()
    
    
    var couponsData = [Coupon]()
    
    
    func generateCoupon(brand_name: String, coupon_code: String, description: String, startDate: String, expireDate: String, discount: String, completion: @escaping(() -> Void), failure: @escaping((_ error: String) -> Void))
    {
    
        dataToStore["brand_name"] = brand_name
        dataToStore["coupon_name"] = coupon_code
        dataToStore["description"] = description
        dataToStore["start_date"] = startDate
        dataToStore["expire_date"] = expireDate
        dataToStore["discount"] = discount
        
        print(expireDate)
        
        ref = Database.database().reference()
        let currentUser = Auth.auth().currentUser
        let userDbRef =  ref.child("users").child(currentUser!.uid)
        userDbRef.child("Coupon").childByAutoId().setValue(dataToStore)
        {
            (error, ref) in
            if error != nil {
                print(error!)
                
            }
            else {
                print("Message saved successfully!")
                completion()
            }
        }
        
        
        
        
    }
    
    
    func updateCreditValue(completion: @escaping(() -> Void), failure: @escaping((_ error: String) -> Void))
    {
        
        ref = Database.database().reference()
        
        let currentUser = Auth.auth().currentUser
        
        let userDbRef =  ref.child("users").child(currentUser!.uid)
        
        getCreditvalue(completion:
        { credit,isCreditUse  in
            
            print(credit, isCreditUse)
    
            var newCredit : Int?
            newCredit = Int(credit!)
            newCredit = newCredit! - 10

            print(newCredit!)


            if (newCredit! <= 0)
            {

                userDbRef.child("credit").setValue("0")
                userDbRef.child("isCreditUse").setValue(false)
                {
                    (error, ref) in
                    if error != nil {
                        print(error!)

                    }
                    else {
                        print("Message saved successfully!")
                        completion()
                    }
                }
            }
            else
            {
                print(String(describing: newCredit))
                userDbRef.child("credit").setValue(String(describing: newCredit!))
                {
                    (error, ref) in
                    if error != nil {
                        print(error!)

                    }
                    else {
                        print("Message saved successfully!")
                        completion()
                    }
                }
            }
        })
            
        { (error) in
            print(error)
            
        }
    
        
        
        
        
       
    }
    
    func getCreditvalue(completion: @escaping((_ credit: String? , _ isCreditUse: String) -> Void), failure: @escaping((_ error: String) -> Void)
        )
    {
        ref = Database.database().reference()
        let currentUser = Auth.auth().currentUser
        print(currentUser!.uid)
        
        let userDbRef =  ref.child("users").child(currentUser!.uid)
        
        var credit : String?
        var isCreditUse = String()
        
        
        userDbRef.observeSingleEvent(of: .value, with: { (dataSnapshot) in
            do {
                let value = dataSnapshot.value as? NSDictionary
                print(value?["credit"])
                credit = value?["credit"] as? String ?? ""
                isCreditUse = value?["isCreditUse"] as? String ?? ""
                
                completion(credit!,isCreditUse)
                
            } catch {
                failure(error.localizedDescription)
            }
        }) { (error) in
            failure(error.localizedDescription)
        }
     
    }
    
    
    func getCouponList(completion: @escaping((_ couponData: [Coupon]) -> Void), failure: @escaping((_ error: String) -> Void))
    {
        ref = Database.database().reference()
        let currentUser = Auth.auth().currentUser
        print(currentUser!.uid)
        
        let userDbRef =  ref.child("users").child(currentUser!.uid).child("Coupon")
        
        userDbRef.observeSingleEvent(of: .value, with: { (dataSnapshot) in
            
                var newItems: [Coupon] = []
                for child in dataSnapshot.children {
                    if let snapshot = child as? DataSnapshot,
                        let coupondata = Coupon(snapshot: snapshot) {
                        newItems.append(coupondata)
                    }
                }
                
                self.couponsData = newItems
            
                print(self.couponsData.count)
            
                completion(self.couponsData)
            
        }) { (error) in
            print(error)
        }
        
        
        
    }
    
    
}
