import Engine._scheduler.*

object gameLoop {
    const fns = new Dictionary()
    
    method start() {
        scheduler.every(6, "game_loop", {fns.values().forEach({fn => fn.apply()})})
    }

    method stop() {
        scheduler.stop("game_loop")
    }
    
    method add(id, fn) {
        fns.put(id, fn)
    }

    method remove(id) {
        fns.remove(id)
    }

}
