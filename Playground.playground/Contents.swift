protocol Person {
    var name: String { get }
}

extension Person {
    var nameWithPosition: String {
        return "\(Self.self) \(name)"
    }
}

class Company {
    let ceo: CEO
    
    init(ceo: CEO) {
        self.ceo = ceo
    }
    
    deinit {
        print("Компания deallocating")
    }
}

class CEO: Person {
    
    let productManager: ProductManager
    
    var name: String {
        return "Иван Начальников"
    }
    
    lazy var printProductManager = { [weak self] in
        guard let productManager = self?.productManager else { return }
        print("\(productManager.nameWithPosition)")
    }
    lazy var printAllDevelopers = { [weak self] in
        guard let self = self else { return }
        self.productManager.printDevelopers()
    }
    lazy var printCompany = { [weak self] in
        guard let self = self else { return }
        self.productManager.printCompany()
    }
    
    init(productManager: ProductManager) {
        self.productManager = productManager
        
        self.productManager.ceo = self
    }
    
    deinit {
        print("\(self.nameWithPosition) deallocating")
    }
}

class ProductManager: Person {
    
    weak var ceo: CEO?
    
    var name: String {
        return "Петр Менеджеров"
    }
    
    let developer1: Developer1
    let developer2: Developer2
    
    init(developer1: Developer1, developer2: Developer2) {
        self.developer1 = developer1
        self.developer2 = developer2
        
        self.developer1.productManager = self
        self.developer2.productManager = self
    }
    
    func printDevelopers() {
        print("Developers:\n\(developer1.nameWithPosition)\n\(developer2.nameWithPosition)")
    }
    
    func printCompany() {
        guard let ceo = ceo else { return }
        
        print("Company:\n\(ceo.nameWithPosition)\n\(self.nameWithPosition)\n\(developer1.nameWithPosition)\n\(developer2.nameWithPosition)")
    }
    
    deinit {
        print("\(self.nameWithPosition) deallocating")
    }
}

class Developer: Person {
    
    weak var productManager: ProductManager?
    var name: String {
        return ""
    }
    
    func askProjectManagerAboutTechnicalSpecification() {
        guard let projectManager = productManager else { return }
        print("\(self.name): \(projectManager.name), жду ТЗ!")
    }
    
    func askProjectManagerAboutNewTask() {
        guard let projectManager = productManager else { return }
        print("\(self.name): \(projectManager.name), жду новую задачу!")
    }
    
    func askCEOAboutSalary() {
        guard let ceo = productManager?.ceo else { return }
        print("\(self.name): \(ceo.name), вот у другого девелопера 300к в час, хочу больше!")
    }
    
    deinit {
        print("\(self.nameWithPosition) deallocating")
    }
}

class Developer1: Developer {

    override var name: String {
        return "Олег Программистов"
    }

    func askAnotherDeveloperToPRReview() {
        guard let developer2 = productManager?.developer2 else { return }
        guard let productManager = productManager else { return }
        print("\(productManager.developer1.name): \(developer2.name), проверь мой PR, плиз")
    }
}

class Developer2: Developer {

    override var name: String {
        return "Вадим Кодов"
    }

    func sayAboutPR() {
        guard let developer1 = productManager?.developer1 else { return }
        guard let productManager = productManager else { return }
        print("\(productManager.developer2.name): \(developer1.name), опять наговнокодил :C")
    }
}


func simulateCompany() {
    let developer1 = Developer1()
    let developer2 = Developer2()
    
    let productManager = ProductManager(developer1: developer1, developer2: developer2)
    let ceo = CEO(productManager: productManager)
    productManager.ceo = ceo
    
    let company = Company(ceo: ceo)
    
    print("➡️")
    company.ceo.printProductManager()
    print("➡️")
    company.ceo.printAllDevelopers()
    print("➡️")
    company.ceo.productManager.printCompany()
    
    print("💬")
    developer1.askProjectManagerAboutTechnicalSpecification()
    developer1.askProjectManagerAboutNewTask()
    print("💬")
    developer1.askAnotherDeveloperToPRReview()
    developer2.sayAboutPR()
    print("💬")
    developer2.askCEOAboutSalary()
    
    print()
}

simulateCompany()



