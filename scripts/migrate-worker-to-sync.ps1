# Integra ms-worker en sync-service sin sobrescribir codigo existente
$ErrorActionPreference = 'Stop'
$Root = Split-Path $PSScriptRoot -Parent
$SourceRoot = Join-Path $Root 'deploy\02. Backend\ms-worker\src'
$TargetRoot = Join-Path $Root '03. backend\sync-service\src'

function Copy-WorkerSources {
    param([string]$RootKind)

    $srcBase = Join-Path (Join-Path (Join-Path $SourceRoot $RootKind) 'java') 'pe\restaurant\worker'
    $dstBase = Join-Path (Join-Path (Join-Path $TargetRoot $RootKind) 'java') 'com\sigre\sync\worker'
    if (-not (Test-Path $srcBase)) { return }

    Get-ChildItem -Path $srcBase -Recurse -File -Filter '*.java' | ForEach-Object {
        $rel = $_.FullName.Substring($srcBase.Length).TrimStart('\')
        if ($rel -eq 'WorkerApplication.java') { return }
        $targetFile = Join-Path $dstBase $rel
        New-Item -ItemType Directory -Force -Path (Split-Path $targetFile -Parent) | Out-Null
        Copy-Item -Force $_.FullName $targetFile
    }
}

Copy-WorkerSources 'main'
Copy-WorkerSources 'test'

$replacements = @(
    @{ Old = 'pe.restaurant.worker'; New = 'com.sigre.sync.worker' },
    @{ Old = 'pe/restaurant/worker'; New = 'com/sigre/sync/worker' },
    @{ Old = 'pe.restaurant.common'; New = 'com.sigre.common' },
    @{ Old = 'pe/restaurant/common'; New = 'com/sigre/common' },
    @{ Old = 'ms-activos-fijos-jobs'; New = 'activo-fijo-service' },
    @{ Old = 'restaurant_pe_security'; New = 'sigre_security' },
    @{ Old = 'restaurant_pe_template'; New = 'sigre_template' },
    @{ Old = 'restaurant_admin'; New = 'postgres' },
    @{ Old = 'R3st4ur4nt_D3v!'; New = 'jarch32b' },
    @{ Old = 'R4bb1t_D3v!'; New = 'sigre' },
    @{ Old = 'UmVzdGF1cmFudFBlQWVzMjU2S2V5RGV2MjAyNiEhISE='; New = 'U2lncmVFcnBXZWJBZXMyNTZLZXlEZXYyMDI2ISEhISE=' },
    @{ Old = 'dGhpcyBpcyBhIHNlY3JldCBrZXkgZm9yIHJlc3RhdXJhbnQucGUgZXJwIGp3dCB0b2tlbiBzaWduaW5n'; New = 'dGhpcyBpcyBhIHNlY3JldCBrZXkgZm9yIHNpZ3JlLXdlYiBlcnAgand0IHRva2VuIHNpZ25pbmc=' }
)

Get-ChildItem -Path (Join-Path $TargetRoot '') -Recurse -File -Filter '*.java' |
    Where-Object { $_.FullName -match '\\com\\sigre\\sync\\worker\\' } |
    ForEach-Object {
        $content = [IO.File]::ReadAllText($_.FullName)
        $original = $content
        foreach ($r in $replacements) {
            $content = $content.Replace($r.Old, $r.New)
        }
        if ($content -ne $original) {
            [IO.File]::WriteAllText($_.FullName, $content)
        }
    }

Write-Host 'OK: ms-worker copiado a com.sigre.sync.worker'
