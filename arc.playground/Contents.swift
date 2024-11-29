import Foundation

class PersonClass {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

struct PersonStruct {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

var structA = PersonStruct(name: "Ali")
var structB = structA
structA.name = "Veli"

var classA = PersonClass(name: "Ali")
var classB = classA
classA.name = "Veli"

print("classA: \(classA.name) ---- classB: \(classB.name)")
print("structA: \(structA.name) ---- structB: \(structB.name)")

class Customer {
    let name: String
    var card: CreditCard?
    
    init(name: String) {
        self.name = name
        print("\(name) customer init edildi")
    }
    
    deinit {
        print("Customer \(name) deinit")
    }
}

class CreditCard {
    let number: String
    var owner: Customer?
    
    init(number: String) {
        self.number = number
        print("\(number) credit card init edildi")
    }
    
    deinit {
        print("Credit card \(number) deinit")
    }
}

func createRetainCycle() {
    let customer = Customer(name: "Ali")
    let card = CreditCard(number: "1234-1234-1234-1234")
    
    customer.card = card
    card.owner = customer
}

createRetainCycle()


// MARK: - Closure Örneği
class TutorialManager {
    let title: String
    var onComplete: (() -> Void)?
    
    init(title: String) {
        self.title = title
        print("TutorialManager \(title) init edildi")
    }
    
    deinit {
        print("TutorialManager \(title) deinit edildi")
    }
    
    func completeTutorial() {
        onComplete?()
    }
}

class TutorialViewController {
    var tutorialManager: TutorialManager?
    
    init() {
        print("TutorialViewController init edildi")
    }
    
    deinit {
        print("TutorialViewController deinit edildi")
    }
    
    // MARK: - Retain Cycle Örneği
    func setupTutorialWithRetainCycle() {
        let manager = TutorialManager(title: "Swift ARC")
        
        // Retain Cycle oluşturan closure
        manager.onComplete = {
            self.tutorialCompleted() // self'e strong reference
            print("strong completed")
        }
        
        tutorialManager = manager
    }
    
    // MARK: - Weak Self ile Doğru Kullanım
    func setupTutorialWithWeakSelf() {
        let manager = TutorialManager(title: "Swift ARC")
        
        // Weak self kullanarak retain cycle'ı önleme
        manager.onComplete = { [weak self] in
            self?.tutorialCompleted() // weak reference
            print("weak completed")
        }
        tutorialManager = manager
        
    }
    
    func tutorialCompleted() {
        print("tutorial tamamlandı")
    }
}

func testStrongReference() {
    print("\n--- Retain Cycle Test ---")
    var viewController: TutorialViewController? = TutorialViewController()
    viewController?.setupTutorialWithRetainCycle()
    viewController?.tutorialManager?.completeTutorial()
    // View controller'ı nil yapıyoruz
    print("View Controller'ı nil yapıyoruz...")
    viewController = nil
    // Deinit çağrılmayacak çünkü retain cycle var!
}

func testWeakReference() {
    print("\n--- Weak Self Test ---")
    var viewController: TutorialViewController? = TutorialViewController()
    viewController?.setupTutorialWithWeakSelf()
    viewController?.tutorialManager?.completeTutorial()
    // View controller'ı nil yapıyoruz
    print("View Controller'ı nil yapıyoruz...")
    viewController = nil
    // Deinit çağrılacak çünkü weak self kullandık
}

print("Test 1: Strong Reference (Retain Cycle) Problemi")
testStrongReference()
print("\nTest 2: Weak Reference Çözümü")
testWeakReference()
