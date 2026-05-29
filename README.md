# Estructura para la resolución de Problemas de satisfacción de restricciones (CSP)

Librería robusta y optimizada en Dart para modelar y resolver problemas CSP.

## Características principales

- **Abstracción Genérica**: Soporte para variables (`CspVariable<T>`) y valores (`CspValue<T>`) de cualquier tipo.
- **Restricciones Predefinidas**: Incluye restricciones binarias (`NotEqualConstraint`, `EqualConstraint`), numéricas/strings y la restricción global **`AllDifferentConstraint`** para asegurar valores únicos en un conjunto de variables.
- **Núcleo Optimizado**:
  - Gestión de dominios mediante programación funcional.
  - Tipado fuerte y seguridad contra nulos (Null Safety).
  - Soporte para **Max-CSP**: En caso de insuficiencia de recursos o conflictos insolubles, el sistema devuelve la mejor solución parcial consistente encontrada.
- **Herramientas de Depuración**: Modo *verbose* para trazar el algoritmo de búsqueda (Backtracking + AC3).

## Ejemplos incluidos

### 1. Coloreado de Mapas
Resolución del clásico problema de colorear regiones geográficas (ej. Australia) sin que regiones adyacentes compartan color.

### 2. Gestión de Tareas (Gantt)
Planificación de tareas con restricciones de precedencia temporal y asignación de recursos.

### 3. Asignación de Asientos (Seat Path)
Modelado complejo de asignación de personas a asientos considerando:
- **Grupos**: Asientos pertenecientes a categorías (VIP, Estándar).
- **Vecindad**: Restricciones de proximidad (junto a, no junto a).
- **Carga dinámica**: Configuración completa del problema (personas, grupos, asientos y restricciones) mediante un único archivo JSON con validación de coherencia.
- **Gestión de escasez**: Identificación de personas que se quedan sin asiento si la oferta es menor que la demanda (Max-CSP).

## Ejecución desde CLI

El proyecto incluye una herramienta de línea de comandos para probar los ejemplos:

```bash
# Ver ayuda y opciones
dart bin/main.dart -h

# Ejecutar ejemplo de mapas (Ejemplo 1)
dart bin/main.dart -e 1

# Ejecutar ejemplo de asientos (Ejemplo 3) con configuración JSON y log de búsqueda
dart bin/main.dart -e 3 -f config_asientos.json -v

# Ejemplo 3 con carga de datos desde un único archivo JSON
dart bin/main.dart -e 3 -f config_asientos.json
```

### Formato del archivo JSON (Ejemplo 3)

El archivo debe contener las secciones `people`, `groups`, `seats` y `constraints`. El sistema verificará la coherencia de los IDs y las referencias entre objetos.

```json
{
  "people": [
    { "id": 1, "name": "Alice" }
  ],
  "groups": [
    { "id": 1, "name": "VIP" }
  ],
  "seats": [
    { "id": 1, "name": "A1", "groupIds": [1], "nextToIds": [2] }
  ],
  "constraints": [
    { "type": "isNextTo", "v1": 1, "v2": 2 },
    { "type": "isNotInGroup", "person": 3, "groupId": 1 }
  ]
}
```

## Uso Básico del API

```dart
// 1. Definición de variables y dominios
var v1 = CspVariable(model: "Persona A");
var domain = CspDomain(values: [CspValue(model: "Asiento 1")]);

// 2. Creación del problema
var csp = Csp<CspVariable, CspValue>();
csp.addVariable(v1);
csp.setDomain(v1, domain);

// 3. Añadir restricciones
csp.addConstraint(NotEqualConstraint(v1, v2));

// 4. Resolver
var solver = FlexibleBacktrackingSolver(
  heuristics: Heuristics(
    variableSelectionStrategy: MinimumRemainingValuesHeuristic(),
    valueOrderingStrategy: LeastConstrainingValueHeuristic()
  ),
  inferenceStrategy: AC3Strategy()
);

var solution = solver.solve(csp);
```
