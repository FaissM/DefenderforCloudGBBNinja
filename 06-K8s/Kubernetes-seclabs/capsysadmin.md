# Kubernetes clusters should not grant CAPSYSADMIN security capabilities

CAP_SYS_ADMIN allows to perform a range of system administration operations, privileged ones that cannot be performed by a normal user

This capability is disabled by default in a Kubernetes cluster, unless explicity enabled in the pod definition file 

The pod definition that binds this permission lives in
[`../hardening-labs-demo/capsysadmin.yaml`](../hardening-labs-demo/capsysadmin.yaml):

```
apiVersion: v1
kind: Pod
metadata:
  name: nginx-cap-sys-admin
  namespace: hardening-demo
spec:
  containers:
  - name: nginx-cap-sys-admin
    image: IMAGE_PLACEHOLDER
    securityContext:
      capabilities:
        add: ["SYS_ADMIN"]
```

It's deployed via CI/CD, not a local `kubectl apply` - see
[`../hardening-labs-demo/README.md`](../hardening-labs-demo/README.md) for why (code-to-runtime
mapping requires the image to come from a real build) and how (push to `main` or run the
`hardening-labs-demo.yml` workflow manually).

This bevaviour is very similar to running a container with privileged mode

As there is a built-in policy definition to monitor this operation, you will find a specific recommendation that flags the use of containers with this capability. You may also want to enforce this policy in Deny mode


![cap_sys_admin pod](/images/cap_sys_admin.png)

