//
//  AnimationFactory.swift
//  Pods
//
//  Created by Rafael Moura on 16/03/17.
//  Copyright © 2023 Nilframe. All rights reserved.
//

import Foundation
import SpriteKit

class ActionFactory: NSObject {
    
    static func action(for keyframe: Keyframe,
                       previousKeyframe: Keyframe?,
                       duration: TimeInterval) -> SKAction {
        
        var group = [SKAction]()
        
        if let moveAction = moveAction(with: keyframe,
                                       and: previousKeyframe,
                                       duration: duration) {
            group.append(moveAction)
        }
        
        if let rotateAction = rotateAction(with: keyframe,
                                           and: previousKeyframe,
                                           duration: duration) {
            group.append(rotateAction)
        }
        
        if let resizeAction = resizeAction(with: keyframe,
                                           and: previousKeyframe,
                                           duration: duration) {
            group.append(resizeAction)
        }
        
        if let scaleAction = scaleAction(with: keyframe,
                                         and: previousKeyframe,
                                         duration: duration) {
            group.append(scaleAction)
        }

        if let alphaAction = alphaActionForKeyframe(keyframe,
                                                    lastKeyframe: previousKeyframe,
                                                    duration: duration) {

            group.append(alphaAction)
        }

        if let colorizeAction = colorizeActionForKeyframe(keyframe,
                                                          lastKeyframe: previousKeyframe,
                                                          duration: duration) {

            group.append(colorizeAction)
        }
        
        return group.count > 0 ? SKAction.group(group) : SKAction.wait(forDuration: duration)
        
    }
 
    static private func rotateAction(with keyframe: Keyframe,
                                     and previousKeyframe: Keyframe?,
                                     duration: TimeInterval) -> SKAction? {
        
        if let previousKeyframe = previousKeyframe, keyframe.rotation == previousKeyframe.rotation {
            return nil
        }
        
        let action: SKAction
        action = SKAction.rotate(toAngle: keyframe.rotation,
                                 duration: duration,
                                 shortestUnitArc: false)

        action.timingMode = actionTimingMode(for: keyframe.timingMode)
        return action
    }
    
    static private func resizeAction(with keyframe: Keyframe,
                                     and previousKeyframe: Keyframe?,
                                     duration: TimeInterval) -> SKAction? {
        
        if let previousKeyframe = previousKeyframe, keyframe.size == previousKeyframe.size {
            return nil
        }
        
        let action: SKAction
        action = SKAction.resize(toWidth: keyframe.size.width,
                                 height: keyframe.size.height,
                                 duration: duration)

        action.timingMode = actionTimingMode(for: keyframe.timingMode)
        return action
    }
    
    static private func scaleAction(with keyframe: Keyframe,
                                    and previousKeyframe: Keyframe?,
                                    duration: TimeInterval) -> SKAction? {
        
        if let previousKeyframe = previousKeyframe, keyframe.scale == previousKeyframe.scale {
            return nil
        }
        
        let action: SKAction
        action = SKAction.scaleX(to: keyframe.scale.x, y: keyframe.scale.y, duration: duration)
        return action
    }
    
    static private func moveAction(with keyframe: Keyframe,
                                   and previousKeyframe: Keyframe?,
                                   duration: TimeInterval) -> SKAction? {
        
        if let previousKeyframe = previousKeyframe, keyframe.position == previousKeyframe.position {
            return nil
        }
        
        let action: SKAction
        action = SKAction.move(to: keyframe.position, duration: duration)
        action.timingMode = actionTimingMode(for: keyframe.timingMode)
        return action
    }

    static private func alphaActionForKeyframe(_ keyframe: Keyframe,
                                               lastKeyframe: Keyframe?,
                                               duration: TimeInterval) -> SKAction? {

        guard let lastKeyframe = lastKeyframe, keyframe.alpha != lastKeyframe.alpha else {
            return nil
        }

        let action = SKAction.fadeAlpha(to: keyframe.alpha, duration: duration)
        action.timingMode = actionTimingMode(for: keyframe.timingMode)

        return action
    }

    static private func colorizeActionForKeyframe(_ keyframe: Keyframe,
                                                  lastKeyframe: Keyframe?,
                                                  duration: TimeInterval) -> SKAction? {

        guard let lastKeyframe = lastKeyframe,
              (keyframe.color != lastKeyframe.color ||
              keyframe.colorBlendFactor != lastKeyframe.colorBlendFactor) else {
            return nil
        }

        let action = SKAction.colorize(with: keyframe.color,
                                       colorBlendFactor: keyframe.colorBlendFactor,
                                       duration: duration)

        action.timingMode = actionTimingMode(for: keyframe.timingMode)

        return action
    }

    static private func actionTimingMode(for timingMode: Keyframe.TimingMode) -> SKActionTimingMode {

        switch timingMode {

        case .linear:
            return .linear

        case .easeIn:
            return .easeIn

        case .easeOut:
            return .easeOut

        case .easeInEaseOut:
            return .easeInEaseOut
        }
    }
}
