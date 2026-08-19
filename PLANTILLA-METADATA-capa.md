# Metadatos de Capa: [NOMBRE DE LA CAPA]

**Copiar esta plantilla a cada carpeta de datos y completar antes de hacer commit.**

---

## Información General

| Campo | Valor |
|-------|-------|
| **Nombre de la capa** | Ej: `uso-suelo-2024` |
| **Tipo de geometría** | Polígono / Línea / Punto / Raster |
| **Formato de archivo** | Shapefile / GeoTIFF / GeoJSON / etc. |
| **Sistema de referencia** | EPSG:4326 (WGS84) / EPSG:32613 (UTM zona 13) |
| **Semestre** | 2024-2 |

---

## Fuente de Datos

| Campo | Valor |
|-------|-------|
| **Fuente original** | Ej: INEGI, CONAGUA, levantamiento de campo |
| **Año de captura/procesamiento** | 2024 |
| **URL de referencia** | [Si aplica] |
| **Licencia** | Abierta / CC-BY-SA / Restringida / etc. |

---

## Procesamiento

| Campo | Valor |
|-------|-------|
| **Descripción del proceso** | Ej: "Descarga de INEGI + rasterización a 30m de resolución" |
| **Transformaciones aplicadas** | Ej: "Reproyección a EPSG:32613, remuestreo bilineal" |
| **Datos faltantes o limitaciones** | Ej: "No cubre zona montañosa norte" |
| **Precisión/Exactitud** | Ej: "±50m horizontalmente" |

---

## Responsables

| Campo | Valor |
|-------|-------|
| **Autor/Estudiante** | Nombre del estudiante |
| **Correo de contacto** | estudiante@iteso.mx |
| **Profesor responsable** | Nombre del profesor |
| **Fecha de creación** | YYYY-MM-DD |
| **Última actualización** | YYYY-MM-DD |

---

## Atributos de la capa

Describe las columnas principales de la tabla de atributos:

```
- id_objeto: Identificador único
- nombre: Nombre del objeto/polígono/línea
- clasificacion: Categoría (ej: urbano/rural, tipo de riesgo, etc.)
- area_m2: Área en metros cuadrados [solo polígonos]
- observaciones: Notas adicionales del campo
```

---

## Cambios respecto a versión anterior

Si actualizas una capa existente, describe qué cambió:

- **Versión anterior**: [Semestre anterior, ej 2024-1]
- **Cambios realizados**: 
  - Añadieron X polígonos nuevos
  - Corrigieron límites en la zona Y
  - Actualización de atributos
- **Comparación**: 
  - Anterior: 1,250 objetos
  - Nueva: 1,380 objetos (+130)

---

## Control de Calidad

- [ ] Datos verificados en campo (si aplica)
- [ ] Topología revisada (sin overlaps/gaps)
- [ ] Atributos completos (sin NULL innecesarios)
- [ ] Proyección correcta (EPSG:32613)
- [ ] Nombres de campos estandarizados (sin espacios, minúsculas)
- [ ] Documentación completada

---

## Notas Adicionales

Espacio libre para comentarios, advertencias, o información importante:

> Ejemplo: "Esta capa heredó del semestre 2024-1 con pequeñas actualizaciones en la zona metropolitana central. Incluye nuevas colonias identificadas en trabajo de campo septiembre 2024."

---

## Descargar esta capa

- **Archivo SHP**: `uso-suelo-2024.zip` (incluye .shp, .dbf, .prj, .cpg)
- **Archivo GeoJSON**: `uso-suelo-2024.geojson`
- **Repositorio Git**: `semestre-2024-2/datos/uso-suelo/`

---

**Nota para estudiantes:** Completa todo esto ANTES de hacer commit a Git. Tu profesor revisará esta documentación como parte de la calificación.
