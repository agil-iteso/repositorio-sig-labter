# 🗺️ Sistema de Administración de Capas SIG para Estudiantes

**LABTER ITESO - PAP Territorio**

Este es un **repositorio colaborativo para estudiantes de planeación territorial** que permite:

✓ Trabajar con capas SIG que **heredan semestre a semestre**
✓ **Versionar** el trabajo por semestre
✓ **Visualizar** capas sin abrir QGIS (visor web gratuito, sin servidor propio)
✓ Escalar a **QGIS Server** o **GeoNode** cuando el proyecto crezca

---

## 🚀 Inicio Rápido (5 minutos)

### Para Estudiantes

```bash
# 1. Clona el repositorio
git clone https://github.com/agil-iteso/repositorio-sig-labter.git
cd repositorio-sig-labter

# 2. Abre QGIS y carga el proyecto base
qgis semestre-2026-2/qgis-projects/amg-base.qgs

# 3. Edita capas y haz cambios
# (sigue docs/02-guia-estudiantes.md)

# 4. Sube tus cambios
git add semestre-2026-2/datos/tu-tema/
git commit -m "Descripción de tus cambios"
git push origin main
```

### Para Profesores

```bash
# 1. Crear nuevo semestre (herencia automática)
./automatizar-versionado.sh crear-semestre 2027-1

# 2. Ver todas las capas disponibles
./automatizar-versionado.sh listar

# 3. Generar reporte de capas
./automatizar-versionado.sh reporte 2026-2

# 4. Congelar versión (al final del semestre)
./automatizar-versionado.sh crear-tag 2026-2
```

---

## 📁 Estructura del Repositorio

```
repositorio-sig-labter/
│
├── README.md                          ← LÉEME PRIMERO
├── CONTRIBUIR.md                      ← Guía para estudiantes
│
├── semestre-2026-2/                   ← ACTUAL
│   ├── qgis-projects/
│   │   └── amg-base.qgs              (Proyecto QGIS)
│   ├── datos/
│   │   ├── uso-suelo/                (Capas por categoría)
│   │   ├── limites-administrativos/
│   │   ├── infraestructura/
│   │   │   └── [nombre-capa]/
│   │   │       ├── [nombre-capa].geojson   ← el visor web lee esto
│   │   │       ├── [nombre-capa].shp (+ .dbf/.prj/.cpg)  ← respaldo GIS
│   │   │       └── README.md          (metadatos)
│   │   └── [tu nueva categoría]/
│   ├── metadatos.csv                 (Inventario)
│   └── CHANGELOG.md
│
├── [futuros semestres]/               [Heredan TODO del anterior + nuevas capas]
│
├── visor-web/                         Sitio web para ver capas (GitHub Pages)
│   ├── index.html
│   └── config.json                    (lista de capas visibles en el visor)
│
└── docs/
    ├── 00-CHECKLIST-MAESTRO.md
    ├── 01-instalacion-qgis-server.md  (Fase futura, opcional)
    ├── 02-guia-estudiantes.md
    ├── 03-migracion-a-geonode.md      (Fase futura, opcional)
    ├── 04-acceso-descentralizado-analisis.md
    └── 05-guia-rapida-estudiantes-ver-cambios.md
```

---

## 📚 Documentación

### Para Estudiantes

1. **[docs/02-guia-estudiantes.md](docs/02-guia-estudiantes.md)**
   - Cómo clonar, editar, subir cambios, exportar a GeoJSON
   - Solucionar problemas comunes
   - Workflow día a día

2. **[docs/05-guia-rapida-estudiantes-ver-cambios.md](docs/05-guia-rapida-estudiantes-ver-cambios.md)**
   - Cómo verificar que tus cambios aparecen en el visor web

### Para Profesores

1. **[automatizar-versionado.sh](automatizar-versionado.sh)**
   - Script para crear semestres (herencia)
   - Crear tags de versión final
   - Generar reportes

2. **[docs/03-migracion-a-geonode.md](docs/03-migracion-a-geonode.md)** y **[docs/01-instalacion-qgis-server.md](docs/01-instalacion-qgis-server.md)**
   - Fases futuras opcionales, solo relevantes cuando el proyecto crezca (40-50+ capas, rasters, edición simultánea)

---

## 🌐 Visor Web

Se publica gratis con **GitHub Pages**, sin necesidad de servidor propio. Una vez activado (Settings → Pages en tu repositorio de GitHub), la URL será:

**https://agil-iteso.github.io/repositorio-sig-labter/visor-web/**

**Características:**
- 📊 Visualizar las capas del semestre actual (lee `visor-web/config.json`)
- 🔍 Ver metadatos de cada capa (fuente, fecha, autor, escala)
- ✅ Se actualiza solo, unos segundos después de cada `git push`
- ⚠️ Solo capas vectoriales en formato GeoJSON (puntos, líneas, polígonos). Los rasters (ej. mapas de inundación en `.tif`) requieren la fase con servidor — ver `docs/01-instalacion-qgis-server.md`.

---

## 🔄 Versiones del Sistema

### Fase 0 (actual): GeoJSON + GitHub Pages — sin servidor

| Aspecto | Detalles |
|---------|----------|
| **Almacenamiento** | Archivos GeoJSON (+ shapefile de respaldo) en Git |
| **Publicación web** | GitHub Pages (gratis, automático) |
| **Control de versiones** | Git + GitHub |
| **Visor** | Leaflet (HTML ligero) |
| **Costo** | $0 |
| **Limitación** | Sin capas raster, sin edición simultánea en el mismo archivo |

### Fase 1 (opcional, cuando tengan servidor): QGIS Server + Git

Agrega publicación WMS/WFS, soporte de rasters y sincronización automática vía GitHub Actions. Ver `docs/01-instalacion-qgis-server.md`.

### Fase 2 (opcional, 50+ capas): GeoNode

Búsqueda avanzada, permisos por usuario, metadatos integrados, API REST. Ver `docs/03-migracion-a-geonode.md`.

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
- **Geometría**: Polígono/Línea/Punto

## Descripción
[Qué es esta capa, para qué sirve]

## Cambios respecto a versión anterior
[Si es una actualización, describe qué cambió]
```

Plantilla completa: [PLANTILLA-METADATA-capa.md](PLANTILLA-METADATA-capa.md)

---

## ❓ Preguntas Frecuentes

### P: ¿Puedo editar una capa vieja?
**R:** Sí. Abre en QGIS, edita, haz commit con mensaje descriptivo.

### P: ¿Qué pasa si otro estudiante edita lo mismo?
**R:** Git te avisará. Resuelven conflicto manualmente (ver `docs/02-guia-estudiantes.md`).

### P: ¿Necesito tener instalado PostGIS o un servidor?
**R:** No, en la Fase 0 actual todo vive en Git como archivos GeoJSON/shapefile. Un servidor solo es necesario si migran a la Fase 1 (QGIS Server) o Fase 2 (GeoNode).

### P: ¿Se ven las capas actualizadas en el visor web?
**R:** Sí, automáticamente unos segundos después de `git push` (GitHub Pages se reconstruye solo). Recuerda también agregar la capa a `visor-web/config.json`.

---

## 🤝 Contribuir

Ver [CONTRIBUIR.md](CONTRIBUIR.md).

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

**Versión**: 3.0 (GeoJSON + GitHub Pages, sin servidor)
**Semestre actual**: 2026-2

🎉 **¡Bienvenidos al SIG colaborativo!**
