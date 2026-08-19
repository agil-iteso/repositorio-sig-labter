# 🔄 Guía Rápida: Ver tus cambios en el visor web

## Flujo Resumido (para estudiantes)

```
Tu PC (QGIS)
    ↓
Editas y guardas capas
    ↓
Exportas a GeoJSON (Export → Save Features As)
    ↓
git commit + git push
    ↓
[AUTOMÁTICO - unos segundos]
    ↓
GitHub Pages reconstruye el sitio
    ↓
Visor web muestra tus cambios ✓
```

---

## Paso a Paso

### 1️⃣ Editar en QGIS (tu PC)

```bash
# Abre tu proyecto QGIS
qgis semestre-2026-2/qgis-projects/amg-base.qgs
```

- Selecciona la capa que quieres editar
- **Layer → Toggle Editing** (o Ctrl+E)
- Edita (añade polígonos, puntos, líneas)
- **Guarda** (Ctrl+S)

### 2️⃣ Exporta a GeoJSON

- Clic derecho en la capa → **Export → Save Features As...**
- Format: `GeoJSON`, CRS: `EPSG:4326`
- Guarda sobre el mismo archivo `.geojson` de la capa

### 3️⃣ Sube a GitHub

```bash
# En terminal:
cd /ruta/a/repositorio-sig-labter

# Ver qué cambió
git status

# Preparar cambios
git add semestre-2026-2/datos/[tu-carpeta]/

# Guardar con mensaje descriptivo
git commit -m "Actualizada vialidad: nuevas calles zona norte"

# Subir a GitHub
git push origin main
```

✅ **¡Listo! Tus cambios están en GitHub**

### 4️⃣ Espera unos segundos (automático)

GitHub Pages reconstruye el sitio solo cuando detecta el push — normalmente toma entre 20 segundos y 2 minutos.

### 5️⃣ Abre el visor web

Accede a: **https://agil-iteso.github.io/repositorio-sig-labter/visor-web/**

- Si ya lo tenías abierto, refresca con `Ctrl+F5` (recarga forzada, evita que el navegador use una copia en caché)
- ¡Verás tus cambios reflejados! 🎉

---

## Verificar que funcionó

### ✅ Forma 1: Ver en GitHub → Settings → Pages

1. Abre tu repo en GitHub
2. **Settings → Pages**
3. Debajo del selector de rama verás "Your site is live at..." con la fecha de la última publicación

### ✅ Forma 2: Ver en visor web

1. Abre el visor web
2. Selecciona la capa que editaste en la lista lateral
3. ¿Ves tus cambios en el mapa? ¡Funcionó! ✓

### ❌ Si no ves cambios

1. Revisa que tu capa esté registrada en `visor-web/config.json` (con la ruta correcta al `.geojson`)
2. Haz `Ctrl+F5` para forzar recarga sin caché
3. Espera 1-2 minutos más
4. Contacta al profesor si sigue sin aparecer

---

## Tabla de Referencia Rápida

| Acción | Comando |
|--------|---------|
| **Ver cambios** | `git status` |
| **Preparar** | `git add carpeta/` |
| **Guardar** | `git commit -m "mensaje"` |
| **Subir** | `git push origin main` |
| **Ver cambios remotos** | `git log origin/main` |
| **Descargar cambios de otros** | `git pull origin main` |

---

## 💡 Tips

- 🔄 **Actualiza antes de trabajar:**
  ```bash
  git pull origin main
  ```
  Esto descarga cambios que otros estudiantes hicieron.

- 📝 **Mensajes claros:**
  ```
  ✓ "Agregadas 15 casetas comerciales zona oriente"
  ✗ "cambios"
  ```

- 🚫 **No hagas push sin exportar a GeoJSON primero:**
  Si solo actualizas el shapefile, el visor web NO va a mostrar tus cambios (lee `.geojson`, no `.shp`).

---

## Preguntas Frecuentes

**P: ¿Cuánto tarda en verse en el visor?**
R: 20 segundos a 2 minutos desde que haces `git push`.

**P: ¿Qué pasa si otro estudiante edita la misma capa?**
R: Git puede alertarte de conflictos. Avisa al profesor.

**P: ¿Puedo revertir mis cambios?**
R: Sí. Pregunta al profesor cómo usar `git revert` o `git reset`

**P: ¿Se pierden mis cambios?**
R: No. Git guarda TODO el historial. Siempre se puede recuperar.

---

## ¿Necesitas ayuda?

1. **Revisa este documento** (es la solución más probable)
2. **Pregunta al profesor** en clase o por correo
3. **Abre un Issue en GitHub** describiendo el problema

¡**Feliz edición de mapas!** 🗺️
