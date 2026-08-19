# Plan de Migración a GeoNode (Fase 2)

Cuando hayas validado Fase 1 con 2-3 semestres y tengas suficientes capas, puedes migrar a **GeoNode** sin perder nada.

---

## **¿Por qué migrar a GeoNode?**

| Característica | QGIS Server + Git | GeoNode |
|---|---|---|
| **Interfaz web** | ✓ Leaflet (ligero) | ✓ Profesional, intuitivo |
| **Búsqueda de capas** | ✗ Manual | ✓ Búsqueda avanzada |
| **Metadatos automáticos** | ✓ Manuales (README) | ✓ Editor visual integrado |
| **Permisos granulares** | ✗ Solo lectura/escritura | ✓ Por usuario, por semestre |
| **API REST** | ✓ WFS/WMS | ✓ Completo |
| **Versionado de capas** | ✓ Git | ✓ Automático |
| **Mantenimiento** | ✓ Bajo | ✗ Requiere DevOps |

**Mejor momento para migrar:**
- ✓ Después de 2-3 semestres (cuando tengas 50+ capas)
- ✓ Cuando necesites búsqueda y filtros avanzados
- ✓ Si planeas publicar datos públicamente
- ✗ Si apenas estás comenzando

---

## **Fase 2: Arquitectura GeoNode**

```
┌─────────────────────────────────────────────────────┐
│              ITESO SIG Platform v2.0                │
├─────────────────────────────────────────────────────┤
│                                                     │
│  ┌───────────────────────────────────────────────┐  │
│  │        GeoNode (Interfaz Web)                 │  │
│  │  - Catálogo de capas                          │  │
│  │  - Gestor de metadatos                        │  │
│  │  - Mapas interactivos                         │  │
│  │  - Permisos por semestre                      │  │
│  └───────────────────────────────────────────────┘  │
│                        ↑                            │
│                        │ (WMS/WFS/API REST)         │
│  ┌───────────────────────────────────────────────┐  │
│  │        GeoServer                              │  │
│  │  - Publica capas como servicios OGC           │  │
│  │  - Caché de tiles (GeoWebCache)               │  │
│  └───────────────────────────────────────────────┘  │
│                        ↑                            │
│                        │                            │
│  ┌───────────────────────────────────────────────┐  │
│  │        PostGIS (Base de datos)                │  │
│  │  - Almacena todas las capas                   │  │
│  │  - Versionado integrado                       │  │
│  │  - 1 BD por semestre (o particiones)          │  │
│  └───────────────────────────────────────────────┘  │
│                                                     │
│  ┌───────────────────────────────────────────────┐  │
│  │        Git (Control de Versiones)             │  │
│  │  - Metadata de capas                          │  │
│  │  - Scripts de sincronización                  │  │
│  └───────────────────────────────────────────────┘  │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## **Paso 1: Instalación de GeoNode (3-4 horas)**

### Opción A: Docker (Recomendado)

```bash
# Clonar GeoNode
git clone https://github.com/GeoNode/geonode.git
cd geonode

# Crear archivo .env
cp .env.example .env

# Editar .env (configurar hostname, HTTPS, etc.)
nano .env

# Levantar servicios
docker-compose up -d

# Esperar 5-10 minutos a que inicie
docker-compose logs -f
```

**Acceso**: http://localhost o http://tu-ip (según configuración)

### Opción B: Servidor Ubuntu (Manual)

```bash
# Seguir documentación oficial:
# https://docs.geonode.org/en/master/install/

sudo apt update
sudo apt install postgresql postgresql-contrib postgis -y
sudo apt install elasticsearch elasticsearch-dsl-py -y

# Crear usuario y BD
sudo -u postgres createuser geonode
sudo -u postgres createdb -O geonode geonode
psql -U geonode -d geonode -c "CREATE EXTENSION postgis;"

# Instalar GeoNode (Python)
python3 -m venv geonode-env
source geonode-env/bin/activate
pip install geonode

# Inicializar
geonode migrate
geonode createsuperuser

# Correr servidor
geonode runserver 0.0.0.0:8000
```

---

## **Paso 2: Importar Datos Existentes (Fase 1 → Fase 2)**

### 2.1 Preparar Shapefiles

Tu data actual en Git está en shapefile. GeoNode los importa automáticamente:

```bash
# Desde el repo Fase 1:
cd /ruta/a/repositorio-sig-iteso/

# Crear lista de archivos .shp
find . -name "*.shp" > capas-a-importar.txt
```

### 2.2 Importar a GeoNode

**Opción A: Interfaz Web (fácil)**

1. Accede a GeoNode: http://tu-servidor
2. Login con superuser
3. Menú **Uploads** → **Upload your layers**
4. Selecciona archivos `.shp` (se importan con .dbf, .prj, .cpg automáticamente)
5. Asigna metadatos básicos
6. Click **Upload**

**Opción B: Línea de Comandos (rápido para muchos)**

```bash
# Script para importar en batch
#!/bin/bash

