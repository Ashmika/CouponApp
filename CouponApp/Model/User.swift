//
//  User.swift
//  CouponApp
//
//  Created by Ashmika Gujarathi on 25/11/19.
//  Copyright © 2019 Ashmika. All rights reserved.
//

import Foundation
import FirebaseDatabase


struct User
{
    var password : String?
    var email : String?
}

struct Coupon
{
    let brandName: String
    let couponCode: String
    let description: String
    let startDate: String
    let expireDate: String
    let discount: String
    
    // Standard init
    init(brandName: String, couponCode: String, description: String, startDate: String, expiredate:String, discount: String)
    {
        self.brandName = brandName
        self.couponCode = couponCode
        self.description = description
        self.startDate = startDate
        self.expireDate = expiredate
        self.discount = discount
        
        
    }
    
    // Init for reading from Database snapshot
    init?(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        brandName = snapshotValue["brand_name"] as! String
        couponCode = snapshotValue["coupon_name"] as! String
        description = snapshotValue["description"] as! String
         startDate = snapshotValue["start_date"] as! String
         expireDate = snapshotValue["expire_date"] as! String
        
        discount = snapshotValue["discount"] as! String
        
        
    }
    
}

