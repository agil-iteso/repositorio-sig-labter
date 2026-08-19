# 🔍 Análisis: Acceso Descentralizado para Estudiantes

## El Problema Real

Tu pregunta expone un **cuello de botella crítico** en la propuesta anterior:

```
Propuesta Original:
┌──────────────────────────────────────────────────────┐
│ Estudiantes en sus PCs                              │
│ (Win/Mac/Linux, conectados a internet)              │
│                    ↓                                 │
│ Git clone → Editan localmente en QGIS               │
│                    ↓                                 │
│ git push → Suben a GitHub                           │
│                    ↓                                 │
│ [AQUÍ ESTÁ EL PROBLEMA]                             │
│                    ↓                                 │
│ QGIS Server (servidor ITESO) publica WMS            │
│ ← Requiere que alguien sincronice manualmente       │
│   o configure GitHub Actions                        │
│                    ↓                                 │
│ Visor web muestra capas                             │
└──────────────────────────────────────────────────────┘

⚠️ FRICCIÓN: Después de git push, ¿quién sincroniza 
a QGIS Server? ¿Cada cuánto? ¿Manual o automático?
```

---

## Escenario Problemático Concreto

**Lunes 10:00 AM:**
- Estudiante A edita `vialidad-principal.shp` en su PC
- `git push` → Cambios en GitHub ✓
- PERO: QGIS Server todavía muestra versión vieja
- Profesor abre visor web → ve versión desactualizada ✗

**¿Por qué?** Los datos están en Git (nube), pero QGIS Server lee archivos locales en `/var/www/qgis-projects/`.

---

## Las Tres Soluciones Posibles

### **SOLUCIÓN 1: Sincronización Automática (Recomendada)**

**Arquitectura:**

```
Computadora PC Estudiante
    │
    ├─ Git clone repositorio-sig
    │
    ├─ Edita en QGIS local
    │  (archivo: ./semestre-2024-2/datos/vialidad.shp)
    │
    └─ git commit + git push
            │
            ▼
        GitHub/GitLab (nube, centralizado)
            │
            ├─ Webhook (escucha cambios)
            │
            ▼
        GitHub Actions (automatización)
            │
            ├─ Script: descarga cambios
            ├─ Script: copia shapefiles a QGIS Server
            ├─ Script: refresca caché de tiles (opcional)
            │
            ▼
        QGIS Server (/var/www/qgis-projects/)
            │
            ├─ Publica como WMS/WFS
            │
            ▼
        Visor Web Leaflet
            │
            └─ Estudiantes ven versión ACTUALIZADA ✓
```

**Flujo por paso:**

1. **Estudiante A** edita `vialidad.shp` en su PC (QGIS)
2. **Guarda** y hace `git push`
3. **GitHub recibe** el push y dispara webhook automáticamente
4. **GitHub Actions** corre script en 10-30 segundos:
   ```bash
   git pull origin main
   cp semestre-2024-2/datos/*/*.shp /var/www/qgis-projects/datos/
   systemctl restart qgis-server  # Refresca servidor
   ```
5. **Visor web** ve cambios instantáneamente (o en 30 seg max)

**Ventajas:**
- ✅ Totalmente automático (cero intervención profesor)
- ✅ Sincronización en tiempo real
- ✅ Escalable (funciona con 30+ estudiantes)
- ✅ Costo: $0 (GitHub Actions incluido)

**Desventajas:**
- ⚠️ Requiere setup inicial (archivo `.github/workflows/`)
- ⚠️ Si GitHub está caído, se detiene sincronización (poco probable)

**Ejemplo de workflow GitHub Actions:**

Archivo: `.github/workflows/sync-qgis-server.yml`

