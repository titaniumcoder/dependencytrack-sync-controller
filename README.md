# Dependency-Track Version Controller

This is for now a blank repo. The idea is that it solves a problem I saw in a project
where we have separate build and deployment pipelines. Meaning that for example you have
a new build and it gets deployed directly into a development environment
after it has been tested in that environment it is moved on to the next environment
(staging, testing, ...) and after it has been quality-tested it goes into the 
real production environment.

The idea of this controller is to observe the deployments and then update
dependency-tracker versions (which are created using SBOM during the build)
so that it can immediately be tracked which environment has currently which version
and which dependencies.

## Thoughts

* Matching dependency-track names with kubernetes: `app.kubernetes.io/name` (but may need a mapping using a crd)
* Matching versions: `app.kubernetes.io/version` (what to do if there is no version`?)
* Matching environment: `security.dependencytrack/environment` may be
* config: needs a CRD: base url, features activated, timeouts, ...
* scale-to-zero / version change / delete: 
  * remove env tag
  * add customproperty: env-???:lastSeenAt=
* Trigger: deployment status, meaning
  * status.availableReplicas == status.replicas (needs validation)
  * `Progressing` and `Available` conditgions both `true`
* Calculate diff between "current active version" and "known deployed versions" 
  * repeated calculations should give the same result
  * execute operations against dt to sync
  * config set a version that has no more active environments to inactive? if it ever was active?
* Idempotency and resync (`ResyncPeriod` I think)
* Does it make sense to have a sync state?

## Local development (docker desktop or similar)

You need kubernetes and some ingress controller (nginx).

### Dependency-Track installation

Assuming you have installed Docker Desktop. There is an example for minikube and a description on the DTrack Helm Github Repo for any other scenario.

First, create the persistent volume (for data persistence across restarts):

```bash
kubectl apply -f examples/dtrack-helm/persistent-volume.yaml
```

Then install DependencyTrack:

```bash
helm install dtrack dependency-track/dependency-track -f examples/dtrack-helm/local-docker-desktop.yaml --namespace dtrack --create-namespace
```

### Dependency-Track Updates

```bash
helm upgrade dtrack dependency-track/dependency-track --namespace dtrack -f examples/dtrack-helm/local-docker-desktop.yaml
```

### Dependency-Track Uninstall

```bash
helm uninstall dtrack --namespace dtrack
```
