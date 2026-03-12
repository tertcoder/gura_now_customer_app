# Script de build APK Gura Now - Version simplifiée
# Usage: .\build_apk_simple.ps1 [debug|release]

param(
    [Parameter(Position=0)]
    [ValidateSet("debug", "release")]
    [string]$BuildType = "debug"
)

Write-Host "🚀 Gura Now APK Build Script" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Vérifier que nous sommes dans le bon répertoire
if (-not (Test-Path "pubspec.yaml")) {
    Write-Host "❌ Erreur: Ce script doit être exécuté depuis le dossier frontend" -ForegroundColor Red
    exit 1
}

# Étape 1: Nettoyer le build précédent
Write-Host "🧹 Nettoyage du build précédent..." -ForegroundColor Yellow
flutter clean

# Étape 2: Récupérer les dépendances
Write-Host "📦 Récupération des dépendances..." -ForegroundColor Yellow
flutter pub get

# Étape 3: Build APK
Write-Host ""
Write-Host "🏗️  Génération de l'APK ($BuildType)..." -ForegroundColor Yellow

if ($BuildType -eq "debug") {
    flutter build apk --debug
} else {
    flutter build apk --release
}

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Échec de la génération de l'APK" -ForegroundColor Red
    exit 1
}

# Étape 4: Afficher les informations
Write-Host ""
Write-Host "✅ APK généré avec succès!" -ForegroundColor Green
Write-Host ""

$apkPath = "build\app\outputs\flutter-apk\app-$BuildType.apk"
if (Test-Path $apkPath) {
    $apkSize = (Get-Item $apkPath).Length / 1MB
    Write-Host "📍 Emplacement: $apkPath" -ForegroundColor Cyan
    Write-Host "📊 Taille: $([math]::Round($apkSize, 2)) MB" -ForegroundColor Cyan
    
    # Copier vers le bureau
    $desktopPath = [Environment]::GetFolderPath("Desktop")
    $destPath = "$desktopPath\gura_now-$BuildType.apk"
    Copy-Item $apkPath $destPath -Force
    Write-Host "📋 Copié vers: $destPath" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "📱 Prochaines étapes:" -ForegroundColor Yellow
Write-Host "  1. Connectez votre téléphone via USB" -ForegroundColor White
Write-Host "  2. Activez le débogage USB" -ForegroundColor White
Write-Host "  3. Exécutez: flutter install" -ForegroundColor White
Write-Host ""
Write-Host "🎉 Terminé!" -ForegroundColor Green
