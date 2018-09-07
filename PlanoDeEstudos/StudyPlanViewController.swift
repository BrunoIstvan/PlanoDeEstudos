//
//  StudyViewController.swift
//  PlanoDeEstudos
//
//  Created by Eric Brito
//  Copyright © 2017 Eric Brito. All rights reserved.

import UIKit
import UserNotifications

class StudyPlanViewController: UIViewController {

    @IBOutlet weak var tfCourse: UITextField!
    @IBOutlet weak var tfSection: UITextField!
    @IBOutlet weak var dpDate: UIDatePicker!
    
    var studyPlan: StudyPlan?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dpDate.minimumDate = Date()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        super.viewWillAppear(animated)
        
        if studyPlan == nil {
            
            // studyPlan = StudyPlan()
            
        }
        
    }

    @IBAction func schedule(_ sender: UIButton) {
        
        let id = "\(Date().timeIntervalSince1970)"
        
        var studyPlan = StudyPlan(course: tfCourse.text!, section: tfSection.text!, date: dpDate.date, done: false, id: id)
        
        // prepara uma notificação
        let content = UNMutableNotificationContent()
        content.title = "Lembrete"
        content.subtitle = "Matéria: \(studyPlan.course)"
        content.body = "Está na hora de estudar \(studyPlan.section)"
        // content.sound = "meusom.caf"
        content.badge = 1
        
        content.categoryIdentifier = "Lembrete"
        
        
        // prepara em quanto tempo irá disparar
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        
        let dateComponent = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: dpDate.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        
        // preparar uma requisição ...
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        // adiciona a requisição na central de notificação do celular
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        StudyManager.shared.addPlan(studyPlan)
        navigationController?.popViewController(animated: true)
        
    }
    
}
