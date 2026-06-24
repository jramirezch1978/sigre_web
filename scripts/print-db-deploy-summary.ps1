param(
    [Parameter(Mandatory = $true)][string]$Database,
    [Parameter(Mandatory = $true)][string]$DeployLog,
    [Parameter(Mandatory = $true)][string]$PgHost,
    [Parameter(Mandatory = $true)][int]$PgPort,
    [Parameter(Mandatory = $true)][string]$PgUser,
    [Parameter(Mandatory = $true)][string]$PgPassword,
    [string]$PgSqlImage = 'postgres:17-alpine',
    [string]$PgSslMode = 'disable'
)

$ErrorActionPreference = 'Stop'

function Write-SummaryLine([string]$Text) {
    Write-Host $Text
    Add-Content -Path $DeployLog -Value $Text -Encoding UTF8
}

function Invoke-Psql([string]$Sql, [switch]$TuplesOnly) {
    $args = @(
        'run', '--rm',
        '-e', "PGPASSWORD=$PgPassword",
        '-e', "PGSSLMODE=$PgSslMode",
        $PgSqlImage,
        'psql',
        '-h', $PgHost,
        '-p', "$PgPort",
        '-U', $PgUser,
        '-d', $Database,
        '-v', 'ON_ERROR_STOP=1',
        '-c', $Sql
    )
    if ($TuplesOnly) { $args += @('-t', '-A', '-F', "`t") }
    $output = & docker @args 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw ($output | Out-String)
    }
    return $output
}

function Get-SeedInsertSummary([string]$LogPath) {
    if (-not (Test-Path -LiteralPath $LogPath)) { return @() }

    $lines = Get-Content -LiteralPath $LogPath -Encoding UTF8
    $results = [System.Collections.Generic.List[object]]::new()
    $currentFile = $null
    $insertTotal = 0
    $copyTotal = 0

    foreach ($line in $lines) {
        if ($line -match '^>> --- (.+?) ---') {
            if ($currentFile -and ($insertTotal -gt 0 -or $copyTotal -gt 0)) {
                $results.Add([pscustomobject]@{
                        File   = $currentFile
                        Inserts = $insertTotal
                        Copies  = $copyTotal
                        Total   = $insertTotal + $copyTotal
                    })
            }
            $currentFile = $Matches[1]
            $insertTotal = 0
            $copyTotal = 0
            continue
        }

        if (-not $currentFile) { continue }

        if ($line -match '^INSERT 0 (\d+)$') {
            $insertTotal += [int]$Matches[1]
        }
        elseif ($line -match '^COPY (\d+)$') {
            $copyTotal += [int]$Matches[1]
        }
    }

    if ($currentFile -and ($insertTotal -gt 0 -or $copyTotal -gt 0)) {
        $results.Add([pscustomobject]@{
                File    = $currentFile
                Inserts = $insertTotal
                Copies  = $copyTotal
                Total   = $insertTotal + $copyTotal
            })
    }

    return $results
}

Write-SummaryLine ''
Write-SummaryLine ('=' * 78)
Write-SummaryLine " RESUMEN DEPLOY — $Database @ ${PgHost}:${PgPort}"
Write-SummaryLine ('=' * 78)

Invoke-Psql 'ANALYZE;' | Out-Null

$tableRows = Invoke-Psql @"
SELECT schemaname, relname, COALESCE(n_live_tup, 0)::bigint
FROM pg_stat_user_tables
WHERE schemaname NOT IN ('pg_toast')
ORDER BY schemaname, relname;
"@ -TuplesOnly

$bySchema = @{}
$grandTables = 0
$grandRows = [int64]0

foreach ($line in $tableRows) {
    if ([string]::IsNullOrWhiteSpace($line)) { continue }
    $parts = $line -split "`t", 3
    if ($parts.Count -lt 3) { continue }

    $schema = $parts[0]
    $table = $parts[1]
    $rows = [int64]$parts[2]

    if (-not $bySchema.ContainsKey($schema)) {
        $bySchema[$schema] = [System.Collections.Generic.List[object]]::new()
    }
    $bySchema[$schema].Add([pscustomobject]@{
            Table = $table
            Rows  = $rows
        })
    $grandTables++
    $grandRows += $rows
}

Write-SummaryLine ''
Write-SummaryLine '--- Inventario por schema (tablas y filas) ---'
Write-SummaryLine ''

foreach ($schema in ($bySchema.Keys | Sort-Object)) {
    $tables = $bySchema[$schema]
    $schemaRows = ($tables | Measure-Object -Property Rows -Sum).Sum
    if ($null -eq $schemaRows) { $schemaRows = 0 }

    Write-SummaryLine ("[{0}] {1} tablas, {2:N0} filas" -f $schema, $tables.Count, $schemaRows)
    foreach ($t in ($tables | Sort-Object Table)) {
        Write-SummaryLine ("  {0,-48} {1,12:N0}" -f $t.Table, $t.Rows)
    }
    Write-SummaryLine ''
}

Write-SummaryLine '--- Totales ---'
Write-SummaryLine ("  Schemas : {0}" -f $bySchema.Count)
Write-SummaryLine ("  Tablas  : {0}" -f $grandTables)
Write-SummaryLine ("  Filas   : {0:N0}" -f $grandRows)

$seedSummary = Get-SeedInsertSummary -LogPath $DeployLog |
    Where-Object { $_.File -match '(^|/)seed/' -and $_.Total -gt 0 } |
    Sort-Object File

if ($seedSummary.Count -gt 0) {
    Write-SummaryLine ''
    Write-SummaryLine '--- Seed ejecutado (filas reportadas por psql) ---'
    Write-SummaryLine ''
    $seedGrand = [int64]0
    foreach ($item in $seedSummary) {
        $detail = if ($item.Copies -gt 0 -and $item.Inserts -gt 0) {
            "INSERT {0:N0} + COPY {1:N0}" -f $item.Inserts, $item.Copies
        }
        elseif ($item.Copies -gt 0) {
            "COPY {0:N0}" -f $item.Copies
        }
        else {
            "INSERT {0:N0}" -f $item.Inserts
        }
        Write-SummaryLine ("  {0,-52} {1,12:N0}  ({2})" -f $item.File, $item.Total, $detail)
        $seedGrand += $item.Total
    }
    Write-SummaryLine ''
    Write-SummaryLine ("  Total filas seed (psql) : {0:N0}" -f $seedGrand)
}

Write-SummaryLine ''
Write-SummaryLine ('=' * 78)
