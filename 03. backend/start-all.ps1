# Script para iniciar todos los microservicios
$backend = "D:\Work\sigre_web\03. backend"

Write-Host "Iniciando Discovery Server..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$backend\discovery-server'; mvn spring-boot:run"

Start-Sleep -Seconds 10

Write-Host "Iniciando API Gateway..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$backend\api-gateway'; mvn spring-boot:run"

Start-Sleep -Seconds 5

Write-Host "Iniciando Products Service..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$backend\products-service'; mvn spring-boot:run"

Start-Sleep -Seconds 5

Write-Host "Iniciando Inventory Service..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$backend\inventory-service'; mvn spring-boot:run"

Start-Sleep -Seconds 5

Write-Host "Iniciando Orders Service..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$backend\orders-service'; mvn spring-boot:run"

Start-Sleep -Seconds 5

Write-Host "Iniciando Asistencia Service..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$backend\asistencia-service'; mvn spring-boot:run"

Write-Host "Todos los servicios están iniciando..." -ForegroundColor Yellow