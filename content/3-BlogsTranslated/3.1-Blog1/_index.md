---
title: "Improving platform resilience at Cash App"
weight: 1
chapter: false
pre: " <b> 3.1. </b> "
---

by Dustin Ellis, Deepak Garg, Ben Apprederisse, Jan Zantinge, and Rachel Sheikh on 29 MAY 2025 in Amazon Elastic Kubernetes Service, AWS Fault Injection Service (FIS), Customer Solutions, Resilience Permalink 

This post was coauthored with engineers at Cash App, including Ben Apprederisse (Platform Engineering Technical Lead), Jan Zantinge (Traffic Engineer), and Rachel Sheikh (Compute Engineer).

Cash App, a leading peer-to-peer payments and digital wallet service from Block, Inc., has grown to serve over 57 million users since its launch in 2013. Providing diverse offerings like instant money transfers, debit cards, stock and bitcoin investments, personal loans, and tax filing, Cash App continuously strives to make money more relatable, accessible, and secure. To meet this mission, their platform built on AWS must remain highly scalable and resilient.

Cash App has implemented resilience improvements across the entire technology stack, but for this post, we explore two enhancements implemented in 2024. First, we discuss how Cash App improved the resilience of its compute platform built on Amazon Elastic Kubernetes Service (Amazon EKS) by implementing a dual-cluster topology to reduce single points of failure. We also discuss how Cash App used AWS Fault Injection Service (AWS FIS) to conduct an Availability Zone power interruption scenario in non-production environments, preparing the platform team for real-world failures and ongoing regulatory requirements.

## **Moving to Amazon EKS**

Cash App has used Amazon EKS as a shared platform for years, and in 2024, we migrated the last of our biggest and most critical services to it, driven by the ease of management and our strategy to run workloads in the cloud. This shift empowered our teams to focus more on application delivery and less on cluster management, abstracting away some of the complexity in operating Kubernetes clusters. With Amazon EKS, AWS is responsible for managing the Kubernetes control plane, which includes the control plane nodes, the ETCD database, and other infrastructure necessary for AWS to deliver a service offering with enhanced security features. As a consumer of Amazon EKS, we are still responsible for things like AWS Identity and Access Management (IAM), pod security, runtime security, networking, and cluster automatic scaling in the data plane for worker nodes. AWS refers to this as the Shared Responsibility Model; for more details, refer to Best Practices for Security. For a while, maintaining a single shared EKS cluster for each environment and AWS Region was acceptable and met our technical requirements.

## **Scaling challenges with a single shared EKS cluster** 

As Cash App’s shared EKS cluster grew and onboarded hundreds of microservices, we became an early adopter of the Karpenter Cluster Autoscaler, which improved application availability and cluster efficiency. Karpenter was designed to enhance node lifecycle management within Kubernetes clusters. It automates provisioning and deprovisioning of nodes based on the specific scheduling needs of pods, allowing for efficient scaling and cost optimization. We also reviewed and adopted many of the Amazon EKS Best Practices Guides for Reliability, Security, Networking, and Scalability.

Despite these efforts, in 2023, we realized having a single shared EKS cluster with hundreds of worker nodes had become a critical dependency in our cloud platform architecture, whereby standard operations like cluster upgrades posed a risk of impacting production traffic or causing downtime. Although we had a staging environment that allowed us to test new features and changes before rolling them out in production, it didn’t always reflect real traffic patterns that could allow impactful changes to go unnoticed in lower environments. For example, in late 2023, production traffic was briefly impacted due to a relatively new Kubernetes feature called API Priority and Fairness (APF) that introduced temporary control plane throttling following a cluster upgrade.

As a leader in the financial services industry, any interruption to our services directly impacts customers’ ability to transact and participate in the economy, so round-the-clock availability of our platform is essential. Following this incident, we reviewed and implemented the Kubernetes Control Plane best practices pertaining to APF and set up new detections in our observability platform to monitor things like FlowSchemas and queue depth. We also created a business case for investing in platform evolution and moving towards a multi-cluster topology. The desired state was to have a safer way to upgrade clusters, such that traffic is always serviceable regardless of the state of a single cluster in the fleet.

