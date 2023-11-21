import Engine._scheduler.*
import Engine._gameVisual.*
import Player._index.*
import Common._ui.*
import Common._bullet.*
import _constants.PLAYER.*
import _constants.COLORS

class Gun {
    const property name = {}
    const property weight
    var property bulletsLeft
    const delayBetweenShots
    var shouldShoot = true

    method shoot(fn) {
        if(shouldShoot || bulletsLeft > 0){
            shouldShoot = false
            scheduler.schedule(delayBetweenShots, {shouldShoot = true})
            bulletsLeft -=  1
            fn.apply()
        }
    }
}

class PlayerBullet inherits Bullet {
    override method onCollideDo(visual) {
        if(visual.name() === "enemy") {
            visual.whenCollided(damage)
            self.remove()
        }
    }  
}

class BulletsUI inherits GameVisual(name = "bulletsUI") {
    const weapon
    const property position

    method text() = weapon.name().apply() + ": " + weapon.bulletsLeft()
    method textColor() = COLORS.gold
}


// ============ Guns definitions ============
object shotgun inherits Gun(weight = shotgunConsts.weight(), name = {player.selectedPlayer().shotgun()}, bulletsLeft = shotgunConsts.bullets(), delayBetweenShots = shotgunConsts.delayBetweenShots()) {
    override method shoot(x) {
        super({
            new PlayerBullet(position = player.position(), speed = shotgunConsts.speed(), vxScaler = shotgunConsts.vxScaler(), vyScaler = shotgunConsts.vyScaler(), damage = shotgunConsts.damage(), image_name = shotgunConsts.bulletImage()).load()
            new PlayerBullet(position = player.position(), speed = shotgunConsts.speed(), damage = shotgunConsts.damage(), image_name = shotgunConsts.bulletImage()).load()
            new PlayerBullet(position = player.position(), speed = shotgunConsts.speed(), vxScaler = shotgunConsts.vxScaler(), vyScaler = -shotgunConsts.vyScaler(), damage = shotgunConsts.damage(), image_name = shotgunConsts.bulletImage()).load()
            game.sound(player.selectedPlayer().name() + shotgunConsts.sound()).play()
        })
    }
}

object heavy inherits Gun(weight = heavyConsts.weight(), name = {player.selectedPlayer().heavy()}, bulletsLeft = heavyConsts.bullets(), delayBetweenShots = heavyConsts.delayBetweenShots()) {
    override method shoot(x) {
        super({new PlayerBullet(position = player.position(), speed = heavyConsts.speed(), damage = heavyConsts.damage(), image_name = heavyConsts.bulletImage()).load()
        game.sound(player.selectedPlayer().name() + heavyConsts.sound()).play()})
    }
}

object scar inherits Gun(weight = scarConsts.weight(), name = {player.selectedPlayer().scar()}, bulletsLeft = scarConsts.bullets(), delayBetweenShots = scarConsts.delayBetweenShots()) {
    override method shoot(x) {
        super({new PlayerBullet(position = player.position(),  speed = scarConsts.speed(), damage = scarConsts.damage(), image_name = scarConsts.bulletImage()).load()
        game.sound(player.selectedPlayer().name() + scarConsts.sound()).play()})
    }
}