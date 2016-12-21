//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Jason Wang on 12/20/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var fetchResultController: NSFetchedResultsController<Person>?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupButton()
        guard let manageObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.dataController.managedObjectContext else { return }
//        savePersonToCoreDataIn(manageObjectContext: manageObjectContext)


        setupFetchResultIn(manageObjectContext: manageObjectContext)


    }

    lazy var fetchResultButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("Fetch Button", for: .normal)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.addTarget(self, action: #selector(resultButtonTapped), for: .touchUpInside)
        return bt
    }()

    func resultButtonTapped() {
        print(fetchResultController?.fetchedObjects?.count ?? 0)
    }


    func setupButton() {
        view.addSubview(fetchResultButton)
        fetchResultButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        fetchResultButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }


    func setupFetchResultIn(manageObjectContext: NSManagedObjectContext) {

        let fetchRequest = NSFetchRequest<Person>(entityName: "Person")

        let predicate = NSPredicate(format: "firstName >= %@", "J")
        fetchRequest.predicate = predicate


        let sort = NSSortDescriptor(key: "age", ascending: true)
        fetchRequest.sortDescriptors = [sort]

        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: manageObjectContext, sectionNameKeyPath: nil, cacheName: nil)

        do {
            try fetchResultController?.performFetch()

        } catch let error {
            print("Fetch Result Controller perform fetch error: ", error)
        }


    }






    func savePersonToCoreDataIn(manageObjectContext: NSManagedObjectContext) {
        manageObjectContext.performAndWait {

            let jsonDict = self.fetchJSONDict()
            for personDict in jsonDict {
                let person = NSEntityDescription.insertNewObject(forEntityName: "Person", into: manageObjectContext) as? Person
                person?.parse(dict: personDict)
            }
            do {
                try manageObjectContext.save()
                manageObjectContext.parent?.performAndWait {
                    do {
                        try manageObjectContext.parent?.save()
                    } catch let error {
                        print("parent coreData Error: ", error)
                    }
                }
            } catch let error {
                print("child coreData Error: ", error)
            }
        }
    }



    func fetchJSONDict() -> [[String: Any]] {
        let personDictionary1: [String : Any] = ["firstName": "Jason", "lastName": "Wang", "age": 39]
        let personDictionary2: [String : Any] = ["firstName": "James", "lastName": "Wang", "age": 19]
        let personDictionary3: [String : Any] = ["firstName": "Annie", "lastName": "Wang", "age": 26]
        let personDictionary4: [String : Any] = ["firstName": "Karen", "lastName": "Wang", "age": 67]
        let jsonDict = [personDictionary1, personDictionary2, personDictionary3, personDictionary4]
        return jsonDict
    }
    
}

