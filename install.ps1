# Cerbero — instalador Windows
# Uso: .\install.ps1

$ErrorActionPreference = "Stop"

$skillSrc      = Join-Path $PSScriptRoot "SKILL.md"
$scriptsSrc    = Join-Path $PSScriptRoot "scripts"
$skillDestDir  = Join-Path $env:USERPROFILE ".claude\skills\Cerbero"
$skillDest     = Join-Path $skillDestDir "SKILL.md"
$scriptsDest   = Join-Path $skillDestDir "scripts"
$venvDir       = Join-Path $skillDestDir ".venv"
$reportsDir    = Join-Path $env:USERPROFILE "Documents\Cerbero\reports"

if (-not (Test-Path $skillSrc)) {
    Write-Host "ERRO: SKILL.md nao encontrado em $skillSrc" -ForegroundColor Red
    Write-Host "Rode este script da pasta raiz do repo (onde esta o SKILL.md)." -ForegroundColor Red
    exit 1
}

Write-Host "Instalando skill Cerbero..."

# 0. Check Python 3.10+ (install via winget if missing)
$pythonExe = $null
foreach ($candidate in @("python", "py")) {
    try {
        $version = & $candidate -c "import sys; print('%d.%d' % sys.version_info[:2])" 2>$null
        if ($LASTEXITCODE -eq 0) {
            $parts = $version.Trim().Split(".")
            if ([int]$parts[0] -ge 3 -and [int]$parts[1] -ge 10) {
                $pythonExe = $candidate
                Write-Host "  [OK] Python $version encontrado ($candidate)." -ForegroundColor Green
                break
            }
        }
    } catch {}
}
if (-not $pythonExe) {
    Write-Host "  [!] Python 3.10+ nao encontrado. Instalando via winget..." -ForegroundColor Yellow
    winget install --id Python.Python.3.12 --silent --accept-package-agreements --accept-source-agreements
    Write-Host ""
    Write-Host "Python instalado. FECHE esta janela e de dois cliques no Install.bat DE NOVO pra continuar." -ForegroundColor Yellow
    exit 0
}

# 1. Copy SKILL.md
New-Item -ItemType Directory -Force -Path $skillDestDir | Out-Null
Copy-Item -Force $skillSrc $skillDest
Write-Host "  [OK] SKILL.md copiada para: $skillDest" -ForegroundColor Green

# 2. Copy scripts/ folder
if (Test-Path $scriptsSrc) {
    New-Item -ItemType Directory -Force -Path $scriptsDest | Out-Null
    Copy-Item -Force -Recurse "$scriptsSrc\*" $scriptsDest
    Write-Host "  [OK] scripts/ copiada para: $scriptsDest" -ForegroundColor Green
} else {
    Write-Host "  [aviso] pasta scripts/ nao encontrada no repo - pulando." -ForegroundColor Yellow
}

# 3. Create venv if not exists
if (-not (Test-Path $venvDir)) {
    Write-Host "  Criando .venv..."
    & $pythonExe -m venv $venvDir
    Write-Host "  [OK] .venv criado: $venvDir" -ForegroundColor Green
} else {
    Write-Host "  [OK] .venv ja existe: $venvDir" -ForegroundColor Green
}

# 4. Install Playwright into venv
$pyExe = Join-Path $venvDir "Scripts\python.exe"
Write-Host "  Instalando playwright..."
& $pyExe -m pip install --quiet --upgrade pip
& $pyExe -m pip install --quiet playwright
Write-Host "  [OK] playwright instalado." -ForegroundColor Green

# 5. Download Chromium for Playwright (browser binary, ~150MB)
Write-Host "  Baixando Chromium (pode levar 1-2 min na primeira vez)..."
& $pyExe -m playwright install chromium
Write-Host "  [OK] Chromium instalado." -ForegroundColor Green

# 6. Reports folder
New-Item -ItemType Directory -Force -Path $reportsDir | Out-Null
Write-Host "  [OK] Pasta de relatorios pronta: $reportsDir" -ForegroundColor Green

Write-Host ""
Write-Host "Cerbero instalado com sucesso!" -ForegroundColor Green
Write-Host "Proximos passos:" -ForegroundColor Yellow
Write-Host "  1. Reinicie o Claude Code (skills sao carregadas no boot)."
Write-Host "  2. Digite /Cerbero <URL da LP> para auditar uma oferta."
Write-Host "  3. Relatorios serao salvos em: $reportsDir"