```yaml
name: Sync to QGIS Server

on:
  push:
    branches: [main]
    paths: ['semestre-**/datos/**']

jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Deploy to QGIS Server
        env:
          DEPLOY_KEY: ${{ secrets.DEPLOY_KEY }}
          SERVER_IP: ${{ secrets.SERVER_IP }}
          SERVER_USER: ${{ secrets.SERVER_USER }}
        run: |
          # Usa SSH para conectarse al servidor ITESO
          mkdir -p ~/.ssh
          echo "$DEPLOY_KEY" > ~/.ssh/id_rsa
          chmod 600 ~/.ssh/id_rsa
          
          # Pull cambios en servidor
          ssh $SERVER_USER@$SERVER_IP << 'EOF'
          cd /var/www/qgis-projects
          git pull origin main
          chown -R www-data:www-data .
          systemctl restart apache2
          EOF
```

---

### **SOLUCIÓN 2: PostGIS Centralizado + Git para Metadatos**

**Arquitectura:**

```
Estudiante en PC
    │
    ├─ Conecta a PostGIS remoto (servidor ITESO)
    │  usuario/contraseña
    │
    ├─ Abre QGIS → datasource: "PostGIS lag_vialidad"
    │
    ├─ Edita directamente en BD (sin archivos locales)
    │
    └─ Cambios se guardan en PostGIS automáticamente
            │
            ▼
        QGIS Server (publica directamente de PostGIS)
            │
            ├─ Datos siempre sincronizados ✓
            │
            ▼
        Visor web ve cambios instantáneamente
            │
            └─ Git almacena solo METADATOS
               (README.md, CHANGELOG.md)
```

**Ventajas:**
- ✅ Cero fricción de sincronización
- ✅ Datos siempre actualizados
- ✅ Soporte para edición colaborativa (múltiples usuarios a la vez)
- ✅ Mejor rendimiento (BD > archivos)
- ✅ Control de acceso a nivel de tabla

**Desventajas:**
- ⚠️ Requiere PostGIS + conexión de red estable
- ⚠️ Más complejo de mantener
- ⚠️ Si servidor cae, nadie puede editar
- ⚠️ Requiere permisos de BD por usuario

**Setup requerido:**

```bash
# En servidor ITESO
sudo apt install postgresql postgresql-contrib postgis -y

# Crear BD y usuario por semestre
sudo -u postgres createdb db_2024_2
sudo -u postgres createuser estudiante_sig PASSWORD 'contraseña-segura'

# Otorgar permisos
sudo -u postgres psql -d db_2024_2 << EOF
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO estudiante_sig;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO estudiante_sig;
EOF

# En QGIS (estudiante):
# Menú: Layer → New Layer → New PostgreSQL connection
# Host: ip-servidor.iteso.mx
# Port: 5432
# Database: db_2024_2
# User: estudiante_sig
# Password: [como arriba]
```

---

### **SOLUCIÓN 3: Hybrid (Recomendado para ITESO)**

**Combina lo mejor de 1 y 2:**

```
Capas "Bases" (limites, uso suelo)
    ↓
    └─→ PostGIS (central) + QGIS Server
        Estudiantes NO las tocan, solo leen
        
Capas "Trabajos" (nuevas por semestre)
    ↓
    └─→ Shapefiles en Git + sincronización automática
        Estudiantes editan, suben a Git
        GitHub Actions sincroniza a QGIS Server
```

**Ventaja clave:** 
- Bases estables en BD
- Nuevas capas ágiles en Git
- Lo mejor de ambos mundos

---

## 🎯 MI RECOMENDACIÓN PARA TI

### **OPCIÓN A: Empezar con Solución 1 (GitHub Actions) — RÁPIDO**

✅ **Tiempo de setup:** 30 minutos  
✅ **Complejidad:** Baja  
✅ **Costo:** $0  
✅ **Funciona desde día 1**

**Pasos:**
1. Creas repositorio en GitHub (público o privado)
2. Estudiantes cloan y editan (tal como está documentado)
3. Tú copias el archivo `.github/workflows/sync-qgis-server.yml` (arriba)
4. Configuras 3 secrets en GitHub (SSH key, IP, usuario)
5. ¡Listo! Sincronización automática

