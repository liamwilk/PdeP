import _utils.*
import Engine._gameLoop.*
import Engine._gameVisual.*
import Player._index.*

class Bullet inherits GameVisual(name = "bullet"){
    var property position
    const speed
    const damage
    const vxScaler = 1
    const vyScaler = 0
    const image_name
    const property image = player.selectedPlayer().name() + "/" + image_name

    override method onUpdate() {
        if(position.x() >= game.width() + 50 || position.x() <= -20) {
           self.remove()
        } 
        position = position.right(vxScaler*speed).up(vyScaler*speed)
    }
}

