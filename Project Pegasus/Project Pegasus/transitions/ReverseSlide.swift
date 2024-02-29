//
//  Personal_Slide.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 29/02/24.
//

import AtomicTransition
import SwiftUI
import NavigationTransitions

extension AnyNavigationTransition {
    /// A transition that moves both views in and out along the specified axis.
    ///
    /// This transition:
    /// - Pushes views left-to-right and pops views left-to-right when `axis` is `horizontal`.
    /// - Pushes views top-to-bottom and pops views top-to-bottom when `axis` is `vertical`.
    public static func reverseSlide(axis: Axis) -> Self {
        .init(ReverseSlide(axis: axis))
    }
}

extension AnyNavigationTransition {
    /// Equivalent to `slide(axis: .horizontal)`.
    @inlinable
    public static var slide: Self {
        .reverseSlide(axis: .horizontal)
    }
}

/// A transition that moves both views in and out along the specified axis.
///
/// This transition:
/// - Pushes views left-to-right and pops views left-to-right when `axis` is `horizontal`.
/// - Pushes views top-to-bottom and pops views top-to-bottom when `axis` is `vertical`.
public struct ReverseSlide: NavigationTransition {
    private let axis: Axis

    public init(axis: Axis) {
        self.axis = axis
    }

    /// Equivalent to `Move(axis: .horizontal)`.
    @inlinable
    public init() {
        self.init(axis: .horizontal)
    }

    public var body: some NavigationTransition {
        switch axis {
        case .horizontal:
            MirrorPush {
                OnInsertion {
                    Move(edge: .leading)
                }
                OnRemoval {
                    Move(edge: .trailing)
                }
            }
        case .vertical:
            MirrorPush {
                OnInsertion {
                    Move(edge: .top)
                }
                OnRemoval {
                    Move(edge: .bottom)
                }
            }
        }
    }
}

extension ReverseSlide: Hashable {}
