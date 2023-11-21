import Enemies._enemy.*
import Player._index.*
import Engine._scheduler.*
import _constants.ENEMIES.melee

class Melee inherits Enemy(speed = melee.speed(), health = melee.health(), image_name = melee.imageName(), attackInterval = melee.attackInterval()) { 
    const damage = melee.damage()
    var shouldAttack = false 
    var shouldMoveOnY = true
    var moveOnY = speed

    override method attack() {
        if(position.distance(player.position()) <= 150) {
            position = position.left(100)
            scheduler.schedule(200, {position = position.right(100)})
        }
        return null
    }

    override method onCollideDo(visual) {
        if(visual.name() == "player")
            visual.whenCollided(damage)
    }

    method moveY() {
        const isPlayerOnTop = player.position().y() >= position.y()
        var yToMove = speed
        if(!isPlayerOnTop) yToMove = -1 * yToMove
        position = position.up(yToMove)
        moveOnY = yToMove
        shouldMoveOnY = false
        scheduler.schedule(melee.yMovementDelay(), {shouldMoveOnY = true})
    }

    override method move() {
        if(position.x() >= melee.moveUntil()) 
            position = position.left(speed)
        if(shouldMoveOnY)
            self.moveY()
        else 
            position = position.up(moveOnY)
    }
}