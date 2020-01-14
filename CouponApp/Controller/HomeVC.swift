//
//  HomeVC.swift
//  CouponApp
//
//  Created by Ashmika Gujarathi on 05/12/19.
//  Copyright © 2019 Ashmika. All rights reserved.
//

import UIKit
import Floaty

class HomeVC: UIViewController , FloatyDelegate , UITableViewDelegate, UITableViewDataSource
{
    
    var barButton:CustomBarButton!
    
    let userdefaults = UserDefaults.standard
    
    var newUser = Bool()
    var isDotRead = Bool()
    var viewModel = FirebaseViewModel()
    
    var couponModel = CouponModel()
    
    var couponDataList = [Coupon]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Coupons"
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 4/225.0, green: 220/225.0, blue: 175/225.0, alpha: 1)
        
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.isNavigationBarHidden = false
        
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        layoutFB()
        getCouponList()
        newUser = UserDefaults.standard.value(forKey: "isNewUser") as! Bool
        
        print(newUser)
        
        
       
        
        if newUser == true
        {
            self.userdefaults.set(true, forKey: "isDotRead")
            
            isDotRead = UserDefaults.standard.value(forKey: "isDotRead") as! Bool
            
            showCustomBarButton()
            self.userdefaults.set(false, forKey: "isNewUser")
            
            let alertController = UIAlertController(title: "Congratulation!", message: "You get 50 redeem points for check-in", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        
        }
        else
        {
            self.userdefaults.set(false, forKey: "isDotRead")
            isDotRead = UserDefaults.standard.value(forKey: "isDotRead") as! Bool
             showCustomBarButton()
        }
    }
    
    func layoutFB()
    {
        
        var fab = Floaty()
        fab.buttonColor = UIColor(red: 4/225.0, green: 220/225.0, blue: 175/225.0, alpha: 1)
        fab.plusColor = UIColor.white
        
        let item = FloatyItem()
        item.hasShadow = false
        item.buttonColor = UIColor.clear
        fab.addItem(item: item)
        
        fab.hasShadow = false
        fab.sticky = true
        fab.overlayColor = UIColor.clear
        
        //fab.paddingX = self.view.frame.width/2 - fab.frame.width/2
        
        fab.fabDelegate = self
        
        
        
        self.tableView.addSubview(fab)
        
      
        
    }
    
    
    
    func getCouponList()
    {
        couponModel.getCouponList(completion: { (couponData) in
            print(couponData.count)
            self.couponDataList = couponData
            print(self.couponDataList.count)
            self.tableView.reloadData()
        }) { (error) in
            print(error)
        }
    }
    
    func showCustomBarButton()
    {
        
        
        // Initialisation
        var button = UIButton()
        
        button       = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 50)
        button.setImage(UIImage.init(named: "3507746-32.png"), for: .normal)
      
        
        // Bar button
        barButton = CustomBarButton(customView: button)
        button.addTarget(self, action: #selector(toggleStatus(sender:)), for: UIControl.Event.touchUpInside)
        
        
        
        var button2 = UIButton()
        
        button2       = UIButton(type: .custom)
        button2.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        button2.setImage(UIImage.init(named: "logout.png"), for: .normal)
        button2.addTarget(self, action: #selector(logoutTapped(sender:)), for: UIControl.Event.touchUpInside)
        
        let logoutButton = UIBarButtonItem(customView: button2)
        
        
        
        // Flexible space (Optional)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.navigationItem.rightBarButtonItems = [flexibleSpace,logoutButton, barButton]
        
        print(isDotRead)
        
          if isDotRead == true
          {
            barButton.hasUnread = true
          }
          else
          {
            barButton.hasUnread = false
          }

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return couponDataList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeTblCell
        
        
       let Description = String(format: "%@ - %@",  couponDataList[indexPath.section].brandName, couponDataList[indexPath.section].description)
        cell.descriptionTxt.text = Description
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let expireNewdate = dateFormatter.date(from: couponDataList[indexPath.section].expireDate)
        
        print(expireNewdate!)
        
        let NumOfDays: Int = daysBetweenDates(startDate: Date(), endDate: expireNewdate!)
        print("Num of Days: \(NumOfDays)")
       
        var strExpireDate  = String()
        if NumOfDays == 0
        {
            strExpireDate = String(format: "Already Expire")
        }
        else
        {
            strExpireDate = String(format: "Expires in %@ day",String(NumOfDays))
        }
        
        
        
        cell.expireDatelbl.text = strExpireDate
        
        cell.couponCode.text = couponDataList[indexPath.section].couponCode.uppercased()
        
        
        
        return cell
    }

    
    func daysBetweenDates(startDate: Date, endDate: Date) -> Int
    {
        let currentDate = Date()
        let calendar = Calendar.current
        print(endDate,currentDate)
        let component = calendar.dateComponents([.day], from: currentDate, to: endDate)
        return component.day!
        
    }
    
    
    
    @objc func toggleStatus(sender: AnyObject)
    {
        
        self.barButton.hasUnread = false
        
        self.userdefaults.set(false, forKey: "isDotRead")
        
        isDotRead = UserDefaults.standard.value(forKey: "isDotRead") as! Bool
        
        couponModel.getCreditvalue(completion: { (credit, isCredituse) in
            
            print(credit)
            
            if credit == "0"
            {
                let alertController = UIAlertController(title: "Sorry!", message: "You don't have redeem points to generate coupon", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
            else
            {
            let message = String(format: "You have %@ Redeem Points and you can use this point to create Coupon..",credit!)
            
            
            let alertController = UIAlertController(title: "Redeem Points!!!", message: message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            }
            
        }) { (error) in
            print(error)
            
        }
        
        
        
        
    }
    
    
    
    @objc func logoutTapped(sender: AnyObject)
    {
        viewModel.logOutUser(completion: {
            
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            print(Array(UserDefaults.standard.dictionaryRepresentation().keys))
            
           Switcher.updateRootVC()
            
        })
        { (error) in
                print(error)
            
        }
        
        
    }
    
    
    
    func floatyWillOpen(_ floaty: Floaty) {
        print("Floaty Will Open")
        
        couponModel.getCreditvalue(completion: { (credit, isCredituse) in
            
            print(credit)
            if credit == "0"
            {
                let alertController = UIAlertController(title: "Sorry!", message: "You don't have redeem points to generate coupon", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                
                floaty.removeFromSuperview()
                self.layoutFB()
            }
            else
            {
                floaty.removeFromSuperview()
                
                let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "CouponVC") as! CouponVC
                
                self.navigationController?.pushViewController(homeVC, animated: true)
            }
            
        }) { (error) in
            print(error)
            
        }
        
        
        
        

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

class CustomBarButton: UIBarButtonItem
{
    // Unread Mark
    private var unreadMark: CAShapeLayer?
    
    // Keep track of unread status
    var hasUnread: Bool = false
    {
        didSet
        {
            setUnread(hasUnread: hasUnread)
        }
    }
    
    // Toggles unread status
    private func setUnread(hasUnread: Bool)
    {
        if hasUnread
        {
            unreadMark            = CAShapeLayer();
            unreadMark?.path      = UIBezierPath(ovalIn: CGRect(x: (self.customView?.frame.width ?? 0)-15, y: 5, width: 5, height: 5)).cgPath;
            unreadMark?.fillColor = UIColor.red.cgColor
            self.customView?.layer.addSublayer(unreadMark!)
        }
        else
        {
            unreadMark?.removeFromSuperlayer()
        }
        
    }
}

extension UIView {
    
    
    func addShadow(){
        self.layer.cornerRadius = 20.0
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = 12.0
        self.layer.shadowOpacity = 0.7
        
    }
}
