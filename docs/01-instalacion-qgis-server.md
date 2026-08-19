# Instalación QGIS Server en Ubuntu

## Opción A: Instalación Local en tu máquina (para testing)

### 1. Instalar QGIS Server

```bash
# Actualizar repositorios
sudo apt update

# Instalar QGIS Server (incluye PostGIS automáticamente)
sudo apt install qgis-server qgis-provider-postgres libqgis-server -y

# Verificar instalación
qgis_mapserv.fcgi --version
```

### 2. Instalar Apache + FastCGI

```bash
# Apache + módulo FastCGI
sudo apt install apache2 libapache2-mod-fcgid -y

# Habilitar módulos necesarios
sudo a2enmod rewrite
sudo a2enmod fcgid
sudo systemctl restart apache2
```

### 3. Configurar Apache para QGIS Server

Edita `/etc/apache2/sites-available/qgis-server.conf`:

```apache
<VirtualHost *:80>
    ServerName sig.tu-dominio.local
    ServerAdmin admin@ejemplo.com
    DocumentRoot /var/www/qgis-server

    # Logs
    ErrorLog ${APACHE_LOG_DIR}/qgis-error.log
    CustomLog ${APACHE_LOG_DIR}/qgis-access.log combined

    # FastCGI para QGIS Server
    <Directory /var/www/qgis-server>
        AllowOverride All
        Require all granted
        AddHandler fcgid-script .fcgi
        Options +ExecCGI
    </Directory>

    # Alias para scripts FCGi
    ScriptAlias / /var/www/qgis-server/qgis_mapserv.fcgi/

    # CORS (para visor web)
    Header always set Access-Control-Allow-Origin "*"
    Header always set Access-Control-Allow-Methods "GET, POST, OPTIONS"
    Header always set Access-Control-Allow-Headers "Content-Type"
</VirtualHost>
```

Habilita y reinicia:
```bash
sudo a2ensite qgis-server
sudo systemctl restart apache2
```

### 4. Copiar QGIS MapServ al DocumentRoot

```bash
# Crear directorio
sudo mkdir -p /var/www/qgis-server
sudo chown www-data:www-data /var/www/qgis-server

# Copiar ejecutable FCGi (ubicación varía según tu sistema)
# Encuentra dónde está:
which qgis_mapserv.fcgi

# Copia (ejemplo, ajusta la ruta):
sudo cp /usr/lib/cgi-bin/qgis_mapserv.fcgi /var/www/qgis-server/
sudo chown www-data:www-data /var/www/qgis-server/qgis_mapserv.fcgi
sudo chmod 755 /var/www/qgis-server/qgis_mapserv.fcgi
```

---

## Opción B: Instalación en Servidor (AWS/DigitalOcean)

Si vas a un VPS pequeño (t2.micro AWS o Droplet básico):

```bash
#!/bin/bash
# Script instalación rápida QGIS Server + PostGIS

sudo apt update && sudo apt upgrade -y

# QGIS + PostGIS
sudo apt install qgis-server postgresql postgresql-contrib postgis -y

# Apache
sudo apt install apache2 libapache2-mod-fcgid -y
sudo a2enmod rewrite fcgid headers

# Crear carpeta de proyectos
sudo mkdir -p /var/www/qgis-projects
sudo chown ubuntu:ubuntu /var/www/qgis-projects

# Copiar config Apache (crea archivo qgis-server.conf como arriba)
# ...

# Permisos
sudo chown www-data:www-data /var/www/qgis-server
sudo chmod 755 /var/www/qgis-server/qgis_mapserv.fcgi

# Reiniciar
sudo systemctl restart apache2
```

---

## Opción C: Docker (Más fácil si tienes Docker instalado)

```bash
# Imagen oficial QGIS Server
docker run -d \
  --name qgis-server \
  -p 8080:80 \
  -v /ruta/a/proyectos:/io/data \
  qgis/qgis:latest-server

# El servidor estará en http://localhost:8080
```

---

## Prueba de Funcionamiento

Una vez instalado, prueba si funciona:

```bash
# Local:
curl "http://localhost/qgis_mapserv.fcgi?request=GetCapabilities&service=WMS"

# Remoto:
curl "http://tu-ip:8080/qgis_mapserv.fcgi?request=GetCapabilities&service=WMS"
```

Deberías recibir un XML con las capacidades del servidor WMS.

---

## Próximo Paso

Una vez confirmado que funciona:
1. Copia tu archivo `.qgs` (proyecto QGIS) a `/var/www/qgis-projects/amg-base.qgs`
2. Accede a: `http://tu-servidor/qgis_mapserv.fcgi?map=/var/www/qgis-projects/amg-base.qgs&request=GetCapabilities&service=WMS`
3. El visor Leaflet (paso siguiente) consumirá este servicio WMS
