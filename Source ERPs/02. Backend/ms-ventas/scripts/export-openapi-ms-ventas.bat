@echo off
setlocal EnableExtensions
REM Exporta la especificacion OpenAPI 3 generada por SpringDoc (incluye APIs nuevas y existentes).
REM Requisito: ms-ventas en ejecucion (puerto por defecto 9010).
REM Salida: docs\openapi\ms-ventas-openapi.json y .yaml

cd /d "%~dp0.."

if defined MS_VENTAS_OPENAPI_URL (
  set "BASE=%MS_VENTAS_OPENAPI_URL%"
) else (
  set "BASE=http://localhost:9010"
)

set "OUT=%CD%\docs\openapi"
if not exist "%OUT%" mkdir "%OUT%" 2>nul

echo.
echo [export-openapi-ms-ventas] Base URL: %BASE%
echo [export-openapi-ms-ventas] Destino:  %OUT%
echo.

curl -sS -f -o "%OUT%\ms-ventas-openapi.json" "%BASE%/api/ventas/v3/api-docs"
if errorlevel 1 (
  echo ERROR: No se pudo descargar JSON. Verifique que el servicio este arriba y la URL sea correcta.
  echo        Variable opcional: MS_VENTAS_OPENAPI_URL ^(ej. http://127.0.0.1:9010^)
  exit /b 1
)

curl -sS -f -o "%OUT%\ms-ventas-openapi.yaml" "%BASE%/api/ventas/v3/api-docs.yaml"
if errorlevel 1 (
  echo ADVERTENCIA: YAML no disponible en esta version/ruta; queda solo JSON.
  del "%OUT%\ms-ventas-openapi.yaml" 2>nul
) else (
  echo OK: ms-ventas-openapi.yaml
)

echo OK: ms-ventas-openapi.json
echo.
echo Postman: Importar ^> archivo ^> ms-ventas-openapi.json
echo Swagger UI: %BASE%/api/ventas/swagger-ui.html
echo.
endlocal
exit /b 0
