//
//  VocabularyPageViewController.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 13.03.2021.
//  Copyright © 2021 Ivan Chernetskiy. All rights reserved.
//

import UIKit

class VocabularyPageViewController: UIPageViewController {
    
    var orderedViewControllers = [UIViewController]()
    
    var completion: (Int) -> Void = { _ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        setupViews()
        setViewControllers([orderedViewControllers.first!], direction: .forward, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        setupViews()
    }
    
    
    func setupViews() {
        let vc0 = storyboard!.instantiateViewController(identifier: "EmbededVocabularyViewController") as! EmbededVocabularyViewController
        vc0.ind = 0
        vc0.words = DictionaryManager.shared.getWordsForStudy()
        let vc1 = storyboard!.instantiateViewController(identifier: "EmbededVocabularyViewController") as! EmbededVocabularyViewController
        vc1.ind = 1
        vc1.words = DictionaryManager.shared.getWordsForRecall()
        let vc2 = storyboard!.instantiateViewController(identifier: "EmbededVocabularyViewController") as! EmbededVocabularyViewController
        vc2.ind = 2
        vc2.words = DictionaryManager.shared.getLearnedWords()
        orderedViewControllers = [vc0, vc1, vc2]
    }
}


extension VocabularyPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard orderedViewControllers.count > previousIndex else { return nil }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        guard orderedViewControllersCount != nextIndex else { return nil }
        guard orderedViewControllersCount > nextIndex else { return nil }
        
        return orderedViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentViewController = pageViewController.viewControllers![0] as? EmbededVocabularyViewController {
            print("~~ index: \(currentViewController.ind)")
            completion(currentViewController.ind)
        }
    }
}

extension UIPageViewController {
    func goToNextPage() {
       guard let currentViewController = self.viewControllers?.first else { return }
       guard let nextViewController = dataSource?.pageViewController( self, viewControllerAfter: currentViewController ) else { return }
       setViewControllers([nextViewController], direction: .forward, animated: false, completion: nil)
    }

    func goToPreviousPage() {
       guard let currentViewController = self.viewControllers?.first else { return }
       guard let previousViewController = dataSource?.pageViewController( self, viewControllerBefore: currentViewController ) else { return }
       setViewControllers([previousViewController], direction: .reverse, animated: false, completion: nil)
    }
}
