# Hardening labs demo image

Backs the `capsysadmin.md`, `privilege-container.md`, and `container-as-root.md` labs in
`../Kubernetes-seclabs`.

These labs originally referenced the public `nginx` image directly. Per Defender for
Cloud's [code-to-runtime mapping prerequisites](https://learn.microsoft.com/azure/defender-for-cloud/container-image-mapping),
manually-pulled images from Docker Hub don't qualify for mapping - only images **built
through a CI/CD pipeline** do. This folder is a trivial build on top of `nginx` (just
adds a static page) so there's a real build artifact to map.

## How it's deployed

`../../.github/workflows/hardening-labs-demo.yml` builds this image, tags it with the
immutable commit SHA, adds OCI labels (`docker/metadata-action`) for code-to-runtime
mapping, pushes to ACR, and deploys the three pod manifests in this folder to the
`hardening-demo` namespace on `aks-defender-k8s-lab` - all via the same OIDC federated
credential used by `code-to-runtime-demo`, no stored secrets, no local `kubectl apply`.

Push a change under this folder (or run the workflow manually) to (re)deploy.
