# ✅ Checklist Único de Implementación
## Sistema SIG Colaborativo — ITESO

Este es el **plan consolidado final** (fusiona el plan original + el ajuste de sincronización automática).

---

## 📅 Semana 0: Repositorio y Sincronización

- [ ] Crear repositorio en GitHub (público o privado)
  ```bash
  mkdir repositorio-sig-iteso && cd repositorio-sig-iteso
  git init
  git remote add origin https://github.com/ITESO/repositorio-sig-iteso.git
  ```
- [ ] Crear estructura base de carpetas (`repositorio-estructura.md`)
- [ ] Copiar `sync-qgis-server.yml` a `.github/workflows/sync-qgis-server.yml`
- [ ] Ejecutar `./setup-github-sync.sh` (genera clave SSH + guía de secrets)
- [ ] Configurar los 3 secrets en GitHub (`DEPLOY_KEY`, `SERVER_IP`, `SERVER_USER`)
- [ ] Hacer commit y push inicial:
  ```bash
  git add .
  git commit -m "Estructura base + sincronización automática"
  git push -u origin main
  ```

---

## 📅 Semana 1: Servidor QGIS

- [ ] Instalar QGIS Server en servidor ITESO (`01-instalacion-qgis-server.md`)
- [ ] Instalar Apache + FastCGI
- [ ] Configurar carpeta `/var/www/qgis-projects/` como repo Git (clon del mismo repo)
- [ ] Probar conectividad SSH desde GitHub Actions al servidor
- [ ] Probar sincronización de extremo a extremo (push de prueba → verificar en servidor)
- [ ] Verificar QGIS Server responde:
  ```bash
  curl "http://tu-servidor/qgis_mapserv.fcgi?request=GetCapabilities&service=WMS"
  ```

---

## 📅 Semana 2: Estructura de Datos + Metadatos

- [ ] Crear carpeta `semestre-2024-2/` con estructura de capas
- [ ] Cargar proyecto QGIS base (`amg-base.qgs`) con capas iniciales
- [ ] Aplicar plantilla de metadatos (`PLANTILLA-METADATA-capa.md`) a cada capa existente
- [ ] Llenar `metadatos.csv` con inventario inicial

---

## 📅 Semana 3: Visor Web + Capacitación de Estudiantes

- [ ] Configurar `visor-web-index.html` con URL real del servidor QGIS
- [ ] Publicar visor web (hosting simple: GitHub Pages, Netlify, o servidor ITESO)
- [ ] Sesión de capacitación con estudiantes:
  - [ ] Instalar Git + QGIS (guía: `02-guia-estudiantes.md`)
  - [ ] Clonar repositorio
  - [ ] Practicar: editar capa → commit → push
  - [ ] Enseñar a verificar cambios (`05-guia-rapida-estudiantes-ver-cambios.md`)
- [ ] Prueba real: cada estudiante hace un push de prueba y confirma que ve su cambio en el visor (~30-60 seg de espera)

---

## 📅 Semana 4: Operación Regular

- [ ] Estudiantes trabajando de forma independiente desde sus PCs
- [ ] Monitorear GitHub Actions (pestaña **Actions**) por posibles fallos de sincronización
- [ ] Resolver dudas / conflictos de Git según se presenten

---

## 📅 Fin de Semestre: Congelar Versión

- [ ] Revisar que todas las capas tengan metadatos completos
- [ ] Generar reporte de capas:
  ```bash
  ./automatizar-versionado.sh reporte 2024-2
  ```
- [ ] Congelar versión con tag:
  ```bash
  ./automatizar-versionado.sh crear-tag 2024-2
  ```

---

## 📅 Inicio de Nuevo Semestre: Herencia

- [ ] Crear nuevo semestre heredando el anterior:
  ```bash
  ./automatizar-versionado.sh crear-semestre 2025-1
  ```
- [ ] Repetir capacitación con nueva cohorte (Semana 3, adaptada)
- [ ] Continuar operación regular

---

## 🚀 Criterios para Evaluar Migración a GeoNode (Fase 2)

Revisar solo después de 2-3 semestres:

- [ ] ¿Se acumularon 40+ capas?
- [ ] ¿Los estudiantes dominan Git sin fricción?
- [ ] ¿El visor web y la sincronización han sido estables?
- [ ] ¿Se necesita búsqueda avanzada, permisos por usuario, o API robusta?

Si respondiste sí a la mayoría → consulta `03-migracion-a-geonode.md`

---

## 📁 Referencia Rápida de Archivos

| Fase | Archivo a usar |
|------|-----------------|
| Setup sincronización | `sync-qgis-server.yml`, `setup-github-sync.sh` |
| Instalar servidor | `01-instalacion-qgis-server.md` |
| Estructura de carpetas | `repositorio-estructura.md` |
| Metadatos de capas | `PLANTILLA-METADATA-capa.md` |
| Capacitar estudiantes | `02-guia-estudiantes.md`, `05-guia-rapida-estudiantes-ver-cambios.md` |
| Visor web | `visor-web-index.html` |
| Versionado semestral | `automatizar-versionado.sh` |
| Entender la arquitectura | `04-acceso-descentralizado-analisis.md` |
| Escalar a futuro | `03-migracion-a-geonode.md` |
