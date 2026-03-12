# Script de build APK Gura Now
# Usage: .\build_apk_clean.ps1 [debug|release]

param(
    [Parameter(Position=0)]
    [ValidateSet("debug", "release")]
    [string]$BuildType = "debug"
)

Write-Host "Gura Now APK Build Script" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Verifier que nous sommes dans le bon repertoire
if (-not (Test-Path "pubspec.yaml")) {
    Write-Host "ERREUR: Ce script doit etre execute depuis le dossier frontend" -ForegroundColor Red
    exit 1
}

# Etape 1: Nettoyer le build precedent
Write-Host "Nettoyage du build precedent..." -ForegroundColor Yellow
flutter clean

# Etape 2: Recuperer les dependances
Write-Host "Recuperation des dependances..." -ForegroundColor Yellow
flutter pub get

# Etape 3: Build APK
Write-Host ""
Write-Host "Generation de l'APK ($BuildType)..." -ForegroundColor Yellow

if ($BuildType -eq "debug") {
    flutter build apk --debug
} else {
    flutter build apk --release
}

if ($LASTEXITCODE -ne 0) {
    Write-Host "ECHEC de la generation de l'APK" -ForegroundColor Red
    exit 1
}

# Etape 4: Afficher les informations
Write-Host ""
Write-Host "APK genere avec succes!" -ForegroundColor Green
Write-Host ""

$apkPath = "build\app\outputs\flutter-apk\app-$BuildType.apk"
if (Test-Path $apkPath) {
    $apkSize = (Get-Item $apkPath).Length / 1MB
    Write-Host "Emplacement: $apkPath" -ForegroundColor Cyan
    Write-Host "Taille: $([math]::Round($apkSize, 2)) MB" -ForegroundColor Cyan
    
    # Copier vers le bureau
    $desktopPath = [Environment]::GetFolderPath("Desktop")
    $destPath = "$desktopPath\gura_now-$BuildType.apk"
    Copy-Item $apkPath $destPath -Force
    Write-Host "Copie vers: $destPath" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "Prochaines etapes:" -ForegroundColor Yellow
Write-Host "  1. Connectez votre telephone via USB" -ForegroundColor White
Write-Host "  2. Activez le debogage USB" -ForegroundColor White
Write-Host "  3. Executez: flutter install" -ForegroundColor White
Write-Host ""
Write-Host "Termine!" -ForegroundColor Green
