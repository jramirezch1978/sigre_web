$ErrorActionPreference = "Stop"
$src = "e:\Work\sigre_web\deploy\02. Backend"
$dst = "e:\Work\sigre_web\03. backend"

foreach ($mod in @("common", "ms-auth-security")) {
    $from = Join-Path $src $mod
    $to = if ($mod -eq "common") { Join-Path $dst "sigre-common" } else { Join-Path $dst $mod }
    if (Test-Path $to) { Remove-Item -Recurse -Force $to }
    & robocopy $from $to /E /XD target .git /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null
    if ($LASTEXITCODE -ge 8) { throw "robocopy failed for $mod exit=$LASTEXITCODE" }
}

function Move-PackageTree {
    param([string]$Root, [string]$SubPkg)
    $old = Join-Path $Root "src\main\java\pe\restaurant\$SubPkg"
    $new = Join-Path $Root "src\main\java\com\sigre\$SubPkg"
    if (Test-Path $old) {
        New-Item -ItemType Directory -Force -Path (Split-Path $new) | Out-Null
        Move-Item -Force $old $new
        Remove-Item -Recurse -Force (Join-Path $Root "src\main\java\pe") -ErrorAction SilentlyContinue
    }
    $oldT = Join-Path $Root "src\test\java\pe\restaurant\$SubPkg"
    $newT = Join-Path $Root "src\test\java\com\sigre\$SubPkg"
    if (Test-Path $oldT) {
        New-Item -ItemType Directory -Force -Path (Split-Path $newT) | Out-Null
        Move-Item -Force $oldT $newT
        Remove-Item -Recurse -Force (Join-Path $Root "src\test\java\pe") -ErrorAction SilentlyContinue
    }
}

Move-PackageTree -Root (Join-Path $dst "sigre-common") -SubPkg "common"
Move-PackageTree -Root (Join-Path $dst "ms-auth-security") -SubPkg "auth"

$replacements = @(
    @('pe.restaurant.common', 'com.sigre.common'),
    @('pe.restaurant.auth', 'com.sigre.auth'),
    @('pe.restaurant', 'com.sigre'),
    @('restaurant_pe_security', 'sigre_security'),
    @('restaurant_pe_template', 'sigre_template'),
    @('restaurant_pe_emp_', 'sigre_emp_'),
    @('restaurant_admin', 'postgres'),
    @('Erp_restpe#2026', 'jarch32b'),
    @('Restaurant.pe Team', 'SIGRE Team'),
    @('Restaurant.pe ERP', 'SIGRE ERP'),
    @('restaurant.pe', 'sigre.local'),
    @('Restaurant.pe', 'SIGRE'),
    @('dGhpcyBpcyBhIHNlY3JldCBrZXkgZm9yIHJlc3RhdXJhbnQucGUgZXJwIGp3dCB0b2tlbiBzaWduaW5n', 'dGhpcyBpcyBhIHNlY3JldCBrZXkgZm9yIHNpZ3JlLXdlYiBlcnAgand0IHRva2VuIHNpZ25pbmc='),
    @('UmVzdGF1cmFudFBlQWVzMjU2S2V5RGV2MjAyNiEhISE=', 'U2lncmVBZXMyNTZLZXlEZXYyMDI2ISEhIQ==')
)

$exts = @('*.java', '*.xml', '*.yml', '*.yaml', '*.properties', '*.md')
foreach ($modPath in @((Join-Path $dst "sigre-common"), (Join-Path $dst "ms-auth-security"))) {
    foreach ($ext in $exts) {
        Get-ChildItem -Path $modPath -Recurse -Filter $ext -File | ForEach-Object {
            $content = [IO.File]::ReadAllText($_.FullName)
            $orig = $content
            foreach ($pair in $replacements) {
                $content = $content.Replace($pair[0], $pair[1])
            }
            if ($content -ne $orig) {
                [IO.File]::WriteAllText($_.FullName, $content)
            }
        }
    }
}

Write-Host "OK: sigre-common + ms-auth-security copied and adapted"
