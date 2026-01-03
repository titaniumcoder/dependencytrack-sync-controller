#!/usr/bin/env pwsh
# Docker build and push script with Git-based versioning

param(
    [string]$Registry = "localhost:5000",
    [string]$ImageName = "spring-demo",
    [switch]$Push
)

# Get version from Gradle (same as build.gradle)
$version = & .\gradlew -q showVersion | Select-String "Project Version: (.+)" | ForEach-Object { $_.Matches[0].Groups[1].Value }

if (-not $version) {
    Write-Error "Could not determine version from Gradle"
    exit 1
}

Write-Host "Building Docker image with version: $version" -ForegroundColor Green

# Build Docker image
$imageFull = "${Registry}/${ImageName}:${version}"
$imageLatest = "${Registry}/${ImageName}:latest"

docker build -t $imageFull -t $imageLatest .

if ($LASTEXITCODE -ne 0) {
    Write-Error "Docker build failed"
    exit 1
}

Write-Host "✅ Built images:" -ForegroundColor Green
Write-Host "  - $imageFull"
Write-Host "  - $imageLatest"

if ($Push) {
    Write-Host "Pushing images..." -ForegroundColor Yellow
    docker push $imageFull
    docker push $imageLatest
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Images pushed successfully" -ForegroundColor Green
    } else {
        Write-Error "Docker push failed"
        exit 1
    }
}

Write-Host "\nUsage examples:" -ForegroundColor Cyan
Write-Host "  docker run -p 8080:8080 $imageFull"
Write-Host "  docker run -p 8080:8080 $imageLatest"