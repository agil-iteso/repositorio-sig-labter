# 📘 Guía para Estudiantes: Flujo de Trabajo SIG

Esta guía te enseña cómo trabajar con las capas SIG del semestre usando Git y QGIS.

---

## **PARTE 1: Primeros Pasos (Haz esto UNA sola vez)**

### 1.1 Instalar Software Necesario

**Git** (control de versiones):
```bash
# En Ubuntu/Debian:
sudo apt install git -y

# En Windows: Descarga de https://git-scm.com/download/win
# En Mac: brew install git
```

**QGIS** (editor de mapas):
- Descarga desde https://www.qgis.org/download/
- Instala la versión LTR (más estable)

### 1.2 Configurar Git (primera vez solo)

```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tu@iteso.mx"
```

### 1.3 Clonar el Repositorio del Semestre

```bash
# Navega a donde guardes tus proyectos:
cd ~/Documents/

# Clona el repositorio (descarga TODAS las capas del semestre anterior):
git clone https://github.com/agil-iteso/repositorio-sig-labter.git

# Entra a la carpeta:
cd repositorio-sig-labter
```

**¿Qué bajaste?** Todas las capas de todos los semestres anteriores + el proyecto QGIS base.

---

## **PARTE 2: Trabajar con una Capa Existente (Edición)**

### 2.1 Abrir el Proyecto QGIS Base

```bash
# Desde la carpeta del repositorio:
cd semestre-2026-2/qgis-projects/
qgis PAP-Labter.qgs &
```

Se abrirá QGIS con todas las capas del semestre.

### 2.2 Editar una Capa

1. **En QGIS**, selecciona la capa que quieres editar (ej: `vialidad-principal`)
2. **Menú Layer → Toggle Editing** (o presiona `Ctrl+E`)
3. **Edita**: Añade puntos, líneas, polígonos con las herramientas de edición
4. **Guarda**: `Ctrl+S`

### 2.3 Exporta también a GeoJSON (importante — el visor web lo necesita)

El visor web no lee shapefiles, lee GeoJSON. Cada vez que edites una capa:

1. En QGIS, clic derecho sobre la capa → **Export → Save Features As...**
2. **Format**: `GeoJSON`
3. **File name**: la misma carpeta y nombre de la capa, ej. `semestre-2026-2/datos/vialidad-principal/vialidad-principal.geojson`
4. **CRS**: `EPSG:4326 - WGS 84` (el visor web necesita coordenadas geográficas, no UTM)
5. **OK** (sobreescribe el `.geojson` anterior si ya existía)

### 2.4 Subir tus Cambios a Git

```bash
# Verifica qué archivos cambiaron:
git status

# Prepara tus cambios para subir (shapefile + geojson):
git add semestre-2026-2/datos/vialidad-principal/

# Guarda una "foto" de tus cambios con un mensaje:
git commit -m "Actualización vialidad: agregadas nuevas calles zona norte"

# Sube a GitHub (requiere permiso):
git push origin main
```

**Mensaje de commit:** Describe QUÉ hiciste, no cómo. ✓ "Agregadas 50 calles nuevas" ✗ "cambios"

---

## **PARTE 3: Crear una NUEVA Capa**

### 3.1 Crear capa en QGIS

1. **Menú Layer → Create Layer → New Shapefile...**
2. **Nombre**: `nombre-de-tu-capa.shp`
3. **Ubicación**: `semestre-2026-2/datos/tu-tema/`
4. **Tipo**: Polígono / Línea / Punto
5. **Proyección**: EPSG:32613 (UTM zona 13) — es la que se usa para digitalizar con precisión
6. **Campos**: Añade los campos de atributos que necesites

### 3.2 Digitalizar datos

1. **Toggle Editing** en tu capa
2. Usa las herramientas para dibujar polígonos/líneas/puntos
3. Completa los atributos en la tabla

### 3.3 Exportar a GeoJSON para el visor web

Sigue el paso **2.3** de arriba con tu nueva capa (Export → Save Features As → GeoJSON → CRS EPSG:4326).

### 3.4 Documentar la capa

1. **Copia la plantilla** `PLANTILLA-METADATA-capa.md`
2. **Pega en** `semestre-2026-2/datos/tu-tema/README.md`
3. **Completa todos los campos** (fuente, fecha, descripción, etc.)

### 3.5 Registrar la capa en el visor web

Abre `visor-web/config.json` y agrega tu capa dentro de la lista `capas` del semestre actual:

