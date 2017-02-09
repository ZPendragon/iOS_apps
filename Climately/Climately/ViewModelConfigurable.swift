//
//  ViewModelConfigurable.swift
//  Climately
//
//  Created by Kevin Zeckser on 2/8/17.
//  Copyright © 2017 Kevin Zeckser. All rights reserved.
//

import Foundation

protocol FeedCellConfigurable {
    func configureCellWithViewModel<T>(viewModel: T)
}
