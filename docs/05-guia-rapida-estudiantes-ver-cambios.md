# 🔄 Guía Rápida: Ver tus cambios en el visor web

## Flujo Resumido (para estudiantes)

```
Tu PC (QGIS)
    ↓
Editas y guardas capas
    ↓
git commit + git push
    ↓
[AUTOMÁTICO - ~30 segundos]
    ↓
GitHub Actions sincroniza
    ↓
QGIS Server se actualiza
    ↓
Visor web muestra tus cambios ✓
```

---

## Paso a Paso

### 1️⃣ Editar en QGIS (tu PC)

```bash
# Abre tu proyecto QGIS
qgis semestre-2024-2/qgis-projects/amg-base.qgs
```

- Selecciona la capa que quieres editar
- **Layer → Toggle Editing** (o Ctrl+E)
- Edita (añade polígonos, puntos, líneas)
- **Guarda** (Ctrl+S)

### 2️⃣ Sube a GitHub

```bash
# En terminal:
cd /ruta/a/repositorio-sig-iteso

# Ver qué cambió
git status

# Preparar cambios
git add semestre-2024-2/datos/[tu-carpeta]/

# Guardar con mensaje descriptivo
git commit -m "Actualizada vialidad: nuevas calles zona norte"

# Subir a GitHub
git push origin main
```

✅ **¡Listo! Tus cambios están en GitHub**

### 3️⃣ Espera 30 segundos (automático)

GitHub Actions automáticamente:
- ✓ Descarga tus cambios
- ✓ Los copia al servidor QGIS
- ✓ Refresca el visor web

### 4️⃣ Abre el visor web

Accede a: **http://sig.tu-dominio.local** (o la URL que te dé el profesor)

- Espera 5 segundos a que cargue
- ¡Verás tus cambios reflejados! 🎉

---

## Verificar que funcionó

### ✅ Forma 1: Ver en GitHub Actions

1. Abre tu repo en GitHub
2. Click en **Actions** (pestaña)
3. Ver workflow **"Sync Data to QGIS Server"**
4. Click en el último run
5. Ver estado: **✓ passed** (verde) = éxito

### ✅ Forma 2: Ver en visor web

1. Abre http://sig.tu-dominio.local
2. Selecciona la capa que editaste
3. ¿Ves tus cambios? ¡Funcionó! ✓

### ❌ Si no ves cambios

**Espera 1 minuto** (a veces GitHub Actions tarda un poco)

Si sigue sin aparecer:
1. Verifica en GitHub Actions si hay error rojo
2. Contacta al profesor con el link del workflow error

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

- 🚫 **No hagas push sin guardar en QGIS:**
  Siempre guarda tus capas en QGIS primero (Ctrl+S)

---

## Preguntas Frecuentes

**P: ¿Cuánto tarda en verse en el visor?**  
R: 30-60 segundos desde que haces `git push`

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
