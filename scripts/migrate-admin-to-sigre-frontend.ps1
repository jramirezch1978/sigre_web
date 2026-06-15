# Migra consola /admin y auth desde restpe-contabilidad-front-end a 02. frontend (SIGRE)
param(
    [string]$SourceRoot = "e:\Work\sigre_web\deploy\restpe-contabilidad-front-end\src\app",
    [string]$DestRoot = "e:\Work\sigre_web\02. frontend\src\app"
)

$ErrorActionPreference = "Stop"

function Copy-Tree {
    param([string]$RelativePath)
    $src = Join-Path $SourceRoot $RelativePath
    $dst = Join-Path $DestRoot $RelativePath
    if (-not (Test-Path $src)) {
        Write-Warning "Origen no encontrado: $src"
        return
    }
    if (Test-Path $dst) { Remove-Item $dst -Recurse -Force }
    $parent = Split-Path $dst -Parent
    if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
    Copy-Item $src $dst -Recurse -Force
    Write-Host "Copiado: $RelativePath"
}

# Admin completo
Copy-Tree "admin"

# Auth completo
Copy-Tree "auth"
Get-ChildItem (Join-Path $DestRoot "auth") -Recurse -Filter "*.spec.ts" -ErrorAction SilentlyContinue | Remove-Item -Force

# Core mínimo
$coreFiles = @(
    "core/services/storage.service.ts",
    "core/services/crypto.service.ts",
    "core/services/sanitizer.service.ts",
    "core/services/session-idle.service.ts",
    "core/services/notification.service.ts",
    "core/models/api-response.model.ts",
    "core/utils/api-response.util.ts"
)
foreach ($f in $coreFiles) {
    $src = Join-Path $SourceRoot $f
    $dst = Join-Path $DestRoot $f
    if (-not (Test-Path $src)) { continue }
    $dir = Split-Path $dst -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    Copy-Item $src $dst -Force
    Write-Host "Copiado: $f"
}

# Shared mínimo
Copy-Tree "shared/models"

# UI mínimo para admin/auth
$uiPaths = @(
    "ui/modal-confirmation",
    "ui/toast-container",
    "ui/services/toast.service.ts"
)
foreach ($p in $uiPaths) {
    $src = Join-Path $SourceRoot $p
    $dst = Join-Path $DestRoot $p
    if (-not (Test-Path $src)) { continue }
    if (Test-Path $dst) { Remove-Item $dst -Recurse -Force -ErrorAction SilentlyContinue }
    $dir = Split-Path $dst -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    Copy-Item $src $dst -Recurse -Force
    Write-Host "Copiado: $p"
}

# Utility mínimo (auth signOut)
$utilSrc = Join-Path $SourceRoot "services/utility.service.ts"
$utilDst = Join-Path $DestRoot "services/utility.service.ts"
Copy-Item $utilSrc $utilDst -Force
Write-Host "Copiado: services/utility.service.ts"

# Environments
$envSrc = "e:\Work\sigre_web\deploy\restpe-contabilidad-front-end\src\environments"
$envDst = "e:\Work\sigre_web\02. frontend\src\environments"
if (-not (Test-Path $envDst)) { New-Item -ItemType Directory -Path $envDst -Force | Out-Null }
Copy-Item (Join-Path $envSrc "environment.ts") (Join-Path $envDst "environment.ts") -Force
Copy-Item (Join-Path $envSrc "environment.prod.ts") (Join-Path $envDst "environment.prod.ts") -Force -ErrorAction SilentlyContinue
Write-Host "Copiado: environments"

Write-Host "`nMigración de archivos completada. Revisar integración manual (app.routes, app.config, Gentelella shell)."
