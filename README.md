# 🗺️ Sistema de Administración de Capas SIG para Estudiantes

**ITESO - Instituto Metropolitano de Planeación**

Este es un **repositorio colaborativo para estudiantes de planeación territorial** que permite:

✓ Trabajar con capas SIG que **heredan semestre a semestre**  
✓ **Versionar** el trabajo por semestre  
✓ **Visualizar** capas sin abrir QGIS  
✓ Escalar a **GeoNode** cuando tengas 50+ capas  

---

## 🚀 Inicio Rápido (5 minutos)

### Para Estudiantes

```bash
# 1. Clona el repositorio
git clone https://github.com/ITESO/repositorio-sig-iteso.git
cd repositorio-sig-iteso

# 2. Abre QGIS y carga el proyecto base
qgis semestre-2024-2/qgis-projects/amg-base.qgs

# 3. Edita capas y haz cambios
# (sigue guía-estudiantes.md)

# 4. Sube tus cambios
git add semestre-2024-2/datos/tu-tema/
git commit -m "Descripción de tus cambios"
git push origin main
```

### Para Profesores

```bash
# 1. Crear nuevo semestre (herencia automática)
./automatizar-versionado.sh crear-semestre 2025-1

# 2. Ver todas las capas disponibles
./automatizar-versionado.sh listar

# 3. Generar reporte de capas
./automatizar-versionado.sh reporte 2024-2

# 4. Congelar versión (al final del semestre)
./automatizar-versionado.sh crear-tag 2024-2
```

---

## 📁 Estructura del Repositorio

```
repositorio-sig-iteso/
│
├── README.md                          ← LÉEME PRIMERO
├── CONTRIBUIR.md                      ← Guía para estudiantes
│
├── semestre-2024-1/                   ✓ Versión congelada
│   ├── qgis-projects/
│   │   └── amg-base.qgs              (Proyecto QGIS)
│   ├── datos/
│   │   ├── uso-suelo/                (Capas por categoría)
│   │   ├── limites-administrativos/
│   │   └── infraestructura/
│   ├── metadatos.csv                 (Inventario)
│   └── CHANGELOG.md
│
├── semestre-2024-2/                   ← ACTUAL
│   ├── qgis-projects/
│   └── datos/
│       ├── uso-suelo/
│       ├── limites-administrativos/
│       ├── infraestructura/
│       ├── analisis-riesgo/           (NUEVO este semestre)
│       └── servicios-publicos/        (NUEVO este semestre)
│
├── semestre-2025-1/                   (Futura)
│   └── [Hereda TODO de 2024-2 + nuevas capas]
│
├── visor-web/                         Sitio web para ver capas
│   ├── index.html
│   ├── config.json
│   └── css/, js/
│
└── docs/
    ├── 01-instalacion-qgis-server.md
    ├── 02-guia-estudiantes.md
    ├── 03-migracion-a-geonode.md
    └── automatizar-versionado.sh
```

---

## 📚 Documentación

### Para Estudiantes

1. **[guia-estudiantes.md](02-guia-estudiantes.md)**
   - Cómo clonar, editar, subir cambios
   - Solucionar problemas comunes
   - Workflow día a día

### Para Profesores

1. **[instalacion-qgis-server.md](01-instalacion-qgis-server.md)**
   - Instalar QGIS Server (local o servidor)
   - Configurar Apache + FastCGI
   - Publicar proyectos como WMS/WFS

2. **[automatizar-versionado.sh](automatizar-versionado.sh)**
   - Script para crear semestres (herencia)
   - Crear tags de versión final
   - Generar reportes

3. **[migracion-a-geonode.md](03-migracion-a-geonode.md)**
   - Plan para migrar a GeoNode (Fase 2)
   - Importar capas existentes
   - Configurar permisos por semestre

---

## 🎯 Flujo de Trabajo Típico

### Semestre 1: Preparación

```
1. Profesor: Instala QGIS Server
2. Profesor: Crea proyecto QGIS base (limites, uso suelo)
3. Profesor: Crea carpeta semestre-2024-1 en Git
4. Estudiantes: Clonan repo
5. Estudiantes: Editan/agregan capas
6. Profesor: Publica en visor web
7. Profesor: Git tag v2024-1-final
```

### Semestre 2: Herencia + Nuevas Capas

```
1. Profesor: ./automatizar-versionado.sh crear-semestre 2024-2
   → Copia TODO de 2024-1
   → Crea carpeta semestre-2024-2 con estructura lista
   
2. Estudiantes: Heredan capas 2024-1 + crean nuevas
   - Ya tienen 100% del trabajo anterior
   - Solo agregan/editan (no duplican)
   
3. Profesor: ./automatizar-versionado.sh crear-tag 2024-2
   → Congela versión para semestre siguiente
```

