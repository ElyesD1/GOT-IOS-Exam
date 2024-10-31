import UIKit
import CoreData

// Favorites class to manage favorite warriors
class Favorites: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var TableView: UITableView! // Outlet for the table view
    var favoriteWarriors: [NSManagedObject] = [] // Array to hold favorite warriors from Core Data

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delegate and data source for the table view
        TableView.delegate = self
        TableView.dataSource = self

        // Fetch favorite warriors from Core Data
        fetchFavoriteWarriors()
    }

    // Fetch favorite warriors from Core Data
    func fetchFavoriteWarriors() {
        // Get the managed object context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteWarrior") // Create a fetch request for FavoriteWarrior entity
        
        do {
            // Execute the fetch request
            favoriteWarriors = try context.fetch(fetchRequest)
            TableView.reloadData() // Reload the table view with the fetched data
        } catch {
            print("Failed to fetch favorite warriors: \(error)") // Handle fetch error
        }
    }

    // TableView DataSource Methods
    // Returns the number of rows in the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteWarriors.count // Return the count of favorite warriors
    }

    // Configures and returns a cell for each row in the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a reusable cell of type FavCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavCell", for: indexPath) as? FavCell else {
            return UITableViewCell() // Return an empty cell if dequeuing fails
        }
        
        let warrior = favoriteWarriors[indexPath.row] // Get the favorite warrior for the current row
        
        // Retrieve values from warrior entity
        if let imageName = warrior.value(forKey: "imageName") as? String,
           let name = warrior.value(forKey: "name") as? String,
           let strength = warrior.value(forKey: "strength") as? Float,
           let ethics = warrior.value(forKey: "ethics") as? Float {
            
            // Configure the cell's image and labels
            cell.WarImage.image = UIImage(named: imageName) // Set warrior image
            cell.WarName.text = name // Set warrior name
            
            // Calculate WarScore using strength and ethics
            let warScore = (strength * 2 + ethics) / 3
            cell.WarScore.text = String(format: "%.1f", warScore) // Set formatted WarScore
        }
        
        return cell // Return the configured cell
    }

    // Swipe action configuration for each row
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Create a delete action for swiping
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            
            guard let self = self else { return } // Ensure self is not nil
            self.deleteWarrior(at: indexPath) // Call delete function for the selected warrior
            completionHandler(true) // Indicate that the action is complete
        }
        
        deleteAction.backgroundColor = .red // Set background color to red for delete action
        
        // Create a swipe action configuration with the delete action
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration // Return the swipe actions configuration
    }

    // Function to delete a warrior from Core Data and update the table view
    private func deleteWarrior(at indexPath: IndexPath) {
        // Get the managed object context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Delete the warrior object from Core Data
        context.delete(favoriteWarriors[indexPath.row])
        
        // Update the data source by removing the warrior from the array
        favoriteWarriors.remove(at: indexPath.row)
        
        // Remove the row from the table view with an animation
        TableView.deleteRows(at: [indexPath], with: .automatic)
        
        // Save the context to persist the deletion
        do {
            try context.save()
        } catch {
            print("Failed to save context after deletion: \(error)") // Handle save error
        }
    }
}

// Custom UITableViewCell class for favorite warriors
class FavCell: UITableViewCell {
    @IBOutlet weak var WarImage: UIImageView! // Outlet for warrior image
    @IBOutlet weak var WarName: UILabel! // Outlet for warrior name label
    @IBOutlet weak var WarScore: UILabel! // Outlet for warrior score label
}
