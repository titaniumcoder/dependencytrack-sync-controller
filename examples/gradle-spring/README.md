# Spring Boot Demo Project for DependencyTrack

This is a demo Spring Boot project that demonstrates how to generate and upload SBOMs to DependencyTrack with proper tagging for the dependency-track-sync-controller.

## Prerequisites

- Java 21
- Gradle 8.x
- Git
- DependencyTrack instance running (see main README.md for setup)
- DependencyTrack API key

## Workflow for SBOM Upload

Follow these steps in order to properly version and upload your SBOM to DependencyTrack:

### 1. Make your code changes

Edit your application code as needed.

### 2. Create a Git tag

Version your code with a Git tag following the `demo-v` prefix pattern:

```bash
# Create a new version tag
git tag demo-v1.0.0

# Or for a patch version
git tag demo-v1.0.1

# Push the tag to remote
git push origin demo-v1.0.0
```

### 3. Create the project in DependencyTrack

Create the project structure with proper tagging:

```bash
./gradlew createProject -PdtApiKey=YOUR_API_KEY
```

### 4. Generate the CycloneDX SBOM

Create the Software Bill of Materials in CycloneDX format:

```bash
./gradlew cyclonedxDirectBom
```

### 5. Upload the SBOM

Upload the generated SBOM to DependencyTrack:

```bash
./gradlew uploadSbom -PdtApiKey=YOUR_API_KEY
```

## Configuration

You can override the default configuration using Gradle properties:

```bash
# Custom DependencyTrack URL (default: http://localhost:30080)
./gradlew uploadSbom -PdtBaseUrl=https://your-dtrack-instance.com

# Custom project name (default: group.name)
./gradlew uploadSbom -PdtProjectName=my-custom-project

# Custom project version (default: derived from Git tag)
./gradlew uploadSbom -PdtProjectVersion=1.0.0-custom
```

## Project Tags

The project is automatically tagged with `dtc-auto-internal` which indicates:
- `dtc`: Managed by Dependency Track Controller
- `auto`: Automatically managed
- `internal`: Internal cluster assignment

This tag is used by the dependency-track-sync-controller to identify and manage projects.

## Complete Example

Here's the complete workflow from code change to SBOM upload:

```bash
# 1. Make changes to your code
# ... edit files ...

# 2. Commit and tag
git add .
git commit -m "Add new feature"
git tag demo-v1.2.0
git push origin main --tags

# 3. Set your API key (one time setup)
export DT_API_KEY=your-api-key-here

# 4. Create project, generate SBOM, and upload (all in one)
./gradlew createProject cyclonedxDirectBom uploadSbom -PdtApiKey=$DT_API_KEY
```

## Troubleshooting

- **API key required**: Make sure to pass `-PdtApiKey=YOUR_API_KEY` or set it as an environment variable
- **Version not updating**: Check that your Git tag follows the `demo-v` prefix pattern
- **Upload fails**: Verify your DependencyTrack instance is running and accessible
- **Tags not appearing**: The project must be created first with `createProject` before uploading