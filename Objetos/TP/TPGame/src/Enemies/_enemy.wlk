import Common._ui.* 
import _utils.* 
import Engine._gameLoop.*
import Engine._gameVisual.*
import Enemies._index.waveManager
import Player._index.*
import Engine._scheduler.*

class Enemy inherits GameVisual(name = "enemy") {
    const speed
    const attackInterval
    const attackId = "attack" + id
    var property isAlive = true
    const image_name
    const property image = player.selectedPlayer().name() + "/" + image_name
    var property position = utils.getRandomPosOutOfScreenRight()
    var property health = 100
    const healthBar = new HealthBar(parent = self, yOffset = 20, xOffset = -20)

    method onStart() {
        healthBar.load()
        scheduler.every(attackInterval, attackId, {self.attack()})
    }

    method attack()

    method move()


    override method onUpdate() {
        self.move()
    }

    method stopMoving() {
        self.stopOnUpdate()
    }

   override method whenCollided(value) {
        health -= value
        if(health <= 0) {
            self.die()
        }
    }

    method die() {
        waveManager.destroyEnemy() 
        self.remove()
    }  

    override method remove() {
        super()
        healthBar.remove()
        scheduler.stop(attackId)
    }
}

