//
//  DetailViewController.swift
//  ToDowithData
//
//  Created by Jason Yang on 1/9/24.
//

import SwiftUI
import UIKit

class DetailViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var btnUpdate: UIButton!
    
    //MARK: - Properties
        var Detailtodo: RemoteTodo? {
            didSet {
                // Update the view.
                self.configureView()
            }
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    private func configureView() {
        if let detail = self.Detailtodo {
            if let label = self.lblDetail {
                label.text = detail.title
            }
        }
    }
    
    @IBAction func btnUpdatedTapped(_ sender: UIButton) {
//        let alertController = UIAlertController(title: "수정", message: "수정할 내용을 아래에 입력하세요.", preferredStyle: .alert)
//        alertController.addTextField { textField in textField.placeholder = "할 일을 입력하세요."}
//        
//        let saveAction = UIAlertAction(title: "저장", style: .default) {
//         [weak self] _ in
//            guard let textField = alertController.textFields?.first else { return }
//            guard let newLabel = textField.text else { return }
//        }
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
