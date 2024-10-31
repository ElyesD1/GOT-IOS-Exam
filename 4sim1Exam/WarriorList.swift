import UIKit

// Character struct moved outside for accessibility in both view controllers
struct Character {
    let name: String         // Character's name
    let imageName: String    // Image name for the character
    let strength: Float      // Character's strength value
    let ethics: Float        // Character's ethics value
}

class WarriorList: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var listView: UITableView! // TableView to display the list of characters

    // Data source: array of Character objects
    let characters: [Character] = [
        Character(name: "Jaimie Lannister", imageName: "Jaimie Lannister", strength: 8.0, ethics: 5.0),
        Character(name: "Jon Snow", imageName: "Jon Snow", strength: 9.0, ethics: 8.0),
        Character(name: "Ned Stark", imageName: "Ned Stark", strength: 7.0, ethics: 9.0),
        Character(name: "Khal Drogo", imageName: "Khal Drogo", strength: 10.0, ethics: 3.0),
        Character(name: "Tyrion Lannister", imageName: "Tyrion Lannister", strength: 4.0, ethics: 6.0),
        Character(name: "Daenerys Targaryen", imageName: "Daenerys Targaryen", strength: 7.0, ethics: 7.0),
        Character(name: "Cersei Lannister", imageName: "Cersei Lannister", strength: 6.0, ethics: 2.0)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the tableView's data source and delegate
        listView.dataSource = self  // Assign the data source
        listView.delegate = self      // Assign the delegate
    }

    // UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count  // Return the number of characters to display in the table
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a cell of type WarriorCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WarriorCell", for: indexPath) as? WarriorCell else {
            return UITableViewCell() // Return an empty cell if dequeuing fails
        }
        
        // Configure the cell with character data
        let character = characters[indexPath.row] // Get the character for the current row
        cell.configure(with: character) // Configure the cell using the character's data
        
        return cell // Return the configured cell
    }

    // UITableViewDelegate Method for selecting a row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Instantiate the Details view controller
        if let detailsVC = storyboard?.instantiateViewController(withIdentifier: "Details") as? Details {
            // Pass selected character data to the Details view controller
            detailsVC.character = characters[indexPath.row] // Set the selected character
            // Push the Details view controller onto the navigation stack
            navigationController?.pushViewController(detailsVC, animated: true) // Navigate to Details view
        }
    }
    
    @IBAction func navToFav(_ sender: Any) {
        // Instantiate the Favorites view controller
        if let favoritesVC = storyboard?.instantiateViewController(withIdentifier: "Favorites") {
            // Push the Favorites view controller onto the navigation stack
            navigationController?.pushViewController(favoritesVC, animated: true) // Navigate to Favorites view
        }
    }
}

class WarriorCell: UITableViewCell {
    
    @IBOutlet weak var characterImageView: UIImageView! // Image view to display character's image
    @IBOutlet weak var nameLabel: UILabel! // Label to display character's name

    // Method to configure the cell with character data
    func configure(with character: Character) {
        nameLabel.text = character.name // Set the character name in the label
        characterImageView.image = UIImage(named: character.imageName) // Set the character image
    }
}