The following diagram illustrates our basic architecture in late 2023, portraying a single, Multi-AZ EKS cluster at Cash App. We had two ingress paths: for public ingress, we used Amazon Route 53 to a Network Load Balancer (NLB). For internal ingress across Amazon Virtual Private Cloud (Amazon VPC) networks (for example, from other business units), we set up a VPC endpoint service. Other components (such as service dependencies like database clusters and other Regions) are intentionally omitted from the diagram for simplicity.

  
![image1](/images/3-BlogsTranslated/3.1-Blog1/image1.png)

## **Platform enhancements**

In 2024, our cloud platform team implemented architectural changes to improve the reliability of the shared Amazon EKS platform, which was already running hundreds of services and over 10,000 pods. In the process, we also recognized the importance of chaos engineering to provide controlled failure testing and preparedness, which is also an evolving regulatory requirement for financial institutions. Our team has made multiple resilience improvements to apply long-term scalability; the rest of this post focuses on two enhancements we believe other AWS customers can benefit from.
## **Enhancement 1: Implementing a dual-cluster topology**

When researching multi-cluster topologies and interacting with AWS specialists, we learned about architectural patterns to improve platform resilience with varying degrees of complexity. This included cell-based architecture, Route 53 weighted routing, and NLB chaining, among other patterns. Our initial requirements for the multi-cluster architecture were as follows:

Effortlessly deploy a service across two or more clusters
Serve production traffic from multiple clusters at the same time if needed
Seamlessly upgrade a production cluster without impacting production traffic
Have the ability to take a cluster out of the traffic flow during planned and unplanned events
Achieve reliability improvements with minimal architectural and cost changes
Based on these initial requirements and the complexity required to properly implement a cell-based architecture, we decided to start with Route 53 weighted routing for public ingress, and NLB chaining for internal ingress to achieve immediate improvements. Although we plan to implement a cell-based architecture in the future, it requires careful consideration and engineering investment (for example, creating a cell router and cell provisioning system). At the time, we needed a simpler, short-term solution that could improve overall scalability and reliability. From a Kubernetes perspective, we started with two Multi-AZ clusters in our production environment, each operating independently, such that a planned or unplanned event in one cluster would not affect the other cluster. Existing pipelines were extended to deploy the same Kubernetes resources into both clusters, which would actively serve ingress traffic using an NLB. If needed, we could divert all ingress traffic to one cluster during planned or unplanned events by updating the weights in Route 53 (for public ingress) or updating the listener rules and target groups on the frontend NLB (for internal ingress). In the following sections, we dive deeper into both approaches.

## **Public ingress changes**

For public ingress, requests are still handled by Route 53. With the introduction of weighted routing, requests can be evenly routed between the two backend NLBs (one per cluster). This setup allows Cash App to split traffic evenly across clusters or temporarily route all traffic to one cluster during upgrades. As an example, during cluster A’s upgrade, we can direct ingress traffic to cluster B, enabling a sequential upgrade process with minimal disruption. This dual-cluster approach helps mitigate single points of failure and establishes a foundation for reliability improvements. The following diagram illustrates this architecture.

## **Internal ingress changes**

Cash App works closely with other business units like Square, and therefore needs to have a secure and scalable ingress path for cross-VPC traffic. To support these use cases, internal ingress requests are still routed from other business unit VPCs to the NLB associated with our VPC endpoint service. From there, requests are load balanced roughly evenly to two backend NLBs (one per cluster) using the listener rules. The following diagram illustrates this architecture.



## **Key considerations**

Consider the following when assessing these approaches:

The NLB chaining approach used for internal ingress enables controlled failover and maintenance with minimal disruption by adjusting NLB listeners and target groups, and reduces single points of failure by distributing requests across two or more clusters.
Although this pattern met our initial requirements and made it possible to shift traffic from one cluster to another, it’s not as granular as we would like (for example, shift traffic for only service A to cluster B, and leave all other traffic on cluster A). We will continue to evolve the architecture and implement a more intelligent ingress router and cell provisioning system. Furthermore, at the time of writing, NLB doesn’t support weighted target group routing.
Using the NLB chaining approach adds additional cost due to multiple NLBs in the traffic path. With NLBs, you’re charged for each hour or partial hour that an NLB is running, and the number of Network Load Balancer Capacity Units (NLCUs) used by the NLB per hour.
The NLB chaining approach doesn’t achieve the full benefits of a cell-based architecture, which provides greater isolation and fault isolation boundaries. Moving to a cell-based architecture requires more complexity and coordination, so we decided to start with NLB chaining and Route 53 weighted routing for immediate improvements and minimal re-architecture.
Looking forward, we plan to implement a cell-based architecture that aligns with Block’s compute strategy. This will consist of a cell management layer (to create, update, and delete cells) and a cell routing layer (to route requests to the correct cell), which allows for fine-grained traffic routing.

