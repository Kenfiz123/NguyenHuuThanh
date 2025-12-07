---
title: "Translated Blogs"

weight: 3
chapter: false
pre: " <b> 3. </b> "
---

This section lists and introduces the blogs you have translated:

### [Blog 1 – Improving platform resilience at Cash App](3.1-Blog1/)
This article describes how Cash App enhanced the resilience of its cloud platform by modernizing its Amazon EKS architecture and adopting AWS Fault Injection Service for controlled chaos experiments. It outlines the move to a dual-cluster topology to eliminate single points of failure, the use of Route 53 weighted routing and NLB chaining to safely shift production traffic, and the implementation of Availability Zone power-interruption scenarios with AWS FIS to validate failover behavior. Together, these improvements strengthen reliability, support regulatory requirements, and lay the foundation for more scalable, fault-tolerant systems.

### [Blog 2 – Improve your security posture using Amazon threat intelligence on AWS Network Firewall](3.2-Blog2/)
AWS introduced Active Threat Defense for Network Firewall — a managed rule group powered by Amazon threat intelligence (MadPot) that automatically blocks malicious IPs, domains, and URLs tied to malware, C2, botnets, sinkholes, and mining pools. The AttackInfrastructure rule group updates continuously, protects both inbound/outbound traffic, reduces false positives, and integrates with GuardDuty.
Just add the rule group to your Firewall policy to enable it.

### [Blog 3 – Introducing the new console experience for AWS WAF](3.3-Blog3/)
AWS WAF launched a new console experience that massively simplifies setup and security management. The redesigned interface provides a single-page workflow, pre-configured protection packs, automated rule recommendations, and a unified dashboard for real-time visibility. It cuts configuration steps by up to 80%.
You can choose workload-specific protection packs (Recommended, Essentials, or You Build It), deploy rules in one step, and monitor everything through new dashboards showing traffic, bots, rules, CAPTCHA metrics, and Sankey visualizations. The console also includes a built-in log explorer for quick traffic and rule analysis. Available now at no extra cost.
