//
//  Validation.swift
//  CouponApp
//
//  Created by Ashmika Gujarathi on 05/12/19.
//  Copyright © 2019 Ashmika. All rights reserved.
//

import Foundation
import Firebase

enum Alert {        //for failure and success results
    case success
    case failure
    case error
}

enum Valid {
    case success
    case failure(Alert, AlertMessages)
}

enum ValidationType {
    case email
    case password
    case rePassword
    
    case brandName
    case couponNaame
    case description
    case expireDate
    case discount
}

enum RegEx: String
{
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" // Email
    case password = "^.{8,20}$" // Password length 6-15
}

enum AlertMessages: String
{
    case inValidEmail = "Invalid Email"
    case inValidPSW = "Invalid Password / Password too short"
    case passwordNotMatch = "ReType Password Dose not match with password"
    case emptyEmail = "Empty Email"
    case emptyPSW = "Empty Password"
    case emptyRepwd = "Empty Re-Password"
    
    case emptyBrandNew = "Empty Brand Name"
    case emptyCouponcode = "Empty Coupon Code"
    case emptyDescription = "Empty Description"
    case emptyExpiredate = "Empty Expiredate"
    case emptydiscount = "Empty Discount"
    
    
    func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

class Validation: NSObject {
    
    public static let shared = Validation()
    
    func validate(values: (type: ValidationType, inputValue: String, inputValue2: String)...) -> Valid {
        for valueToBeChecked in values {
            switch valueToBeChecked.type
            {
            case .email:
                if let tempValue = isValidString((valueToBeChecked.inputValue, valueToBeChecked.inputValue ,.email, .emptyEmail, .inValidEmail)) {
                    return tempValue
                }
            
            case .password:
                if let tempValue = isValidString((valueToBeChecked.inputValue, valueToBeChecked.inputValue ,.password, .emptyPSW, .inValidPSW)) {
                    return tempValue
                }
                
            case .rePassword:
                if let tempValue = isValidString((valueToBeChecked.inputValue, valueToBeChecked.inputValue2 ,.password, .emptyRepwd, .passwordNotMatch)){
                    return tempValue
                }
            case .brandName:
                if let tempValue = isEmptyString((valueToBeChecked.inputValue,.emptyBrandNew)){
                    return tempValue
                }
            case .couponNaame:
                if let tempValue = isEmptyString((valueToBeChecked.inputValue,.emptyCouponcode)){
                    return tempValue
                }
            case .description:
                if let tempValue = isEmptyString((valueToBeChecked.inputValue,.emptyDescription)){
                    return tempValue
                }
            case .expireDate:
                if let tempValue = isEmptyString((valueToBeChecked.inputValue,.emptyExpiredate)){
                    return tempValue
                }
            case .discount:
                if let tempValue = isEmptyString((valueToBeChecked.inputValue,.emptydiscount)){
                    return tempValue
                }
            }
        }
        return .success
    }
    
    func isValidString(_ input: (text: String, text2:String, regex: RegEx, emptyAlert: AlertMessages, invalidAlert: AlertMessages)) -> Valid? {
        if input.text.isEmpty {
            return .failure(.error, input.emptyAlert)
        } else if isValidRegEx(input.text, input.regex) != true {
            return .failure(.error, input.invalidAlert)
        }
        else if input.text != input.text2 {
            print(input.invalidAlert)
            return .failure(.error, input.invalidAlert)
        }
        
        return nil
    }
    
    func isEmptyString(_ input: (text: String, emptyAlert: AlertMessages)) -> Valid? {
        if input.text.isEmpty {
            return .failure(.error, input.emptyAlert)
        }
        
        return nil
    }
    
    
    func isValidRegEx(_ testStr: String, _ regex: RegEx) -> Bool {
        let stringTest = NSPredicate(format:"SELF MATCHES %@", regex.rawValue)
        let result = stringTest.evaluate(with: testStr)
        return result
    }
    
    
    
}


class Switcher
{
    
    static func updateRootVC(){
        
        
        var rootVC : UIViewController?
        
        if Auth.auth().currentUser != nil
        {
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        }
        else
        {
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let navigationController = UINavigationController.init(rootViewController: rootVC!)
        appDelegate.window?.rootViewController = navigationController
        appDelegate.window?.makeKeyAndVisible()
        
    }
    
}