## **Enhancement 2: Using AWS FIS for Availability Zone power interruption**

After moving to a dual-cluster topology, we researched ways to test ongoing platform resilience. Specifically, we wanted to test what would happen to our environment during single Availability Zone impairments and how our services and data stores would recover. This led us to AWS FIS, which we could use to conduct an Availability Zone power interruption scenario in our staging environment. AWS FIS is a fully managed service for running fault injection experiments on AWS infrastructure, making it straightforward to get started with chaos engineering. Chaos engineering is the practice of stressing an application in testing or production environments by creating disruptive events, such as a sudden increase in CPU or memory consumption, observing how the system responds, and implementing improvements.

Our initial AWS FIS experiment used multiple actions, including network disruption, database failover (targeting Amazon Aurora and Amazon ElastiCache clusters), and EKS worker node disruption (pod eviction and rescheduling). For the full list of AWS FIS actions, refer to AZ Availability: Power Interruption. For our initial experiment, we targeted infrastructure in a single staging account; however, AWS FIS supports multi-account experiments by setting up an orchestrator account that enables centralized configuration, management, and logging. The orchestrator account owns the AWS FIS experiment template. For future AWS FIS experiments, we plan to target more accounts and resources, operating within the constraints of AWS FIS quotas and limits.

For clear communication during the AWS FIS experiment, our platform team coordinated with internal application stakeholders and our AWS account team, monitoring metrics to gauge failover and recovery responses. After the experiment, we debriefed with AWS teams and submitted product feature requests to support ongoing service evolution. Moving forward, we plan to conduct AWS FIS experiments at least twice a year to reinforce reliability best practices and adhere to ongoing regulatory requirements. We will also diversify the types of fault injection experiments we perform, and expand beyond the single Availability Zone failure tests. For example, we might introduce a capability that allows application teams to perform one-time AWS FIS experiments just for their service and backend database infrastructure in a controlled, self-service fashion. An added benefit of using AWS FIS is that there is no agent or infrastructure to deploy or manage, and you’re only billed for the duration of the experiment. This made it both straightforward and affordable to get started with chaos engineering. The following diagram illustrates the architecture of the Availability Zone power interruption scenario targeting subnets, compute, and database clusters.

## **Key considerations**

Setting up the AWS FIS experiment required us to modify default service limits and quotas to accommodate the scale and scope, such as the number of target resources for ElastiCache, Amazon Relational Database Service (Amazon RDS), and subnets. We recommend reviewing the quotas, service limits, and supported services prior to conducting your own experiment, and collaborate with your AWS account team to achieve a seamless experience.

We also learned that certain failures, such as database failover, require more than network disruption actions alone—specific failover actions had to be configured in the AWS FIS experiment template to trigger the desired behavior, as outlined further in the service documentation. If you’re starting with the Availability Zone power interruption scenario, be sure to include all of the required actions to achieve the desired outcome. Finally, we recommend using AWS FIS in lower environments because AWS FIS actions will have real impact on the targeted resource state and availability.

## **Conclusion**

Through these enhancements, Cash App has improved overall resilience posture and laid the groundwork for future improvements. On the Amazon EKS side, we aim to implement an ingress routing layer through cell-based architecture patterns, enabling more granular traffic routing and improved fault isolation boundaries. We will continue to use Karpenter for cluster automatic scaling, and are in the process of rolling out AWS Graviton based instances to further improve resource efficiency. Finally, we will continue using AWS FIS for chaos engineering at both the platform and application level, performing larger-scale AWS FIS experiments with more complexity.