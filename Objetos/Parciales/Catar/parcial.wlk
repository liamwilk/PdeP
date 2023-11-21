class Plato {
    var property cocinero
    method cantAzucar()
    method cantCalorias() = 3 * (self.cantAzucar() + 100)

    method esBonito()
}

class Entrada inherits Plato{
    override method cantAzucar() = 0
    
    override method esBonito() = true
}

class Principal inherits Plato{
    const property cantAzucar
    var property esBonito

    override method cantAzucar() = cantAzucar
}

class Postre inherits Plato{
    var property cantColores

    override method cantAzucar() = 120
    override method esBonito() = cantColores > 3
}

class Cocinero {
    var property especialidad
    
    method cambiarEspecialidad(nuevaEspec){
        self.especialidad(nuevaEspec)
    }
    method cocinar() = especialidad.cocinar(self)
    method calificacionPlato(plato) = especialidad.catar(plato)
}

class Pastelero{
    var property nivelDulzor

    method catar(plato) = (5*(plato.cantAzucar() / self.nivelDulzor())).min(10)
    method cocinar(cocinero) = new Postre(cocinero = cocinero, cantColores = (self.nivelDulzor() / 50))
}

class Chef{
    var property cantCalorias

    method cumpleExpectativas(plato) = plato.esBonito() && plato.cantCalorias() <= self.cantCalorias()
    method catar(plato){
        if (self.cumpleExpectativas(plato))
        {
            return 10
        } else return 0
    }
    method cocinar(cocinero) = new Principal(cocinero = cocinero, cantAzucar = self.cantCalorias(), esBonito = true)
}

class SousChef inherits Chef {

    override method catar(plato) {
        if(self.cumpleExpectativas(plato)){
            return super(plato)
        } else return (plato.cantCalorias() / 100).min(6)
    }
    override method cocinar(cocinero) = new Entrada(cocinero = cocinero)
}

class Torneo {
    const property catadores = []
    const property platosPresentados = []


    method sumarParticipacion(cocinero){
        platosPresentados.add(cocinero.cocinar())
    }
    method sumaCalificacionesCatador(plato){
        catadores.sum({catador => catador.catar(plato)})
    }
    method ganador(){
        if(self.platosPresentados().isEmpty()){
            throw new Exception(message = "No hay platos")
        } else return self.platosPresentados().max({plato => self.sumaCalificacionesCatador(plato)}).cocinero()
    }
}