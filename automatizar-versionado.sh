#!/bin/bash

# Script: Automatizar versionado de capas SIG por semestre
# Uso: ./automatizar-versionado.sh crear-semestre 2025-1
#      ./automatizar-versionado.sh crear-tag 2024-2

set -e

# Colores para salida
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

REPO_ROOT=$(pwd)

# ============================================
# FUNCIÓN: Crear nuevo semestre (herencia)
# ============================================

crear_semestre() {
    SEMESTRE=$1
    
    if [ -z "$SEMESTRE" ]; then
        echo -e "${RED}Error: Especifica semestre. Uso: ./script.sh crear-semestre 2025-1${NC}"
        exit 1
    fi
    
    # Encontrar semestre anterior
    SEMESTRE_ANTERIOR=$(ls -d semestre-* | sort -V | tail -1)
    
    if [ -z "$SEMESTRE_ANTERIOR" ]; then
        echo -e "${RED}Error: No hay semestres anteriores. Crea uno manualmente.${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}Creando semestre $SEMESTRE heredando de $SEMESTRE_ANTERIOR...${NC}"
    
    # Copiar estructura
    cp -r "$SEMESTRE_ANTERIOR" "semestre-$SEMESTRE"
    
    # Crear carpeta CHANGELOG
    cat > "semestre-$SEMESTRE/CHANGELOG.md" << EOF
# Cambios - Semestre $SEMESTRE

## Nuevas Capas

- [Agrega aquí nuevas capas creadas este semestre]

## Capas Actualizadas

- [Capas que se actualizaron desde semestre anterior]

## Capas Heredadas

Todas las capas de **$SEMESTRE_ANTERIOR** están disponibles sin cambios:

\`\`\`
semestre-$SEMESTRE_ANTERIOR/datos/
├── uso-suelo/
├── limites-administrativos/
├── infraestructura/
└── [más carpetas...]
\`\`\`

## Estadísticas

- Nuevas capas: 
- Capas actualizadas: 
- Total de capas disponibles: 

---

*Genera este resumen al final del semestre*
EOF

    # Actualizar metadatos.csv
    echo "Capa,Semestre,Tipo,Fuente,Fecha,Autor" > "semestre-$SEMESTRE/metadatos.csv"
    echo "# Actualiza este archivo conforme crees/edites capas" >> "semestre-$SEMESTRE/metadatos.csv"
    
    # Agregar a Git
    git add "semestre-$SEMESTRE/"
    git commit -m "Herencia: crear semestre $SEMESTRE desde $SEMESTRE_ANTERIOR"
    
    echo -e "${GREEN}✓ Semestre $SEMESTRE creado exitosamente${NC}"
    echo -e "${GREEN}Próximo paso: git push origin main${NC}"
}

# ============================================
# FUNCIÓN: Crear tag de versión final
# ============================================

crear_tag() {
    SEMESTRE=$1
    
    if [ -z "$SEMESTRE" ]; then
        echo -e "${RED}Error: Especifica semestre. Uso: ./script.sh crear-tag 2024-2${NC}"
        exit 1
    fi
    
    if [ ! -d "semestre-$SEMESTRE" ]; then
        echo -e "${RED}Error: Carpeta semestre-$SEMESTRE no existe${NC}"
        exit 1
    fi
    
    TAG="v${SEMESTRE}-final"
    
    echo -e "${YELLOW}Creando tag $TAG...${NC}"
    
    # Verificar que no exista ya
    if git rev-parse "$TAG" >/dev/null 2>&1; then
        echo -e "${YELLOW}Aviso: Tag $TAG ya existe. Usa otro nombre o elimina primero.${NC}"
        exit 1
    fi
    
    # Crear tag anotado
    git tag -a "$TAG" -m "Versión final del semestre $SEMESTRE - $(date +%Y-%m-%d)"
    
    # Push
    git push origin "$TAG"
    
    echo -e "${GREEN}✓ Tag $TAG creado y subido a GitHub${NC}"
    echo -e "${GREEN}Próxima cohorte puede descargar con: git checkout $TAG${NC}"
}

# ============================================
# FUNCIÓN: Generar reporte de capas
# ============================================

generar_reporte() {
    SEMESTRE=$1
    
    if [ -z "$SEMESTRE" ]; then
        echo -e "${RED}Error: Especifica semestre. Uso: ./script.sh reporte 2024-2${NC}"
        exit 1
    fi
    
    if [ ! -d "semestre-$SEMESTRE" ]; then
        echo -e "${RED}Error: Carpeta semestre-$SEMESTRE no existe${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}Generando reporte para semestre $SEMESTRE...${NC}"
    
    REPORTE="REPORTE-$SEMESTRE.md"
    
    cat > "$REPORTE" << EOF
# Reporte de Capas - Semestre $SEMESTRE

Generado: $(date)

## Resumen

| Métrica | Valor |
|---------|-------|
| **Total de carpetas de datos** | $(find "semestre-$SEMESTRE/datos" -maxdepth 1 -type d | wc -l) |
| **Total de archivos** | $(find "semestre-$SEMESTRE/datos" -type f | wc -l) |
| **Tamaño total** | $(du -sh "semestre-$SEMESTRE" \| cut -f1) |

## Capas por Categoría

EOF

    # Listar capas
    for categoria in $(ls "semestre-$SEMESTRE/datos/" 2>/dev/null | sort); do
        if [ -d "semestre-$SEMESTRE/datos/$categoria" ]; then
            echo "### $categoria" >> "$REPORTE"
            
            # Listar archivos en cada categoría
            find "semestre-$SEMESTRE/datos/$categoria" -maxdepth 1 -type f ! -name "README.md" -exec basename {} \; | sort | while read archivo; do
                echo "- $archivo" >> "$REPORTE"
            done
            
            # Si existe README, incluir extracto
            if [ -f "semestre-$SEMESTRE/datos/$categoria/README.md" ]; then
                echo "" >> "$REPORTE"
                echo "**Metadatos:**" >> "$REPORTE"
                head -20 "semestre-$SEMESTRE/datos/$categoria/README.md" | grep -E "^-" >> "$REPORTE" || true
                echo "" >> "$REPORTE"
            fi
        fi
    done
    
    echo -e "${GREEN}✓ Reporte generado: $REPORTE${NC}"
}

# ============================================
# FUNCIÓN: Listar versiones disponibles
# ============================================

listar_versiones() {
    echo -e "${YELLOW}Versiones disponibles en el repositorio:${NC}"
    echo ""
    
    # Semestres (carpetas)
    echo -e "${GREEN}Semestres:${NC}"
    ls -d semestre-* 2>/dev/null | sort -V | while read sem; do
        SIZE=$(du -sh "$sem" | cut -f1)
        CAPAS=$(find "$sem/datos" -maxdepth 1 -type d | wc -l)
        echo "  • $sem ($SIZE, $CAPAS categorías)"
    done
    
    echo ""
    
    # Tags en Git
    echo -e "${GREEN}Versiones congeladas (Git tags):${NC}"
    git tag -l "v*-final" | sort -V | while read tag; do
        FECHA=$(git log -1 --format=%ai "$tag" | cut -d' ' -f1)
        echo "  • $tag (congelado $FECHA)"
    done
}

# ============================================
# MAIN
# ============================================

COMANDO=$1

case "$COMANDO" in
    crear-semestre)
        crear_semestre "$2"
        ;;
    crear-tag)
        crear_tag "$2"
        ;;
    reporte)
        generar_reporte "$2"
        ;;
    listar)
        listar_versiones
        ;;
    *)
        echo -e "${GREEN}Uso: ./automatizar-versionado.sh <comando> [args]${NC}"
        echo ""
        echo "Comandos disponibles:"
        echo "  crear-semestre <semestre>    Crear nuevo semestre heredando del anterior"
        echo "  crear-tag <semestre>         Congelar versión con Git tag"
        echo "  reporte <semestre>           Generar reporte de capas"
        echo "  listar                       Listar todas las versiones disponibles"
        echo ""
        echo "Ejemplos:"
        echo "  ./automatizar-versionado.sh crear-semestre 2025-1"
        echo "  ./automatizar-versionado.sh crear-tag 2024-2"
        echo "  ./automatizar-versionado.sh reporte 2024-2"
        echo "  ./automatizar-versionado.sh listar"
        ;;
esac
