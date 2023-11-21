import Player._index.*

package COLORS {
    const green = "#008000" 
    const yellow = "#ffff00" 
    const red = "#ff0000" 
    const lightBlue = "#478fd1" 
    const gold = "#fcbf45" 
}

package PLAYER {
    object massa {
        const property name = "massa"
        const property shotgun = "Choripanes"
        const property scar = "Bananas"
        const property heavy = "Polenta"
    }

    object milei {
        const property name = "milei"
        const property shotgun = "Organos"
        const property scar = "Bananas"
        const property heavy = "Motosierra"
    }

    const players = [massa, milei]

    const speed = 30 / player.weapon().weight()
    const health = 100
    const imageName = "player.png"

    object shotgunConsts {
        const property bulletImage = "multiple.png"
        const property sound = "/multiple.mp3"
        const property weight = 12
        const property bullets = 15
        const property delayBetweenShots = 500
        const property speed = 9
        const property damage = 40
        const property vxScaler = 0.9
        const property vyScaler = 0.15
    }

    object heavyConsts {
        const property bulletImage = "heavy-bullet.png"
        const property sound = "/heavy.mp3"
        const property weight = 20
        const property bullets = 10
        const property delayBetweenShots = 1000
        const property speed = 7
        const property damage = 100
    }

    object scarConsts {
        const property bulletImage = "fast-bullet.png"
        const property sound = "/fast.mp3"
        const property weight = 10
        const property bullets = 30
        const property delayBetweenShots = 500
        const property speed = 15
        const property damage = 25
    }
}

package ENEMIES {
    object melee {
        const property imageName = "melee.png"
        const property health = 50
        const property yMovementDelay = 500
        const property damage = 5
        const property speed = 5
        const property moveUntil = 100
        const property attackInterval = 5000
    }

    object turret {
        const property imageName = "turret.png"
        const property bulletImageName = "turret_bullet.png"
        const property health = 100
        const property damage = 25
        const property speed = 4
        const property moveUntil = 200
        const property attackInterval = 4000
        const property bulletSpeed = 8
    }

    object sniper {
        const property imageName = "sniper.png"
        const property bulletImageName = "sniper_bullet.png"
        const property health = 100
        const property damage = 30
        const property speed = 4
        const property moveUntil = 200
        const property attackInterval = 5000
        const property bulletSpeed = 4
    }
}