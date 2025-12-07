---
title: "Improve your security posture using Amazon threat intelligence on AWS Network Firewall"
weight: 2
chapter: false
pre: " <b> 3.2. </b> "
---



by Amit Gaur, Prashanth Kalika, Saleem Muhammad, and Tim Sutton on 17 JUN 2025 in Advanced (300), AWS Network Firewall, Featured, Security, Identity, & Compliance, Technical How-to Permalink  Comments 
Today, customers use AWS Network Firewall to safeguard their workloads against common security threats. However, they often have to rely on third-party threat feeds and scanners that have limited visibility in AWS workloads to protect against active threats. A self-managed approach to cloud security through traditional threat intelligence feeds and custom rules can result in delayed responses, leaving customers exposed to active threats that are relevant to AWS workloads. Customers are looking for an automated approach to analyzing threats and deploying mitigations across multiple enforcement points to establish consistent defenses and want a unified, AWS-native solution that can rapidly protect against active threats across their entire cloud infrastructure.

This post introduces active threat defense, a new Network Firewall managed rule group that offers protection against active threats relevant to workloads in AWS. Active threat defense uses the AWS global infrastructure visibility and extensive threat intelligence to deliver automated, intelligence-driven security measures. The feature uses the Amazon threat intelligence system MadPot, which continuously tracks attack infrastructure, including malware hosting URLs, botnet command and control servers, and crypto mining pools, identifying indicators of compromise (IOCs) for active threats.

Active threat defense comes as a rule group AttackInfrastructure, which protects against malicious network traffic by blocking communications with detected attack infrastructure. After the managed rule group is configured in your firewall policy, Network Firewall now automatically blocks suspicious traffic to malicious IPs, domains, and URLs for indicator categories such as command-and-control (C2s), malware staging hosts, sinkholes, out-of-band testing (OAST), and mining-pools. It implements comprehensive filtering of both inbound and outbound traffic for various protocols, including TCP, UDP, DNS, HTTPS, and HTTP, and uses specific, verified threat indicators to facilitate high accuracy and minimize false positives.

Network Firewall with active threat defense protects AWS workloads using the following mechanisms:

Threat prevention: Automatically blocks malicious traffic using Amazon threat intelligence to identify and prevent active threats targeting workloads in AWS
Rapid protection: Continuously updates Network Firewall rules based on newly discovered threats, enabling immediate protection against them
Streamlined operations: Findings in GuardDuty marked with the threat list name “Amazon Active Threat Defense” can now be automatically blocked when active threat defense is enabled on Network Firewall
Collective defense: Deep threat inspection (DTI) enables shared threat intelligence, improving protection for active threat defense managed rule group users
Figure 1 illustrates the use of the active threat defense managed rule group with Network Firewall. It shows the automatic creation of stateful rules in the AWS managed rule group using threat data collected from MadPot.

## **Getting started**

The active threat defense managed rule group can be enabled directly within Network Firewall using the AWS Management Console, AWS Command Line Interface (AWS CLI), or AWS SDK. You can then associate the managed rule group with the Network Firewall policy. The rule group receives regular updates with new threat indicators and signatures, while automatically removing inactive or aged-out signatures.

## **Prerequisites**

To get started with Network Firewall with active threat defense, visit the Network Firewall console or see the AWS Network Firewall Developers Guide. Active threat defense is supported in all AWS Regions where Network Firewall is available today, including the AWS GovCloud (US) Regions and China Regions.

If this is your first time using Network Firewall, make sure to complete the following prerequisites. If you already have a firewall policy and a firewall, you can skip this section.

Create a firewall policy
Create a firewall

## **Set up the active threat defense managed rule group**

With the prerequisites in place, you can set up and use the active threat defence managed rule group.

To set up the managed rule group:

In the AWS Network Firewall console, choose Firewall policies in the navigation pane.
Select an existing firewall policy or the policy that you created as part of the prerequisites.

Figure 2: Select the Network Firewall policy

Scroll down to Stateful rule groups. On the right-hand side, choose Actions and select Add managed stateful rule groups.

Figure 3: Add a rule group

On the Add managed stateful rule groups page, scroll down to active threat defense. Select the rule group AttackInfrastructure. Based on your requirements for Deep threat inspection, you can opt out if you don’t want Network Firewall to process service logs. Choose Add to policy.

Figure 4: Add the rule group to the policy

You can verify on the next page the managed rule group was added to the policy.

Figure 5: Verify that the managed rule group was added to the policy

## **Considerations**

The first consideration is to understand how Network Firewall is more effective in detecting and mitigating threats associated with HTTPS traffic when the TLS inspection feature is used alongside the active threat defense managed rule group. TLS inspection enables active threat defense to analyze the actual content of encrypted connections, allowing it to identify and block malicious URLs that might otherwise pass undetected. This process involves decrypting traffic, inspecting the contents for known malicious URL patterns or behaviors, and then re-encrypting the traffic if it’s deemed safe. For more information on the considerations on TLS inspection, see Considerations for TLS inspection. Organizations must balance the security benefits with potential latency introduction and make sure that they have proper controls in place to handle sensitive decrypted data.

Another consideration is the mitigation of false positives. When you use this managed rule group in your firewall policy, you can edit rule group alert settings to help identify false-positives as part of a mitigation strategy. For more information, see mitigating false-positives.

The final consideration is how the use of managed rule groups count against the limit of stateful rules for each policy. For more information, see AWS Network Firewall quotas and Setting rule group capacity in AWS Network Firewall.

## **Conclusion**

In this post, you learned how to use the AWS Network Firewall active threat defense managed rule group to safeguard workloads against active threats.