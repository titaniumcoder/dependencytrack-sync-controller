#!/bin/bash
# Docker build and push script with Git-based versioning

REGISTRY=${1:-"localhost:5000"}
IMAGE_NAME=${2:-"spring-demo"}
PUSH=${3:-false}

# Get version from Gradle (same as build.gradle)
VERSION=$(./gradlew -q showVersion | grep -o "Project Version: .*" | cut -d' ' -f3)

if [ -z "$VERSION" ]; then
    echo "❌ Could not determine version from Gradle"
    exit 1
fi

echo "🐳 Building Docker image with version: $VERSION"

# Build Docker image
IMAGE_FULL="${REGISTRY}/${IMAGE_NAME}:${VERSION}"
IMAGE_LATEST="${REGISTRY}/${IMAGE_NAME}:latest"

docker build -t "$IMAGE_FULL" -t "$IMAGE_LATEST" .

if [ $? -ne 0 ]; then
    echo "❌ Docker build failed"
    exit 1
fi

echo "✅ Built images:"
echo "  - $IMAGE_FULL"
echo "  - $IMAGE_LATEST"

if [ "$PUSH" = "true" ] || [ "$PUSH" = "--push" ]; then
    echo "📤 Pushing images..."
    docker push "$IMAGE_FULL"
    docker push "$IMAGE_LATEST"
    
    if [ $? -eq 0 ]; then
        echo "✅ Images pushed successfully"
    else
        echo "❌ Docker push failed"
        exit 1
    fi
fi

echo ""
echo "Usage examples:"
echo "  docker run -p 8080:8080 $IMAGE_FULL"
echo "  docker run -p 8080:8080 $IMAGE_LATEST"