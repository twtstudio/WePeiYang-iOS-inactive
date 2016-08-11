//
//  BicycleServiceInfoController.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/7.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation
import JBChartView

class BicycleServiceInfoController: UIViewController, UITableViewDelegate, UITableViewDataSource, JBLineChartViewDelegate, JBLineChartViewDataSource {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.frame.size.width = (UIApplication.sharedApplication().keyWindow?.frame.size.width)!
        
        self.tableView.bounces = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置delegate, dataSource
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        if BicycleUser.sharedInstance.status == 1 {
            BicycleUser.sharedInstance.getUserInfo({
                self.updateUI()
            })
        } else {
            infoLabel.text = "未绑定自行车卡信息"
        }
    }
    
    func updateUI() {
        
        //UI
        //chartViewBackground
        let background = UIImage(named: "BicyleChartBackgroundImage")
        let backgroundView = UIView(frame: CGRect(x: 8, y: 116, width: (UIApplication.sharedApplication().keyWindow?.frame.size.width)!-16, height: 220))
        backgroundView.layer.cornerRadius = 8.0
        backgroundView.backgroundColor = UIColor(patternImage: background!)
        self.view.addSubview(backgroundView)
        
        //chartView
        let chartView = JBLineChartView(frame: self.calculateChartViewFrame())
        chartView.delegate = self
        chartView.dataSource = self
        chartView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(chartView)
        chartView.reloadData()
        
        let lastHour = BicycleUser.sharedInstance.recent![BicycleUser.sharedInstance.recent!.count-1][0]
        let lastDuration = BicycleUser.sharedInstance.recent![BicycleUser.sharedInstance.recent!.count-1][1]
        self.infoLabel.text = "\(lastHour):00  骑行时间：\(lastDuration)s"
        
        //tableView
        tableView.reloadData()
    }
    
    func calculateChartViewFrame() -> CGRect {
        let x = CGFloat(24)
        let y = CGFloat(132)
        let width = CGFloat((UIApplication.sharedApplication().keyWindow?.frame.size.width)!-48)
        let height = CGFloat(188)
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //dataScoure of chartView
    func numberOfLinesInLineChartView(lineChartView: JBLineChartView!) -> UInt {
        return 1
    }
    
    func lineChartView(lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        log.any(BicycleUser.sharedInstance.recent!.count)
        return UInt(BicycleUser.sharedInstance.recent!.count)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        
        //let res = data[Int(horizontalIndex)]["dist"] as! CGFloat
        let res = BicycleUser.sharedInstance.recent![Int(horizontalIndex)][1] as CGFloat
        return res
    }
    
    func lineChartView(lineChartView: JBLineChartView!, showsDotsForLineAtLineIndex lineIndex: UInt) -> Bool {
        return true
    }
    
    func lineChartView(lineChartView: JBLineChartView!, colorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        return UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, colorForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> UIColor! {
        return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, dotRadiusForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        return 4.0
    }
    
    func lineChartView(lineChartView: JBLineChartView!, widthForLineAtLineIndex lineIndex: UInt) -> CGFloat {
        return 2.0
    }
    
    func lineChartView(lineChartView: JBLineChartView!, lineStyleForLineAtLineIndex lineIndex: UInt) -> JBLineChartViewLineStyle {
        return JBLineChartViewLineStyle.Dashed
    }
    
    //delegate of chartView
    func lineChartView(lineChartView: JBLineChartView!, didSelectLineAtIndex lineIndex: UInt, horizontalIndex: UInt) {
        self.infoLabel.text = "\(BicycleUser.sharedInstance.recent![Int(horizontalIndex)][0]):00  骑行时间：\(BicycleUser.sharedInstance.recent![Int(horizontalIndex)][1])s"
    }
    
    //dataSource of tableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCellWithIdentifier("identifier")
        if cell == nil {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: "identifier")
        }
        
        if indexPath.section == 0 {
            //未完成
            cell!.textLabel?.text = "用户："
            if let name = BicycleUser.sharedInstance.name {
                cell!.textLabel?.text = "用户：\(name)"
            }
            cell!.selectionStyle = .None
        } else if indexPath.section == 1 {
            cell!.textLabel?.text = "余额："
            if let balance = BicycleUser.sharedInstance.balance {
                cell!.textLabel?.text = "余额：\(balance)"
            }
            cell!.selectionStyle = .None
        } else if indexPath.section == 2 {
            cell!.textLabel?.text = "查询记录"
        } else if indexPath.section == 3 {
            cell?.textLabel?.text = "最近记录："
            if let foo = BicycleUser.sharedInstance.record {
                var timeStampString = foo.objectForKey("arr_time") as! String
                print(timeStampString)
                //借了车，没还车
                if Int(timeStampString) == 0 {
                    cell?.textLabel?.text = "最近记录：借车"
                    timeStampString = foo.objectForKey("dev_time") as! String
                    cell?.detailTextLabel?.text = "时间：\(timeStampTransfer.stringFromTimeStampWithFormat("yyyy-MM-dd hh:mm", timeStampString: timeStampString))"
                } else {
                    cell?.textLabel?.text = "最近记录：还车"
                    cell?.detailTextLabel?.text = "时间：\(timeStampTransfer.stringFromTimeStampWithFormat("yyyy-MM-dd hh:mm", timeStampString: timeStampString))"
                }
            }
        }
        
        return cell!
    }
    
    
    //delegate of tableView
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 2 {
            MsgDisplay.showErrorMsg("暂时没有这个功能哦")
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
}
