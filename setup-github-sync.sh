#!/bin/bash

# Script: Configurar sincronización automática GitHub Actions → QGIS Server
# Uso: ./setup-github-sync.sh

set -e

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Setup: GitHub Actions → QGIS Server${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# ============================================
# Paso 1: Verificar requisitos
# ============================================

echo -e "${YELLOW}[1/5] Verificando requisitos...${NC}"

if ! command -v ssh-keygen &> /dev/null; then
    echo -e "${RED}✗ ssh-keygen no está instalado${NC}"
    exit 1
fi

if ! command -v git &> /dev/null; then
    echo -e "${RED}✗ git no está instalado${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Requisitos OK (ssh-keygen, git)${NC}"
echo ""

# ============================================
# Paso 2: Información del servidor
# ============================================

echo -e "${YELLOW}[2/5] Configuración del servidor QGIS${NC}"

read -p "IP o hostname del servidor (ej: sig.iteso.mx): " SERVER_IP
read -p "Usuario SSH (ej: ubuntu): " SERVER_USER

echo -e "${YELLOW}Verificando conectividad...${NC}"

if ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=accept-new "$SERVER_USER@$SERVER_IP" "pwd" &> /dev/null; then
    echo -e "${GREEN}✓ Conectividad verificada${NC}"
else
    echo -e "${RED}✗ No se puede conectar al servidor${NC}"
    echo "Verifica que:"
    echo "  1. El servidor está activo"
    echo "  2. El usuario y hostname son correctos"
    echo "  3. Tienes acceso SSH"
    exit 1
fi

echo ""

# ============================================
# Paso 3: Generar SSH key
# ============================================

echo -e "${YELLOW}[3/5] Generando clave SSH...${NC}"

KEY_NAME="qgis-deploy-key"
KEY_PATH="$HOME/.ssh/$KEY_NAME"

if [ -f "$KEY_PATH" ]; then
    echo -e "${YELLOW}Advertencia: $KEY_PATH ya existe${NC}"
    read -p "¿Deseas regenerarla? (s/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        echo -e "${YELLOW}Usando clave existente${NC}"
    else
        rm "$KEY_PATH" "$KEY_PATH.pub"
        ssh-keygen -t rsa -b 4096 -f "$KEY_PATH" -N "" -q
        echo -e "${GREEN}✓ Clave SSH generada${NC}"
    fi
else
    ssh-keyscan -H "$SERVER_IP" >> "$HOME/.ssh/known_hosts" 2>/dev/null || true
    ssh-keygen -t rsa -b 4096 -f "$KEY_PATH" -N "" -q
    echo -e "${GREEN}✓ Clave SSH generada${NC}"
fi

echo ""

# ============================================
# Paso 4: Copiar clave pública al servidor
# ============================================

echo -e "${YELLOW}[4/5] Autorizando clave en servidor...${NC}"

ssh-copy-id -i "${KEY_PATH}.pub" -o StrictHostKeyChecking=accept-new "$SERVER_USER@$SERVER_IP" &> /dev/null

# Verificar que funciona
if ssh -i "$KEY_PATH" -o ConnectTimeout=5 "$SERVER_USER@$SERVER_IP" "pwd" &> /dev/null; then
    echo -e "${GREEN}✓ Clave SSH autorizada en servidor${NC}"
else
    echo -e "${RED}✗ Error autorizando clave${NC}"
    exit 1
fi

echo ""

# ============================================
# Paso 5: Mostrar secrets para GitHub
# ============================================

echo -e "${YELLOW}[5/5] Configurando secrets en GitHub...${NC}"
echo ""

PRIVATE_KEY=$(cat "$KEY_PATH")

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}⚠️  SECRETS PARA GITHUB${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

echo "Abre tu repositorio en GitHub y ve a:"
echo "  Settings → Secrets and variables → Actions"
echo ""

echo "Crea estos 3 secrets:"
echo ""

echo -e "${YELLOW}1. DEPLOY_KEY${NC}"
echo "Tipo: Repository secret"
echo "Valor (copia TODO lo de abajo):"
echo "────────────────────────────────────────────────"
echo "$PRIVATE_KEY"
echo "────────────────────────────────────────────────"
echo ""

echo -e "${YELLOW}2. SERVER_IP${NC}"
echo "Tipo: Repository secret"
echo "Valor: $SERVER_IP"
echo ""

echo -e "${YELLOW}3. SERVER_USER${NC}"
echo "Tipo: Repository secret"
echo "Valor: $SERVER_USER"
echo ""

echo -e "${BLUE}========================================${NC}"
echo ""

# Opción para copiar al portapapeles (si está disponible)
if command -v xclip &> /dev/null; then
    echo -n "$PRIVATE_KEY" | xclip -selection clipboard
    echo -e "${GREEN}✓ Clave privada copiada al portapapeles${NC}"
    echo "  Puedes pegar directamente en GitHub"
elif command -v pbcopy &> /dev/null; then
    echo -n "$PRIVATE_KEY" | pbcopy
    echo -e "${GREEN}✓ Clave privada copiada al portapapeles (macOS)${NC}"
fi

echo ""

# ============================================
# Paso 6: Instrucciones finales
# ============================================

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}PRÓXIMOS PASOS${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

echo "1. Copia los 3 secrets arriba y pégalos en GitHub"
echo ""

echo "2. Descarga el archivo de workflow:"
echo "   curl -o .github/workflows/sync-qgis-server.yml https://raw.githubusercontent.com/ITESO/repositorio-sig-iteso/main/sync-qgis-server.yml"
echo ""

echo "3. Commit y push:"
echo "   git add .github/workflows/sync-qgis-server.yml"
echo "   git commit -m 'Add automatic sync workflow'"
echo "   git push origin main"
echo ""

echo "4. Verifica que funciona:"
echo "   GitHub → Actions → Workflow name → Ver logs"
echo ""

echo -e "${GREEN}✓ Setup completado${NC}"
echo ""

echo -e "${BLUE}Información de configuración guardada en:${NC}"
echo "  Servidor: $SERVER_IP"
echo "  Usuario: $SERVER_USER"
echo "  Clave: $KEY_PATH"
echo ""

echo "¡La sincronización automática está lista!"
echo "Cada vez que hagas 'git push', los cambios se sincronizarán automáticamente."
echo ""
