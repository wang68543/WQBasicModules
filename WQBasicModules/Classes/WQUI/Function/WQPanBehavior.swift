//
//  WQPanBehavior.swift
//  WQBasicModules
//
//  Created by HuaShengiOS on 2019/3/21.
//

import UIKit

public enum WQPanState {
    case top
    case mid
    case bottom
}
public extension WQPanState {
    func toNextDown(_ states: [WQPanState]) -> WQPanState? {
        var value: WQPanState?
        switch self {
        case .top:
            for state in states {
                switch state {
                case .mid:
                   value = state
                case .bottom:
                    if value == nil {
                        value = state
                    }
                default:
                    break
                }
            }
        case .mid:
            for state in states {
                switch state {
                case .bottom:
                    value = state
                default:
                    break
                }
            }
        default:
            break
        }
        return value
    }
    func toNextUp(_ states: [WQPanState]) -> WQPanState? {
        var value: WQPanState?
        switch self {
        case .bottom:
            for state in states {
                switch state {
                case .mid:
                    value = state
                case .top:
                    if value == nil {
                        value = state
                    }
                default:
                    break
                }
            }
        case .mid:
            for state in states {
                switch state {
                case .top:
                    value = state
                default:
                    break
                }
            }
        default:
            break
        }
        return value
    }
}
public class WQPanBehavior: UIDynamicBehavior {
    
    public let item: UIDynamicItem
    public let attachmentBehavior: UIAttachmentBehavior
    public let itemBehavior: UIDynamicItemBehavior
    
    public var targetPoint: CGPoint = .zero {
        didSet {
            self.attachmentBehavior.anchorPoint = targetPoint
        }
    }
    public var velocity: CGPoint = .zero {
        didSet {
            let currentVelocity = self.itemBehavior.linearVelocity(for: self.item)
            let velocityDelta = CGPoint(x: velocity.x - currentVelocity.x, y: velocity.y - currentVelocity.y)
            self.itemBehavior.addLinearVelocity(velocityDelta, for: self.item)
        }
    }
    
    public init(with item: UIDynamicItem) {
        self.item = item
        attachmentBehavior = UIAttachmentBehavior(item: item, attachedToAnchor: .zero)
        attachmentBehavior.frequency = 3.5
        attachmentBehavior.damping = 0.4
        attachmentBehavior.length = 0
        
        itemBehavior = UIDynamicItemBehavior(items: [item])
        itemBehavior.density = 100
        itemBehavior.resistance = 10
        super.init()
        
        self.addChildBehavior(attachmentBehavior)
        self.addChildBehavior(itemBehavior)
    }
    
    
    /*- (void)animatePaneWithInitialVelocity:(CGPoint)initialVelocity
    {
    if (!self.paneBehavior) {
    PaneBehavior *behavior = [[PaneBehavior alloc] initWithItem:self.pane];
    self.paneBehavior = behavior;
    }
    self.paneBehavior.targetPoint = self.targetPoint;
    self.paneBehavior.velocity = initialVelocity;
    [self.animator addBehavior:self.paneBehavior];
    }
    
    - (CGPoint)targetPoint
    {
    CGSize size = self.bounds.size;
    return self.paneState == PaneStateClosed > 0 ? CGPointMake(size.width/2, size.height * 1.25) : CGPointMake(size.width/2, size.height/2 + 50);
    }
    
    
    #pragma mark DraggableViewDelegate
    
    - (void)draggableView:(DraggableView *)view draggingEndedWithVelocity:(CGPoint)velocity
    {
    PaneState targetState = velocity.y >= 0 ? PaneStateClosed : PaneStateOpen;
    self.paneState = targetState;
    [self animatePaneWithInitialVelocity:velocity];
    }
    
    - (void)draggableViewBeganDragging:(DraggableView *)view
    {
    [self.animator removeAllBehaviors];
    }
    
    
    #pragma mark Actions
    
    - (void)didTap:(UITapGestureRecognizer *)tapRecognizer
    {
    self.paneState = self.paneState == PaneStateOpen ? PaneStateClosed : PaneStateOpen;
    [self animatePaneWithInitialVelocity:self.paneBehavior.velocity];
    }*/
}