```json
{
  "id": "tu-tema-2026",
  "nombre": "Nombre bonito para mostrar",
  "grupo": "Categoría (ej. Base, Riesgo, Infraestructura)",
  "archivo": "../semestre-2026-2/datos/tu-tema/tu-tema.geojson",
  "visible": true,
  "fuente": "INEGI / CONAGUA / levantamiento de campo",
  "fecha": "2026-08",
  "autor": "Tu nombre",
  "escala": "1:50,000"
}
```

Cuidado con las comas entre elementos de la lista (formato JSON estricto).

### 3.6 Subir a Git

```bash
# Añade la carpeta nueva y el config.json actualizado:
git add semestre-2026-2/datos/tu-tema/ visor-web/config.json

# Commit con descripción clara:
git commit -m "Nueva capa: riesgo de inundación - análisis MDE + precipitación"

# Push:
git push origin main
```

---

## **PARTE 4: Preparar el Semestre Siguiente (Herencia)**

### 4.1 Al final del semestre: Crear snapshot

```bash
# Congela la versión actual con un tag:
git tag -a v2026-2-final -m "Versión final semestre 2026-2"
git push origin v2026-2-final
```

### 4.2 Siguiente semestre: Heredar todo

El profesor corre `./automatizar-versionado.sh crear-semestre 2027-1`, que copia toda la carpeta del semestre anterior automáticamente. Tú solo necesitas:

```bash
git pull origin main
```

Y ya tienes 100% de las capas anteriores disponibles en `semestre-2027-1/`.

---

## **PARTE 5: Problemas Comunes**

### ❌ "No puedo hacer push, acceso denegado"

**Solución**: Pídele al profesor que te agregue como colaborador en GitHub.

### ❌ "QGIS no encuentra las capas"

**Solución**: Asegúrate de que las rutas en `PAP-Labter.qgs` sean correctas:
- En QGIS: **Layer → Layer Properties → Source**
- Las rutas deben ser **relativas**, no absolutas

### ❌ "Tengo conflicto de Git" (otro estudiante editó lo mismo)

```bash
# Git te mostrará qué conflictó. Abre en editor y resuelve manualmente:
git status  # Ver conflictos
# Edita los archivos conflictivos
git add [archivos]
git commit -m "Resueltos conflictos en [capa]"
git push
```

### ❌ "Mi capa no aparece en el visor web"

Lo más común: falta agregarla a `visor-web/config.json` (ver Parte 3.5), o la ruta del campo `archivo` está mal escrita.

### ❌ "¿Cómo descargo una capa de un semestre anterior?"

```bash
# Cambia a la versión anterior (ejemplo):
git checkout v2026-2-final

# Toma esa capa:
cp semestre-2026-2/datos/uso-suelo/uso-suelo.shp ~/mi-capa.shp

# Vuelve a la versión actual:
git checkout main
```

---

## **PARTE 6: Ver el Visor Web**

El visor web se publica automáticamente con GitHub Pages en:

**https://agil-iteso.github.io/repositorio-sig-labter/visor-web/**

Allí podrás:
- Ver todas las capas registradas del semestre actual
- Ver metadatos de cada capa

---

## **Flujo Resumen (Día a Día)**

```
Inicio de clase
    ↓
git pull origin main        # Descargas cambios de otros
    ↓
Abres QGIS y editas capas
    ↓
Guardas (Ctrl+S)
    ↓
Exportas también a GeoJSON (Export → Save Features As)
    ↓
git add [carpeta] visor-web/config.json
git commit -m "Descripción"
git push origin main        # Subes tus cambios
    ↓
GitHub Pages se actualiza solo (unos segundos)
    ↓
Capas aparecen en visor web
```

---

## **Checklist Final**

Antes de terminar tu trabajo cada día:

- [ ] Guardé archivo QGIS (Ctrl+S)
- [ ] Exporté la capa a GeoJSON (CRS EPSG:4326)
- [ ] Completé o actualicé README.md con metadatos
- [ ] Si es capa nueva: la agregué a `visor-web/config.json`
- [ ] Hice `git add` de la carpeta correcta
- [ ] Hice `git commit` con mensaje descriptivo
- [ ] Hice `git push` y no me salieron errores
- [ ] Verifiqué en GitHub que mis cambios aparecen

---

## ¿Preguntas?

Abre un **Issue en GitHub** con tu pregunta, o pregunta en clase.

**¡Bienvenido a la plataforma SIG colaborativa!** 🗺️
