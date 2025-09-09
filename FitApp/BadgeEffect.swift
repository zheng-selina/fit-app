// Marcelo Nogueira mseroesn@iu.edu
// Selina Zheng selzheng@iu.edu
// FitQuest
// 4/28/23

import Foundation
import SpriteKit

class BadgeEffect:SKScene{
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setUpParticleEmitter()
    }
    
    private func setUpParticleEmitter(){
        let emitter = SKEmitterNode(fileNamed: "MyParticle")!
        emitter.position = CGPoint(x: size.width/2, y: size.height - 500)
        addChild(emitter)
        
        // Customize the emitter's properties
        emitter.particleBirthRate = 10000
        emitter.particleLifetime = 5
        emitter.particleLifetimeRange = 2
        emitter.particleColor = UIColor.purple
        emitter.particlePositionRange = CGVector(dx: view!.bounds.width, dy: 0)

        // Remove the emitter after 8 seconds
        let duration = 0.25
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            emitter.particleBirthRate = 0 // Stop the emitter from emitting new particles
        }

        // Remove the emitter after 5 seconds
        let removeDuration = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + removeDuration) {
            emitter.removeFromParent()
        }
    }
}