**Ideal para:** Primeros 2-3 semestres (validación)

---

### **OPCIÓN B: Migrar a PostGIS después (Profesional)**

✅ **Tiempo de setup:** 4-6 horas  
✅ **Complejidad:** Media-Alta  
✅ **Costo:** $0  
✅ **Escalable indefinidamente**

**Pasos:**
1. Instalar PostGIS en servidor (Semana 2 Fase 1)
2. Importar shapefiles existentes a BD
3. Entrenar estudiantes a conectar desde QGIS
4. Mantener Git solo para metadatos

**Ideal para:** Después de 2 semestres con contenido

---

### **OPCIÓN C: Hybrid (Lo que recomiendo) — BALANCEADO**

✅ **Tiempo de setup:** 2 horas  
✅ **Complejidad:** Media  
✅ **Costo:** $0  
✅ **Escalable y flexible**

**Fase 1 (ahora):**
- Capas base en archivos + Git
- Sincronización automática con GitHub Actions
- Estudiantes suben shapefiles

**Fase 2 (semestre próximo, después de validar):**
- Capas base → PostGIS (estables, no se tocan)
- Capas nuevas → continúan en Git (ágiles)
- Sincronización mix: BD + archivos

---

## Comparativa Decisión

| Criterio | Solución 1 (GH Actions) | Solución 2 (PostGIS) | Solución 3 (Hybrid) |
|----------|---|---|---|
| **Setup inicial** | 30 min | 4-6 hrs | 2 hrs |
| **Costo** | $0 | $0 | $0 |
| **Curva aprendizaje** | Baja | Media | Media-Baja |
| **Escalabilidad** | Hasta 100+ capas | Indefinida | Indefinida |
| **Sincronización** | 30 seg (automática) | Instantánea | Mix |
| **Resiliencia** | Alta (GitHub redundante) | Media (BD single point) | Alta |
| **Edición colaborativa** | No (conflictos Git) | Sí | Sí (en PostGIS) |
| **Adecuado para** | Comenzar | Producción | ITESO ahora |

---

## Solución Específica para TU Caso

Dado que:
- ✓ Tienes ITESO con infraestructura
- ✓ Quieres comenzar "ligero"
- ✓ Planeas escalar después
- ✓ Estudiantes en sus PCs personales

### **Te recomiendo OPCIÓN C (Hybrid):**

**Fase 1 (Semanas 1-2):**
```
Estudiantes →[editan en QGIS local]→ git push
                                        ↓
                                    GitHub
                                        ↓
                            GitHub Actions
                                        ↓
                                QGIS Server
                                        ↓
                                  Visor web
```

**Setup:**
1. Repositorio GitHub (5 min)
2. `.github/workflows/sync-qgis-server.yml` (10 min)
3. Configurar 3 secrets en GitHub (10 min)
4. Listo ✓

**Fase 2 (Semestre próximo, si lo necesitas):**
- Evalúas PostGIS
- Importas capas base a BD
- Dejas nuevas capas en Git
- Sincronización hybrid

---

## Implementación Paso a Paso (OPCIÓN C)

### Paso 1: Crear Repositorio GitHub

```bash
# En terminal tu PC:
mkdir repositorio-sig-iteso
cd repositorio-sig-iteso
git init
git remote add origin https://github.com/ITESO/repositorio-sig-iteso.git

# Crear estructura base
mkdir -p semestre-2024-2/datos/{uso-suelo,vialidad}
mkdir -p .github/workflows
git add .
git commit -m "Initial commit: estructura base"
git push -u origin main
```

### Paso 2: Crear Archivo de Sincronización

Archivo: `.github/workflows/sync-qgis-server.yml`

