# 🤝 Guía Rápida para Contribuir

Este documento resume cómo colaborar en el repositorio. Para el flujo completo con capturas y detalle, ve a [docs/02-guia-estudiantes.md](docs/02-guia-estudiantes.md).

## Resumen

1. Clona el repositorio: `git clone https://github.com/agil-iteso/repositorio-sig-labter.git`
2. Abre `semestre-2026-2/qgis-projects/amg-base.qgs` en QGIS
3. Edita o crea tu capa
4. Expórtala también a **GeoJSON** (CRS EPSG:4326) — el visor web la necesita en ese formato
5. Documenta con `README.md` en la carpeta de la capa (usa [PLANTILLA-METADATA-capa.md](PLANTILLA-METADATA-capa.md))
6. Si es capa nueva, regístrala en `visor-web/config.json`
7. Sube tus cambios:
   ```bash
   git add semestre-2026-2/datos/tu-tema/ visor-web/config.json
   git commit -m "Descripción clara de tu cambio"
   git push origin main
   ```
8. Verifica en el visor web: https://agil-iteso.github.io/repositorio-sig-labter/visor-web/

## Reglas básicas

- **Mensajes de commit descriptivos**: qué hiciste, no cómo ("Agregadas 50 calles nuevas", no "cambios").
- **Metadatos completos**: cada capa nueva necesita su README.md con fuente, fecha, autor y escala.
- **Proyección**: digitaliza en EPSG:32613 (UTM zona 13); exporta a EPSG:4326 solo para el GeoJSON del visor.
- **Conflictos de Git**: si dos personas editan la misma capa, Git avisará — resuélvanlo juntos o pidan ayuda al profesor.

## ¿Dudas?

Abre un Issue en GitHub o pregunta en clase. Toda la documentación técnica vive en [`/docs`](docs/).