GEONODE_URL="http://localhost:8000"
USERNAME="admin"
PASSWORD="tu-password"

# Token de autenticación
TOKEN=$(curl -s -X POST $GEONODE_URL/api/token-auth \
  -H "Content-Type: application/json" \
  -d "{\"username\": \"$USERNAME\", \"password\": \"$PASSWORD\"}" \
  | jq -r '.token')

# Importar cada shapefile
for shapefile in $(find . -name "*.shp"); do
    FOLDER=$(dirname "$shapefile")
    
    # Copiar a directorio de upload
    cp $FOLDER/* /var/lib/geonode/uploads/
    
    # Trigger import via API (REST)
    curl -s -X POST $GEONODE_URL/api/v2/layers \
      -H "Authorization: Bearer $TOKEN" \
      -H "Content-Type: multipart/form-data" \
      -F "file=@$shapefile" \
      -F "name=$(basename $shapefile .shp)" \
      -F "owner=admin"
done
```

### 2.3 Asignar Metadatos

Para cada capa importada:

1. **En GeoNode**: Click en la capa
2. **Edit Layer**: Completa:
   - Título, descripción
   - Palabras clave (ej: "uso-suelo, 2024, AMG")
   - Categoría (ej: "Territorial Basis", "Risk")
   - Licencia
   - Fuente
   - Autor
3. **Save**

GeoNode sincroniza con tu repo Git automáticamente.

---

## **Paso 3: Configurar Permisos por Semestre**

### 3.1 Crear Grupos (en GeoNode)

```bash
# En shell de GeoNode:
python manage.py shell

>>> from django.contrib.auth.models import Group
>>> from guardian.shortcuts import assign_perm

# Crear grupos por semestre
g_2024_1 = Group.objects.create(name="estudiantes-2024-1")
g_2024_2 = Group.objects.create(name="estudiantes-2024-2")
g_2025_1 = Group.objects.create(name="estudiantes-2025-1")

# Asignar capas a grupos
from geonode.layers.models import Layer

# Grupo 2024-1: todas las capas de 2024-1
capas_2024_1 = Layer.objects.filter(keywords__name="2024-1")
for capa in capas_2024_1:
    assign_perm('change_layer', g_2024_1, capa)
    assign_perm('delete_layer', g_2024_1, capa)

# Grupo 2024-2: hereda 2024-1 + nuevas de 2024-2
capas_2024_2 = Layer.objects.filter(
    keywords__name__in=["2024-1", "2024-2"]
)
for capa in capas_2024_2:
    assign_perm('change_layer', g_2024_2, capa)

exit()
```

### 3.2 Asignar Estudiantes a Grupos

**En la interfaz GeoNode:**

1. **Admin → Users → [Estudiante]**
2. **Groups**: Selecciona `estudiantes-2024-2`
3. **Save**

---

## **Paso 4: Configurar Sincronización Automática Git ↔ GeoNode**

### 4.1 GitHub Actions (opcional)

Archivo `.github/workflows/sync-to-geonode.yml`:

```yaml
name: Sync to GeoNode

on:
  push:
    branches: [main]
    paths: ['semestre-**/datos/**/*.shp']

jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Upload to GeoNode
        env:
          GEONODE_URL: ${{ secrets.GEONODE_URL }}
          GEONODE_USER: ${{ secrets.GEONODE_USER }}
          GEONODE_PASS: ${{ secrets.GEONODE_PASS }}
        run: |
          # Script que detecta archivos nuevos/modificados y los sube
          bash scripts/sync-to-geonode.sh
```

---

## **Paso 5: Visor Web Mejorado**

GeoNode proporciona visor web automáticamente, pero puedes personalizarlo:

```javascript
// Ejemplo: Integrar API de GeoNode en tu propio visor

fetch('http://tu-geonode/api/v2/layers/')
  .then(r => r.json())
  .then(data => {
    // data.results = array de todas las capas
    data.results.forEach(capa => {
      console.log(`${capa.title} (${capa.typename})`);
    });
  });
```

---

## **Timeline Recomendado**

| Fase | Duración | Hitos |
|---|---|---|
| **Fase 1: QGIS Server + Git** | 2-3 semestres | 50+ capas acumuladas |
| **Transición** | 1 mes | GeoNode instalado + datos importados |
| **Fase 2: GeoNode** | Indefinido | Operación con búsqueda, permisos, API |

---

## **Soporte**

- **Docs GeoNode**: https://docs.geonode.org
- **Comunidad**: https://discourse.geonode.org
- **Issues**: https://github.com/GeoNode/geonode/issues

---

**Cuando llegues aquí, tendrás:**
✓ Todas las capas de Fase 1 importadas
✓ Metadatos completos y buscables
✓ Permisos automáticos por semestre
✓ API REST para aplicaciones futuras
✓ Usuarios accediendo sin necesidad de QGIS

🎉 **¡Listo para escalar!**
