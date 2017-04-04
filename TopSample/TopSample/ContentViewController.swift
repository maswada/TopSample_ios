//
//  ContentViewController.swift
//  TopSample
//
//  Created by wada on 2017/03/08.
//  Copyright © 2017年 mediba inc. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var adviseView: UITextView!
    @IBOutlet weak var backButton: UIButton!
    var steps: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let steps = self.steps {
            var text: String = steps.description
            let title: String
            
            if steps < 2000 {
                text += "歩って。\n少しは運動しろよ。\n太るぞ"
                title = "余計なお世話"
            }
            else if steps >= 2000, steps < 5000 {
                text += "歩ですか。\nコンビニまで歩いていったくらい？\n一駅早く降りて帰ればいいと思うよ。"
                title = "はい。そうですねー"
            }
            else if steps >= 5000, steps < 10000 {
                text += "歩ねぇ。\nやるじゃん。その調子"
                title = "あんたに言われたくないよ"
            }
            else {
                text += "歩！\n\n\nあんた、暇なの？"
                title = "うるさい"
            }
            self.adviseView.text = text
            self.backButton.setTitle(title, for: .normal)
    }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
