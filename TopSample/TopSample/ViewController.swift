//
//  ViewController.swift
//  TopSample
//
//  Created by wada on 2017/03/02.
//  Copyright © 2017年 mediba inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var stepsButton: UIButton!
    
    var steps: Int?
    let manager = HKManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Do any additional setup after loading the view, typically from a nib.
        
        let status = manager.permissionStatus()
        if status == .permitted {
            self.showTodaySteps()
        }
        else {
            let message = status.description()
            var actions = Array<UIAlertAction>()
            if status == .notDetermined {
                manager.requestPermission(completion: {(success, error) in
                    if success == true {
                        self.showTodaySteps()
                    }
                })
            }
            else {
                if status == .needUserPermission {
                    let actionConfig = UIAlertAction(title: "設定", style: .default, handler: {action in
                        self.manager.openHealthKitPrivacy()
                    })
                    actions.append(actionConfig)
                }
                let action = UIAlertAction(title: "OK", style: .default, handler: {action in
                })
                actions.append(action)
                
                let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                for action in actions {
                    alert.addAction(action)
                }
                self.present(alert, animated: true, completion: nil)
            }
        }


    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! ContentViewController
        viewController.steps = self.steps
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func showTodaySteps() {
        let now = Date()
        self.output(atDate: now)
        self.manager.outputSteps(now, completion: {steps, error in
            NSLog("steps:" + "\(Int(steps))")
            
            DispatchQueue.main.async {
                self.steps = Int(steps)
                let title = "今日の歩数：" + String(self.steps!)
                self.stepsButton.setTitle(title, for: .normal)
            }
        })
    }
    
    private func output(atDate date: Date) -> Void {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        NSLog("date:" + formatter.string(from: date))
    }
}

