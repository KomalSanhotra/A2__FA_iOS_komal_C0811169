//
//  productTableViewController.swift
//  A2__FA_iOS_komal_C0811169
//
//  Created by MacStudent on 2021-05-26.
//  Copyright © 2021 MacStudent. All rights reserved.
//

import UIKit
import CoreData

class productTableViewController: UITableViewController {
       var products = [Products]()
        

        // create the context
         let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
         
         // define a search controller
         let searchController = UISearchController(searchResultsController: nil)
         

        override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationController?.isToolbarHidden = false
            
    //        if someEntityExists() == false {
    //            saveStaticProducts()
    //        } else {
    //            deleteAllRecords()
    //            saveStaticProducts()
    //        }
          
           showSearchBar()
           loadProducts()

                
           searchController.isActive = true
        
        }
        

        override func viewWillAppear(_ animated: Bool) {
               tableView.reloadData()
           }
        
        // MARK: - Table view data source

        override func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return products.count
        }

        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath)
             let product = products[indexPath.row]
            // Configure the cell...
           cell.textLabel?.text = "\(product.id)" + "." + product.name! + " - " + "$\(product.price)"
            cell.detailTextLabel?.text = product.provider!  + " - " + product.descriptionp!
            
            
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .lightGray
            cell.selectedBackgroundView = backgroundView
            
            return cell
        }


        
        // Override to support conditional editing of the table view.
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            // Return false if you do not want the specified item to be editable.
            return true
        }
        
        
           // Override to support editing the table view.
           override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
               if editingStyle == .delete {
                   // Delete the row from the data source
                   
                   deleteProduct(product: products[indexPath.row])
                   saveProducts()
                   products.remove(at: indexPath.row)
                              // Delete the row from the data source
                              
                   tableView.deleteRows(at: [indexPath], with: .fade)
                   
                   
               } else if editingStyle == .insert {
                   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
               }
           }
        
        
            
            // MARK: - Navigation

        //   In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            if let destination = segue.destination as? ViewController {
                      destination.delegate = self
                      
                      if let cell = sender as? UITableViewCell {
                          if let index = tableView.indexPath(for: cell)?.row {
                              destination.selectedProduct = products[index]
                          }
                      }
                  }

         }

        func updateProduct(with name: String, id: Int, descriptionp: String, price: Int, provider:String) {
                 products = []
                 let newProduct = Products(context: context)
                 newProduct.name = name
                 newProduct.id = Int16(id)
                 newProduct.descriptionp = descriptionp
                 newProduct.price = Double(price)
                 newProduct.provider = provider

                 saveProducts()
                 loadProducts()
             }

       
        
        func saveProducts(){
            do {
                      try context.save()
                      tableView.reloadData()
                  } catch {
                      print("Error saving the folder \(error.localizedDescription)")
                  }
        }
        
        
        func deleteProduct(product: Products) {
                 context.delete(product)
             }

        
      func loadProducts(predicate: NSPredicate? = nil) {
          let request: NSFetchRequest<Products> = Products.fetchRequest()
          request.predicate = predicate
          request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
          do {
              products = try context.fetch(request)
          } catch {
              print("Error loading products \(error.localizedDescription)")
          }
          tableView.reloadData()
      }
      
     
        
        func showSearchBar() {
            searchController.searchBar.delegate = self as! UISearchBarDelegate
               searchController.obscuresBackgroundDuringPresentation = false
               searchController.searchBar.placeholder = "Search Product"
               navigationItem.searchController = searchController
               definesPresentationContext = true
               searchController.searchBar.searchTextField.textColor = .lightGray
           }

    }
     

    //MARK: - search bar delegate methods
    extension productTableViewController: UISearchBarDelegate {
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            // add predicate
            let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
            loadProducts(predicate : predicate)
        }
        

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchBar.text?.count == 0 {
                loadProducts()
                
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
            }
        }
        
    }


