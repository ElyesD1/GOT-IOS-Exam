import UIKit
import CoreData

class Details: UIViewController {
    @IBOutlet weak var WarriorImage: UIImageView! // Image view to display the warrior's image
    @IBOutlet weak var WarriorName: UILabel! // Label to display the warrior's name
    @IBOutlet weak var StrengthValue: UILabel! // Label to display the warrior's strength value
    @IBOutlet weak var EthicsValue: UILabel! // Label to display the warrior's ethics value
    @IBOutlet weak var strengthSlider: UISlider! // Slider to adjust strength value
    @IBOutlet weak var ethicsSlider: UISlider! // Slider to adjust ethics value

    // Property to hold the passed character data
    var character: Character?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Display character data
        if let character = character {
            WarriorName.text = character.name // Set the warrior's name
            WarriorImage.image = UIImage(named: character.imageName) // Set the warrior's image
            // Set sliders to character's initial strength and ethics values
            strengthSlider.value = character.strength
            ethicsSlider.value = character.ethics
        }

        // Configure slider properties
        strengthSlider.minimumValue = 0 // Minimum value for strength slider
        strengthSlider.maximumValue = 10 // Maximum value for strength slider
        ethicsSlider.minimumValue = 0 // Minimum value for ethics slider
        ethicsSlider.maximumValue = 10 // Maximum value for ethics slider

        // Display initial values for strength and ethics
        updateStrengthValue() // Update the displayed strength value
        updateEthicsValue() // Update the displayed ethics value

        // Set up actions to update labels as slider values change
        strengthSlider.addTarget(self, action: #selector(strengthSliderChanged(_:)), for: .valueChanged) // Action for strength slider
        ethicsSlider.addTarget(self, action: #selector(ethicsSliderChanged(_:)), for: .valueChanged) // Action for ethics slider
    }

    // Method to update StrengthValue label as slider changes
    @objc func strengthSliderChanged(_ sender: UISlider) {
        updateStrengthValue() // Update the strength value display
    }

    // Method to update EthicsValue label as slider changes
    @objc func ethicsSliderChanged(_ sender: UISlider) {
        updateEthicsValue() // Update the ethics value display
    }

    // Helper method to update StrengthValue label with the slider's current value
    private func updateStrengthValue() {
        StrengthValue.text = "\(Int(strengthSlider.value))" // Convert slider value to integer and set it to the label
    }

    // Helper method to update EthicsValue label with the slider's current value
    private func updateEthicsValue() {
        EthicsValue.text = "\(Int(ethicsSlider.value))" // Convert slider value to integer and set it to the label
    }

    @IBAction func AddToFav(_ sender: Any) {
        guard let character = character else { return } // Ensure character data is available
        
        // Check if the warrior already exists in favorites
        if warriorExists(name: character.name) {
            showAlert(message: "Already the best") // Show alert if warrior is already in favorites
        } else if strengthSlider.value < 7 {
            showAlert(message: "Warrior is too weak and not ready yet") // Show alert if warrior's strength is insufficient
        } else {
            addWarriorToFavorites(character: character) // Add warrior to favorites
            showAlert(message: "Warrior successfully added to Favorites") // Show success alert
        }
    }

    // Core Data function to check if a warrior already exists
    private func warriorExists(name: String) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteWarrior> = FavoriteWarrior.fetchRequest() // Create fetch request
        fetchRequest.predicate = NSPredicate(format: "name == %@", name) // Set predicate to find warrior by name
        
        do {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // Get the context
            let result = try context.fetch(fetchRequest) // Fetch results
            return !result.isEmpty // Return true if the warrior already exists
        } catch {
            print("Error fetching warrior: \(error)") // Print error if fetching fails
            return false // Return false on error
        }
    }

    // Core Data function to add a warrior to favorites
    private func addWarriorToFavorites(character: Character) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // Get the context
        let newWarrior = FavoriteWarrior(context: context) // Create a new FavoriteWarrior object
        
        // Set properties for the new warrior
        newWarrior.name = character.name
        newWarrior.imageName = character.imageName
        newWarrior.strength = strengthSlider.value
        newWarrior.ethics = ethicsSlider.value
        
        do {
            try context.save() // Save the context
        } catch {
            print("Failed to save warrior: \(error)") // Print error if saving fails
        }
    }

    // Helper function to show an alert with a given message
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert) // Create an alert controller
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil)) // Add an OK action
        self.present(alert, animated: true, completion: nil) // Present the alert
    }
}
