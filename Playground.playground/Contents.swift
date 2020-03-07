class Company {
    let ceo: CEO
    
    init(ceo: CEO) {
        self.ceo = ceo
    }
    
    deinit {
        print("\(self) deallocating")
    }
}

class CEO {
    
    let productManager: ProductManager
    
    lazy var printProductManager = { [weak self] in
        guard let productManager = self?.productManager else { return }
        print("\(productManager)")
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
        print("\(self) deallocating")
    }
}

class ProductManager {
    
    weak var ceo: CEO?
    
    let developer1: Developer1
    let developer2: Developer2
    
    init(developer1: Developer1, developer2: Developer2) {
        self.developer1 = developer1
        self.developer2 = developer2
        
        self.developer1.productManager = self
        self.developer2.productManager = self
    }
    
    func printDevelopers() {
        print("Developers:\n\(developer1)\n\(developer2)")
    }
    
    func printCompany() {
        guard let ceo = ceo else { return }
        
        print("Company:\n\(ceo)\n\(self)\n\(developer1)\n\(developer2)")
    }
    
    deinit {
        print("\(self) deallocating")
    }
}

class Developer {
    
    weak var productManager: ProductManager?
    
    func askProjectManagerAboutTechnicalSpecification() {
        guard let projectManager = productManager else { return }
        print("\(self): \(projectManager), жду ТЗ!")
    }
    
    func askProjectManagerAboutNewTask() {
        guard let projectManager = productManager else { return }
        print("\(self): \(projectManager), жду новую задачу!")
    }
    
    func askCEOAboutSalary() {
        guard let ceo = productManager?.ceo else { return }
        print("\(self): \(ceo), вот у другого девелопера 300к в час, хочу больше!")
    }
    
    deinit {
        print("\(self) deallocating")
    }
}

class Developer1: Developer {
    
    func askAnotherDeveloperToPRReview() {
        guard let developer2 = productManager?.developer2 else { return }
        print("\(self): \(developer2), проверь мой PR, плиз")
    }
}

class Developer2: Developer {
    
    func sayAboutPR() {
        guard let developer1 = productManager?.developer1 else { return }
        print("\(self): \(developer1), опять наговнокодил :C")
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

