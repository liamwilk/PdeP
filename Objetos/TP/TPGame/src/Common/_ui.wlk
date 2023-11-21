import _constants.COLORS.*
import Engine._gameVisual.*

/**
* @param parent: expects a visual 
*/
class HealthBar inherits GameVisual(name = "HealthBarUI") {
    const parent
    // This defines how up should the bar be. 
    // This has to be provided by each object since  there is no way to know the height of it and as so define how up to it should be 
    const yOffset
    const xOffset
    
    method position() = parent.position().right(xOffset).up(yOffset)

    method text() = parent.health().toString()

    method textColor() {
        if(parent.health() > 75) return green
        if(parent.health() < 25) return red
        return yellow
    }
}