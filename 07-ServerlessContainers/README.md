# Serverless Container Security Labs

Defender CSPM's **discovery and posture for serverless container workloads** (GA July
2026) extends inventory visibility, misconfiguration/vulnerability recommendations, and
attack path analysis to:

- Azure Container Apps
- Azure Container Instances
- Amazon ECS on AWS Fargate (not covered here - Azure only)

Unlike the [06-K8s](../06-K8s) labs, this is **agentless** - no sensor, no add-on, nothing
to install on the workload itself. Defender CSPM (already enabled as Standard on this
subscription) discovers and assesses these resources automatically.

## Getting Set Up

```
cd 07-ServerlessContainers
./Setup-Environment.ps1 -SubscriptionId <your-subscription-id>
```

This creates a Container Apps environment with a publicly-exposed Container App, and a
standalone Container Instance with a public IP - both intentionally internet-facing so
the labs below have something to find.

## Labs

- [posture-misconfiguration.md](posture-misconfiguration.md) - review security
  recommendations for the deployed Container App / Container Instance
- [attack-path-analysis.md](attack-path-analysis.md) - use Cloud Security Explorer /
  attack path analysis to see how internet exposure is surfaced

> Note: discovery and posture results can take a few hours to appear after resources are
> created.
