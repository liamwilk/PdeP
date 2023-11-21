import Construcciones.*
import Planetas.*

class Persona {
	
	var recursos = 20
	var edad
	var planeta
	
	method condicionEdad() = edad.between(18,65)
	
	method cantidadAnos() = edad
	
	method planetaActual() = planeta
	
	method cambiarPlaneta(nuevoPlaneta){
		
		planeta = nuevoPlaneta
	}
	
	method cantidadRecursos() = recursos
	
	method condicionRecursos() = recursos > 30

	method trabajar(planetaATrabajar, tiempo) {}
	
	method esDestacada() = self.condicionEdad() or self.condicionRecursos()
	
	method cumplirAnos() {
		
		edad += 1
		
	}
	
	method ganarMonedas(cantidad) {
		
		recursos += cantidad
	}
	
	method gastarMonedas(cantidad) {
		
		if(recursos >= cantidad) {
			
			recursos -= cantidad
		} else throw new Exception(message = "No alcanzan los fondos")
	}
}

class Productor inherits Persona {
	
	const tecnicas = ["cultivo"]
	
	method cantidadTecnicasConocidas() = tecnicas.size()
	
	method conoceTecnica(tecnica) = tecnicas.contains(tecnica)
	
	override method cantidadRecursos() = recursos *	self.cantidadTecnicasConocidas()
	
	override method esDestacada() = super() or self.cantidadTecnicasConocidas() > 5
	
	method ultimaTecnica() = tecnicas.last()
	
	method realizarTecnica(tiempo, tecnica) {
		
		if(self.conoceTecnica(tecnica)) {
			
			const cantidadGanadas = 3 * tiempo
			
			self.ganarMonedas(cantidadGanadas)
			
		} else self.gastarMonedas(1)
		
	}
	
	method aprenderTecnica(tecnica) = tecnicas.add(tecnica)
	
	override method trabajar(planetaATrabajar, tiempo) {
		
		if(self.planetaActual() == planeta) {
			
			self.realizarTecnica(tiempo, self.ultimaTecnica())
			
		} else throw new Exception(message = "No puede realizar la técnica ya que no vive en ese Planeta")
		
	}
}

class Constructor inherits Persona {
	var cantidadConstrucciones
	var regionPlaneta
	
	method cuantasConstruccionesHizo() = cantidadConstrucciones
	
	override method cantidadRecursos() = recursos + (10 * cantidadConstrucciones)
	
	override method esDestacada() = cantidadConstrucciones > 5
	
	override method trabajar(planetaATrabajar, tiempo) {
		
		self.gastarMonedas(5)
		
		regionPlaneta.construye(planeta, tiempo, self)
		
		cantidadConstrucciones += 1
	}
	
	method condicionesParaConstruirEnPlaya() = cantidadConstrucciones > 8
	
}

object montania {
	
	method construye(planeta, tiempo, persona) {
		
		const murallaNueva = new Muralla(longitud = tiempo / 2)
		
		planeta.agregarConstruccion(murallaNueva)
		
		}
}

object costa {
	
	method construye(planeta, tiempo, persona) {
		
		const museoNuevo = new Museo(indiceImportancia = 1, superficieCubierta = tiempo)
		
		planeta.agregarConstruccion(museoNuevo)
		}
}

object llanura {
	
	method construye(planeta, tiempo, persona) {
		
		if(not(persona.esDestacada())) {
			
			const murallaNueva = new Muralla(longitud = tiempo / 2)
			
			planeta.agregarConstruccion(murallaNueva)
			
		} else {
			
			const proporcion = persona.cantidadRecursos() / 3
			const museoNuevo = new Museo(superficieCubierta = tiempo, indiceImportancia = proporcion)
			
			planeta.agregarConstruccion(museoNuevo)
		}
	}
}

object playa {
	
	method construye(planeta, tiempo, persona) { 
		
		if(persona.condicionesParaConstruirEnPlaya()) {
			
			const murallaNueva = new Muralla(longitud = tiempo / 3)
			
			planeta.agregarConstruccion(murallaNueva)
		}
		
	}
}

