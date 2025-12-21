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