```yaml
name: Sync Data to QGIS Server

on:
  push:
    branches: [main]
    paths: 
      - 'semestre-**/datos/**'
      - '!**/*.md'

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout repo
      uses: actions/checkout@v3
      with:
        fetch-depth: 0
    
    - name: Setup SSH
      run: |
        mkdir -p ~/.ssh
        echo "${{ secrets.DEPLOY_KEY }}" > ~/.ssh/id_rsa
        chmod 600 ~/.ssh/id_rsa
        ssh-keyscan -H ${{ secrets.SERVER_IP }} >> ~/.ssh/known_hosts
    
    - name: Pull and sync on server
      run: |
        ssh ${{ secrets.SERVER_USER }}@${{ secrets.SERVER_IP }} << 'EOF'
        
        cd /var/www/qgis-projects
        git pull origin main
        
        # Cambiar permisos para que www-data (Apache) pueda leer
        find . -type f -name "*.shp" -o -name "*.dbf" -o -name "*.prj" | \
          xargs chown www-data:www-data
        
        # Recargar QGIS Server (opcional, si usas Apache)
        sudo systemctl reload apache2
        
        echo "✓ Sincronización completada: $(date)"
        EOF
    
    - name: Notify success
      if: success()
      run: echo "✓ QGIS Server sincronizado"
    
    - name: Notify failure
      if: failure()
      run: echo "✗ Error en sincronización - contacta a profesor"
```

### Paso 3: Configurar Secrets en GitHub

En **GitHub → Settings → Secrets → New repository secret:**

1. **DEPLOY_KEY**: Tu clave SSH privada
   ```bash
   # Generar (en terminal):
   ssh-keygen -t rsa -b 4096 -f ~/.ssh/qgis-deploy
   # Copiar contenido de ~/.ssh/qgis-deploy
   ```

2. **SERVER_IP**: IP o hostname del servidor ITESO
   ```
   sig.iteso.mx  (o IP: 192.168.x.x)
   ```

3. **SERVER_USER**: Usuario SSH
   ```
   ubuntu  (o el usuario en tu servidor)
   ```

### Paso 4: Autorizar en Servidor

En tu servidor ITESO:

```bash
# Copiar clave pública a servidor
ssh-copy-id -i ~/.ssh/qgis-deploy.pub ubuntu@sig.iteso.mx

# Verificar conectividad
ssh ubuntu@sig.iteso.mx "cd /var/www/qgis-projects && pwd"
```

---

## Prueba Final

**Estudiante A hace esto:**

```bash
# En su PC
git clone https://github.com/ITESO/repositorio-sig-iteso.git
cd repositorio-sig-iteso
qgis semestre-2024-2/qgis-projects/amg-base.qgs

# Edita una capa (ej: vialidad)
# Guarda en QGIS (Ctrl+S)
# En terminal:
git add semestre-2024-2/datos/vialidad/
git commit -m "Actualizada vialidad: nuevas calles zona norte"
git push origin main
```

**Resultado:**
- ✓ GitHub Actions se dispara automáticamente
- ✓ En 30 segundos, QGIS Server tiene los cambios
- ✓ Visor web muestra versión actualizada
- ✓ Otros estudiantes ven cambios al abrir visor

**Profesor verifica:**

```bash
# Ver log de sincronizaciones
# GitHub → Actions → [workflow name] → ver logs
```

---

## Resumen Final

**Tu pregunta expuso un problema real.**

✅ **La solución:** GitHub Actions (sincronización automática)  
✅ **Tiempo de implementación:** 1 hora  
✅ **Costo:** $0  
✅ **Resultado:** Todos los estudiantes en sus PCs, datos siempre sincronizados  

**Siguiente paso:** Dime si quieres que te prepare:
1. Archivo `.github/workflows/` listo para copiar/pegar
2. Script de setup automatizado (genera secrets automáticamente)
3. Guía para estudiantes sobre cómo ver cambios en visor web

¿Cuál opción te suena mejor? ¿Empezamos con GitHub Actions?
