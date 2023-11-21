import _utils.*
import Engine._gameLoop.*

// Any visual should inherit this class. This way, we can define common behaviours between them
class GameVisual {
    const property name
    const property id = utils.generateRandomId()

    method load() {
        self.onStart()
        game.addVisual(self)
        gameLoop.add("on_update" + name + id, {self.onUpdate()})
    }

    // Runs when visual first gets added
    method onStart(){}

    //Runs every frame, with the game loop
    method onUpdate() {}

    method stopOnUpdate() {
        gameLoop.remove("on_update" + name + id)
    }

    method whenCollided(value) {}

    method onCollideDo(visual) {}
    
    method remove() {
        self.stopOnUpdate()
        game.removeVisual(self)
    }
}
