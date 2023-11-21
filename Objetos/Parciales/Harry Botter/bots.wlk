class Bot {
	var cargaElectrica
	var property tipoAceite
	
	method tieneXTipoAceite(aceite) = tipoAceite == aceite
	
	method CargaActual() = cargaElectrica
	
	method cambiarAceite(){
		tipoAceite.cambiar(self)
	}
	
	method estadoInactivo() = cargaElectrica == 0
	
	method restarCargaElectrica(valor) = cargaElectrica - valor
	
	method anularCargaElectrica() {
		cargaElectrica = 0
	}
	
	method cargaElectricaMayorAX(cantidad) = cargaElectrica > cantidad
}

object aceiteSucio {
	
	method cambiar(bot){
		bot.aceite(aceitePuro)
	}
}

object aceitePuro {
	
	method cambiar(bot){
		bot.aceite(aceiteSucio)
	}
}

class Estudiante inherits Bot {
	var casa
	const hechizos = []
	
	
	method asignarCasa(casaDada){
		casa = casaDada
	}
	
	method casaActualEsPeligrosa() = casa.esPeligrosa()
	
	method agregarHechizo(hechizo) = hechizos.add(hechizo)
	
	method ultimoHechizo() = hechizos.last()
	
	method tieneHechizo(hechizo) = hechizos.contains(hechizo)
	
	method sabeMasDeXCantidadHechizos(cantidad) = hechizos.size() > cantidad
	
	method condicionesParaSerExperimentado() = self.sabeMasDeXCantidadHechizos(3) && self.cargaElectricaMayorAX(50)
	
	method esExperimentado() = self.condicionesParaSerExperimentado()
	
	method lanzarHechizo(receptor, hechizo) { //Punto 4
		
		if(self.tieneHechizo(hechizo) && hechizo.cumpleRequisitos(self)) {
			
			hechizo.consecuencias(receptor)
		}
	}
}

class Profesor inherits Estudiante {
	const materiasDadas = []
	
	method agregarMateria(materia) = materiasDadas.add(materia)
	
	override method restarCargaElectrica(valor) = cargaElectrica
	
	override method anularCargaElectrica() {
		
	 	cargaElectrica  = cargaElectrica / 2
	 }
	
	method cantidadMaterias() = materiasDadas.size()
	
	override method esExperimentado() = super() && self.cantidadMaterias() >= 2
	
	method crearMateria() = new Materia(profesor = self, hechizoAAprender = hechizos.anyOne()) //Punto 2
	
}

object sombrero inherits Bot (cargaElectrica = 15, tipoAceite = aceitePuro){
	const casasActuales = [gryffindor, slytherin, ravenclaw, hufflepuff]
	
	override method cambiarAceite() {
	}
	
	method determinarCasa(estudiante) = estudiante.asignarCasa(self.casaConMayorPrioridad())
	
	method casaConMayorPrioridad() {
		
		self.reordenarCasas()
		return casasActuales.first()
	}
	
	method reordenarCasas() {
		
		casasActuales.sortedBy({casa => casa.cantidadIntegrantes()})
	}
	
	method distribuirEstudiantes(estudiantes) {  //PUNTO 1
		
		estudiantes.forEach({estudiante => self.determinarCasa(estudiante)})
		
	}
}

class Casa {
	const integrantes = []
	
	method esPeligrosa()
	
	method cantidadIntegrantes() = integrantes.size()
	
	method integrantesPorTipoAceite(aceite) = integrantes.filter({integrante => integrante.tieneXTipoAceite(aceite)})
	
	method cantidadIntegrantesPorAceite(aceite) = self.integrantesPorTipoAceite(aceite).size()
	
	method masAceiteSucioQuePuro() = self.cantidadIntegrantesPorAceite(aceiteSucio) > self.cantidadIntegrantesPorAceite(aceitePuro)
	
	method lanzarUltimoHechizo(botImpronunciable) { //Punto 5
		
		integrantes.forEach({integrante => integrante.lanzarHechizo(botImpronunciable, integrante.ultimoHechizo())})
	}
}

object gryffindor inherits Casa{
	
	override method esPeligrosa() = false
}

object slytherin inherits Casa{
	
	override method esPeligrosa() = true
}

object ravenclaw inherits Casa{
	
	override method esPeligrosa() = self.masAceiteSucioQuePuro()
}

object hufflepuff inherits Casa{
	
	override method esPeligrosa() = self.masAceiteSucioQuePuro()
}

class Materia {
	const profesor
	var hechizoAAprender
	
	method sumarMateriaAProfesor() = profesor.agregarMateria(self)
	
	method hechizoDeClase() = hechizoAAprender
	
	method estudiantesAprendenHechizo(estudiantes) { //Punto 3
		
		estudiantes.forEach({estudiante => estudiante.agregarHechizo(self.hechizoDeClase())})
	}
}

class Hechizo {
	
	method consecuencias(receptor)
	
	method requisitos(atacante) = atacante.tieneHechizo(self) && !atacante.estadoInactivo()
	
	method requisitosAdicionales(atacante)
	
	method cumpleRequisitos(atacante) = self.requisitos(atacante) && self.requisitosAdicionales(atacante)
}

class Inmobilus inherits Hechizo {

	override method consecuencias(receptor){
		receptor.restarCargaElectrica(50)
	}
}

class SectumSempra inherits Hechizo {
	
	override method requisitosAdicionales(atacante) = atacante.esExperimentado()
	
	override method consecuencias(receptor) {
		if (receptor.tieneXTipoAceite(aceitePuro)) {
			
			receptor.cambiarTipoAceite(aceiteSucio)
		}
	}
}

class Avadakedabra inherits Hechizo {
	
	method atacanteEstaEnCasaPeligrosa(atacante) = atacante.casaActualEsPeligrosa()
	
	override method requisitosAdicionales(atacante) = atacante.tieneXTipoAceite(aceiteSucio)|| self.atacanteEstaEnCasaPeligrosa(atacante)
	
	override method consecuencias(receptor) {
		
		receptor.anularCargaElectrica()
	}
}

class HechizoComun inherits Hechizo {
	var cantidadADisminuir
	
	override method requisitosAdicionales(atacante) = atacante.cargaActual() > cantidadADisminuir
	
	override method consecuencias(receptor) = receptor.restarCargaElectrica(cantidadADisminuir)
}

class HechizoContrario inherits Hechizo {
	
	override method consecuencias(receptor){
		
		if (receptor.tieneXTipoAceite(aceiteSucio)) {
			
			receptor.cambiarAceite(aceitePuro)
		}
	}
}