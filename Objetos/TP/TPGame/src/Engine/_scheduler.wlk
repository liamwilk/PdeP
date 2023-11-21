import wollok.game.*
import _utils.*

// Creating our own wrapper for the fns: game.schedule, game.onTick and so
// Reasons is: we want to have only one game.onTick for animations, movement and anything that needs to be renderer in 60 frames (a game loop ultimately)
// And then, game.schedule seems to not be working very well on the wollok-ts implementation 
object scheduler {
    method every(ms, id, fn) {
        game.onTick(ms * 10, id, fn)
    }

    method stop(id) {
        game.removeTickEvent(id)
    }

    // Workround for the game.schedule which, again, seems to not be working
    method schedule(ms, fn) {
        const id = utils.generateRandomId()
        game.onTick(ms * 10, id, {fn.apply() self.stop(id)})
    }
}