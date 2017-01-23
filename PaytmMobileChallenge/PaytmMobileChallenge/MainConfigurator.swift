
class MainConfigurator {
    func configureMainModule() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let controller = storyboard.instantiateViewController(withIdentifier: "MainNavigationController") as? UINavigationController,
                    let mainView = controller.viewControllers[0] as? CurrencyConverterViewController else {
            return UIViewController()
        }
        
        let presenter = CurrencyConverterPresenterImpl()
        presenter.currencyView = mainView
        
        mainView.currencyPresenter = presenter
        
        return controller
    }
}
