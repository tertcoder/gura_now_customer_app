# Script de build et déploiement APK Gura Now
# Usage: .\build_apk.ps1 [debug|release]

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
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Échec du nettoyage" -ForegroundColor Red
    exit 1
}

# Étape 2: Récupérer les dépendances
Write-Host "📦 Récupération des dépendances..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Échec de la récupération des dépendances" -ForegroundColor Red
    exit 1
}

# Étape 3: Vérifier la configuration
Write-Host "🔍 Vérification de la configuration..." -ForegroundColor Yellow
flutter doctor

# Étape 4: Build APK
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

# Étape 5: Afficher les informations
Write-Host ""
Write-Host "✅ APK généré avec succès!" -ForegroundColor Green
Write-Host ""

$apkPath = "build\app\outputs\flutter-apk\app-$BuildType.apk"
if (Test-Path $apkPath) {
    $apkSize = (Get-Item $apkPath).Length / 1MB
    Write-Host "📍 Emplacement: $apkPath" -ForegroundColor Cyan
    Write-Host "📊 Taille: $([math]::Round($apkSize, 2)) MB" -ForegroundColor Cyan
    
    # Copier vers un emplacement facile d'accès
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
Write-Host "     ou" -ForegroundColor White
Write-Host "     Transférez l'APK sur votre téléphone" -ForegroundColor White
Write-Host ""

# Étape 6: Proposer l'installation automatique
Write-Host "Voulez-vous installer l'APK maintenant? (O/N)" -ForegroundColor Yellow
$response = Read-Host

if ($response -eq "O" -or $response -eq "o") {
    Write-Host "📲 Vérification des appareils connectés..." -ForegroundColor Yellow
    flutter devices
    
    Write-Host ""
    Write-Host "📲 Installation de l'APK..." -ForegroundColor Yellow
    flutter install
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Installation réussie!" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Installation échouée. Installez manuellement l'APK." -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "🎉 Terminé!" -ForegroundColor Green
