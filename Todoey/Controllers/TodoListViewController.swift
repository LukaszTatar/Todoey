import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    var arrayList = [Item]()
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = arrayList[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = (item.done == true) ? .checkmark : .none
        
        //        if item.done == true {
        //            cell.accessoryType = .checkmark
        //        } else {
        //            cell.accessoryType = .none
        //        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        arrayList[indexPath.row].done = !arrayList[indexPath.row].done
        
        //        if arrayList[indexPath.row].done == false {
        //            arrayList[indexPath.row].done = true
        //        } else {
        //            arrayList[indexPath.row].done = false
        //        }
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item to list", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new item to list"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            if (textField.text != "") {
                
                let item = Item(context: self.contex)
                item.title = textField.text!
                item.done = false
                self.arrayList.append(item)
                
                self.saveItems()
                
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        
        do {
            try contex.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    func loadItems() {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            arrayList = try contex.fetch(request)
        } catch {
            print("Error fetching data from contex \(error)")
        }
    }
}
//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
    }
}

