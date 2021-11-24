//
//  ViewController.swift
//  NetworkingTemplate
//
//  Created by Артур Дохно on 24.11.2021.
//

import UIKit
import PromiseKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet var myLable: UILabel!
    @IBOutlet var textField: UITextField!
    
    
    private lazy var session: Session = {
        return Connectionsettings.sessionManager()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        
        handleButtonPressed()
        
    }
    
    func handleButtonPressed() {
        
        guard let numberString = textField.text,
              let number = Int(numberString) else {
                  return
              }
        let apiRouterStructure = APIRouterStructer(apiRouter: .todos(number: number))
        let todosPromise: Promise<Todo> = session.request(apiRouterStructure)
        
        firstly {
            todosPromise
        }
        .then { [weak self] todo -> Promise<Todo> in
            guard let self = self else { throw InternalError.unexpected }
            self.myLable.text = "\(todo.id). " + todo.title
            return Promise<Todo>.value(todo)
        }
        .then { [weak self] todo -> Promise<Todo> in
            guard let self = self else { throw InternalError.unexpected }
            let nextID = todo.id + 1
            let apiRouterStructure = APIRouterStructer(apiRouter: .todos(number: nextID))
            let todosPromiseNext: Promise<Todo> = self.session.request(apiRouterStructure)
            return todosPromiseNext
        }
        .then { [weak self] todoNext -> Promise<Todo> in
            guard let self = self else { throw InternalError.unexpected }
            self.myLable.text = self.myLable.text! + "\n" + "\(todoNext.id), " + todoNext.title
            
            let nextID = todoNext.id + 5
            let apiRouterStructure = APIRouterStructer(apiRouter: .todos(number: nextID))
            let todosPromiseNext: Promise<Todo> = self.session.request(apiRouterStructure)
            
            return todosPromiseNext
        }
        .then { [weak self] todoNext -> Promise<Void> in
            guard let self = self else { throw InternalError.unexpected }
            self.myLable.text = self.myLable.text! + "\n" + "\(todoNext.id), " + todoNext.title
            return Promise()
        }
        .catch { [weak self] error in
            guard let self = self else { return }
            print("there was an error")
            self.myLable.text = "There was an error"
        }
        .finally {
            print("finally done")
        }
    }
    
}
