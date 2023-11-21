import Enemies._enemy.*
import _utils.*
import Enemies._index.*
import Engine._gameLoop.*
import Engine._scheduler.*
import Player._index.*
import Common._bullet.*
import _constants.ENEMIES.*

class Shooter inherits Enemy {
    const moveUntil
    
    override method move() {
        position = position.left(speed)
        if(position.x() <= game.width() - moveUntil) {
            self.stopMoving()
            self.attack()
        }
    }
}

class EnemyBullet inherits Bullet {
    override method onCollideDo(visual) {
        if(visual.name() == "player") {
            visual.whenCollided(damage)
            self.remove()
        }
    }
}

class Sniper inherits Shooter(image_name = sniper.imageName(), speed = sniper.speed(),  moveUntil = sniper.moveUntil(), attackInterval = sniper.attackInterval()) {
    override method attack() {
        // From the cinematic equations of the player and bullet we can solve the y velocity in order to hit the player
        // I guess cinematcis were important after all...
        const vyScaler = -(player.position().y() - position.y()) / ((player.position().x() - position.x()) / 5)
        new EnemyBullet (damage = sniper.damage(), speed = sniper.bulletSpeed(), image_name = sniper.bulletImageName(), vyScaler = vyScaler, vxScaler = -3, position = position.left(10)).load()
    }
}

// They only shoot ahead, witouth pointing to the player
class Turret inherits Shooter(image_name = turret.imageName(), speed = turret.speed(), moveUntil = turret.moveUntil(), attackInterval = turret.attackInterval()) {
    override method attack() {
        new EnemyBullet (damage = turret.damage(), speed = turret.speed(), vxScaler = -1, image_name = sniper.bulletImageName(), position = position.left(10)).load()
    }
}