### Semestre 3 y Adelante

```
Semestre N hereda TODO de (N-1)
→ Se acumula repositorio completo
→ Disponible en Git histórico + visor web
```

---

## 🌐 Visor Web

Accede en: **http://sig.tu-dominio.local**

**Características:**
- 📊 Visualizar todas las capas del semestre actual
- 📅 Cambiar a versiones anteriores
- 🔍 Buscar capas por nombre/categoría
- 📥 Descargar shapefiles/GeoJSON
- ℹ️ Ver metadatos de cada capa

---

## 🔄 Versiones

### Sistema Actual: QGIS Server + Git (Fase 1)

| Aspecto | Detalles |
|---------|----------|
| **Base de datos** | Archivos shapefile |
| **Servidor web** | QGIS Server (WMS/WFS) |
| **Control de versiones** | Git + GitHub |
| **Visor** | Leaflet (HTML ligero) |
| **Costo** | $0 (open source) |
| **Mantenimiento** | Bajo |
| **Escalabilidad** | Hasta ~200 capas |

### Sistema Futuro: GeoNode (Fase 2)

Cuando acumules 50+ capas y necesites:
- Búsqueda avanzada
- Permisos automáticos por usuario
- Metadatos integrados
- API REST profesional

Ver: [03-migracion-a-geonode.md](03-migracion-a-geonode.md)

---

## 📝 Metadatos Obligatorios

**Cada capa debe tener un README.md** con:

```markdown
# Capa: [Nombre]

- **Fuente**: [INEGI, CONAGUA, levantamiento campo, etc.]
- **Fecha**: YYYY-MM
- **Autor**: Nombre del estudiante
- **Escala**: 1:50,000
- **Proyección**: EPSG:32613 (UTM zona 13)
- **Geometría**: Polígono/Línea/Punto/Raster

## Descripción
[Qué es esta capa, para qué sirve]

## Cambios respecto a versión anterior
[Si es una actualización, describe qué cambió]
```

Plantilla completa: [PLANTILLA-METADATA-capa.md](../PLANTILLA-METADATA-capa.md)

---

## ❓ Preguntas Frecuentes

### P: ¿Puedo editar una capa vieja?
**R:** Sí. Abre en QGIS, edita, haz commit con mensaje descriptivo.

### P: ¿Qué pasa si otro estudiante edita lo mismo?
**R:** Git te avisará. Resuelven conflicto manualmente (ver guia-estudiantes.md).

### P: ¿Cómo descargo una capa de un semestre anterior?
**R:** `git checkout v2024-1-final` y copia el archivo que quieras.

### P: ¿Necesito tener instalado PostGIS?
**R:** **Fase 1 (ahora)**: No. Git almacena shapefiles directamente.  
**Fase 2 (futuro)**: Sí. PostGIS será el backend de GeoNode.

### P: ¿Se ven las capas actualizadas en el visor web?
**R:** Después de git push, profesor ejecuta script de sincronización (cada 30 min automático).

---

## 📊 Estadísticas Esperadas

| Métrica | Fase 1 (Año 1) | Fase 2 (Año 2+) |
|---------|-------|-------|
| Capas acumuladas | 20-40 | 50-200 |
| Estudiantes por semestre | 15-30 | 30-60 |
| Tamaño repositorio | 500 MB | 2-5 GB |
| Usuarios activos | Estudiantes + profesor | Escuela + público |

---

## 🤝 Contribuir

1. Clona el repositorio
2. Crea rama para tu trabajo: `git checkout -b mi-capa`
3. Haz cambios y documenta con README.md
4. Commit: `git commit -m "Descripción"`
5. Push: `git push origin mi-capa`
6. Abre Pull Request (profesor revisa)

---

## 📞 Soporte

- **Profesor**: [correo]
- **Issues en GitHub**: Abre un issue con tu pregunta
- **Documentación técnica**: Ver carpeta `/docs`

---

## 📄 Licencia

Todas las capas heredan licencia de sus fuentes originales (INEGI, CONAGUA, etc.).  
Documentación: CC-BY-SA 4.0

---

**Versión**: 2.0 (QGIS Server + Git)  
**Última actualización**: 2024-10-XX  
**Próxima: GeoNode (Fase 2) - 2025**

🎉 **¡Bienvenidos al SIG colaborativo!**
