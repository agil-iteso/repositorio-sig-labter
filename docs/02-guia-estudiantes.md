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
git clone https://github.com/ITESO/repositorio-sig-iteso.git

# Entra a la carpeta:
cd repositorio-sig-iteso
```

**¿Qué bajaste?** Todas las capas de todos los semestres anteriores + el proyecto QGIS base.

---

## **PARTE 2: Trabajar con una Capa Existente (Edición)**

### 2.1 Abrir el Proyecto QGIS Base

```bash
# Desde la carpeta del repositorio:
cd semestre-2024-2/qgis-projects/
qgis amg-base.qgs &
```

Se abrirá QGIS con todas las capas del semestre.

### 2.2 Editar una Capa

1. **En QGIS**, selecciona la capa que quieres editar (ej: `vialidad-principal`)
2. **Menú Layer → Toggle Editing** (o presiona `Ctrl+E`)
3. **Edita**: Añade puntos, líneas, polígonos con las herramientas de edición
4. **Guarda**: `Ctrl+S`

### 2.3 Subir tus Cambios a Git

```bash
# Verifica qué archivos cambiaron:
git status

# Prepara tus cambios para subir:
git add semestre-2024-2/datos/vialidad-principal/

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
2. **Nombre**: `nueva-capa-2024.shp`
3. **Ubicación**: `semestre-2024-2/datos/tu-tema/`
4. **Tipo**: Polígono / Línea / Punto
5. **Proyección**: EPSG:32613 (UTM zona 13)
6. **Campos**: Añade los campos de atributos que necesites

### 3.2 Digitalizar datos

1. **Toggle Editing** en tu capa
2. Usa las herramientas para dibujar polígonos/líneas/puntos
3. Completa los atributos en la tabla

### 3.3 Documentar la capa

1. **Copia la plantilla** `PLANTILLA-METADATA-capa.md`
2. **Pega en** `semestre-2024-2/datos/tu-tema/README.md`
3. **Completa todos los campos** (fuente, fecha, descripción, etc.)

### 3.4 Subir a Git

```bash
# Añade la carpeta nueva:
git add semestre-2024-2/datos/tu-tema/

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
git tag -a v2024-2-final -m "Versión final semestre 2024-2"
git push origin v2024-2-final
```

### 4.2 Siguiente semestre: Heredar todo

```bash
# Los estudiantes nuevos clonan:
git clone https://github.com/ITESO/repositorio-sig-iteso.git

# Descargan todas las capas del semestre anterior
cd repositorio-sig-iteso

# Copian la carpeta del semestre anterior:
cp -r semestre-2024-2/ semestre-2025-1/

# Crean rama para el nuevo semestre:
git checkout -b semestre-2025-1
git add semestre-2025-1/
git commit -m "Herencia: todas las capas de 2024-2 + nuevas capas semestre 2025-1"
git push origin semestre-2025-1
```

---

## **PARTE 5: Problemas Comunes**

### ❌ "No puedo hacer push, acceso denegado"

**Solución**: Pídele al profesor que te agregue como colaborador en GitHub.

### ❌ "QGIS no encuentra las capas"

**Solución**: Asegúrate de que las rutas en `amg-base.qgs` sean correctas:
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

### ❌ "¿Cómo descargo una capa vieja?"

```bash
# Cambia a la versión anterior:
git checkout v2024-1-final

# Toma esa capa:
cp semestre-2024-1/datos/uso-suelo/uso-suelo.shp ~/mi-capa.shp

# Vuelve a la versión actual:
git checkout main
```

---

## **PARTE 6: Ver el Visor Web**

Después de cada actualización, tu profesor publica el visor web en:

**http://sig.tu-dominio.local** (o la URL que te dé)

Allí podrás:
- Ver todas las capas del semestre actual
- Cambiar entre versiones de semestres anteriores
- Descargar capas en formato SHP o GeoJSON

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
git add [carpeta]
git commit -m "Descripción"
git push origin main        # Subes tus cambios
    ↓
Profesor revisa y aprueba
    ↓
Capas aparecen en visor web
```

---

## **Checklist Final**

Antes de terminar tu trabajo cada día:

- [ ] Guardé archivo QGIS (Ctrl+S)
- [ ] Guardé capas individual (shapefile auto-guarda)
- [ ] Completé o actualicé README.md con metadatos
- [ ] Hice `git add` de la carpeta correcta
- [ ] Hice `git commit` con mensaje descriptivo
- [ ] Hice `git push` y no me salieron errores
- [ ] Verifiqué en GitHub que mis cambios aparecen

---

## ¿Preguntas?

Abre un **Issue en GitHub** con tu pregunta, o pregunta en clase.

**¡Bienvenido a la plataforma SIG colaborativa!** 🗺️
