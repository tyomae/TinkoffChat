//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 13/02/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        print(#function)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

         print(#function)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        print(#function)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        print(#function)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

         print(#function)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

         print(#function)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

         print(#function)
    }
}

