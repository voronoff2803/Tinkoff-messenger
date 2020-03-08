import Foundation

class Person {
    var name: String
    init(name: String) {
        self.name = name
    }
    
    fileprivate func chatMessage(_ message: String) {
        print("\(name): " + message)
    }
    
    deinit {
        print("\(self.name) deinit")
    }
}

final class CEO: Person {
    var manager: ProductManager?
    
    lazy var printMyCompany = { [weak self] in
        guard let ceo = self else { return }
        print("CEO is \(ceo.name)")
        print("Product Manager is \(ceo.manager?.name ?? "nobody")")
        ceo.manager?.developers.forEach({print("Developer is \($0.name)")})
    }
    
    lazy var tryToCloseCompany = { [weak self] in
        guard let ceo = self else { return }
        ceo.chatMessage("Закрываю компанию!")
        guard let manager = ceo.manager else { return }
        let result = manager.tryToDismissDevelopers()
        if result { ceo.chatMessage("Компания закрыта!"); ceo.manager = nil } else { ceo.chatMessage("Не получилось закрыть компанию") }
    }
}

final class ProductManager: Person {
    weak var ceo: CEO?
    var developers: [Developer] = []
    
    func tryToDismissDevelopers() -> Bool {
        chatMessage("уволняю разработчиков")
        var result = true
        developers.forEach({ if !$0.dismiss() { result = false }})
        if result { chatMessage("разработчики уволены"); developers = [] } else { chatMessage("Не получилось уволить разработчиков") }
        return result
    }
}

final class Developer: Person {
    weak var productManager: ProductManager?
    
    func dismiss() -> Bool {
        let answer = Bool.random()
        if answer { chatMessage("уволняюсь"); productManager = nil } else { chatMessage("не хочу увольняться") }
        return answer
    }
}

func createCompany() -> CEO {
    let ceo = CEO(name: "ceo")
    let pm = ProductManager(name: "product manager")
    let dev1 = Developer(name: "developer 1")
    let dev2 = Developer(name: "developer 2")
    
    ceo.manager = pm
    pm.ceo = ceo
    pm.developers.append(dev1)
    pm.developers.append(dev2)
    
    return ceo
}

func start() {
    let ceo = createCompany()
    ceo.printMyCompany()
    ceo.tryToCloseCompany()
}

start()
