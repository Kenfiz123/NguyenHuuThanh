---
title: "Introducing the new console experience for AWS WAF"
weight: 3
chapter: false
pre: " <b> 3.3. </b> "
---

by Harith Gaddamanugu on 17 JUN 2025 in Announcements, AWS WAF, Intermediate (200), Security, Identity, & Compliance Permalink  Comments 
Protecting publicly facing web applications can be challenging due to the constantly evolving threat landscape. You must defend against sophisticated threats, including zero-day vulnerabilities, automated events, and changing compliance requirements. Navigating through consoles and selecting the protections best suited to your use case can be complicated, requiring not only security expertise but also a deep understanding of the applications you want to protect.

Today, we’re excited to share that AWS WAF has launched a new console experience designed to simplify security configuration. This enhanced interface provides an integrated security solution that provides comprehensive protection across your application landscape, featuring a streamlined single-page workflow that can reduce deployment time from hours to minutes. AWS WAF now provides pre-configured rule packs for specific workloads, automated security recommendations, and a unified dashboard for clear visibility into security status. The new console also offers flexible protection levels and integrated partner solutions to help you scale security operations effectively.

In this post, we walk you through the features of the enhanced console experience for AWS WAF. You can now select your workload type to automatically apply expert-curated protection packs, helping to maintain comprehensive protection across your workloads.

## **Reduce web application security implementation steps by 80 percent**

The simplified interface consolidates the configuration steps into a single page, reducing the need to navigate through multiple pages. This consolidation creates an intuitive workflow that significantly reduces setup complexity. You can complete configurations that previously took hours within minutes, representing an 80 percent reduction in implementation time.

The new experience offers pre-configured security defaults and documentation, helping users of all technical abilities to effectively secure applications. When starting the setup process, you select the application category and feature focus to protect an API or web application, and AWS WAF automatically customizes the protection parameters accordingly.

AWS WAF now also integrates with AWS Marketplace through a dedicated page for direct deployment of partner solutions.

This streamlined approach, shown in Figure 1, transforms what was previously a complex, time-consuming process into a straightforward, efficient workflow that maintains robust security standards while dramatically reducing implementation time and potential configuration errors.



## **Simplified AWS WAF rule deployment through protection packs**

AWS WAF simplifies security deployment through three configuration options, each based on AWS security expertise and ready for immediate implementation. These protection packs provide comprehensive configuration optimized for various application types.

Recommended: Enables recommended protections for the selected application categories and traffic sources
Essentials: Enables essential protections for the selected application categories and traffic sources
You build it: Select and customize protections from the available options to fit your needs
Implementation requires a single step: selecting the appropriate protection pack based on your security needs, as shown in Figure 2. This approach minimizes complex configurations while maintaining security standards.

### **Real-time monitoring, automated recommendations, and protection activity visualization**

The new console features an outcome-driven dashboard, shown in Figure 3, that simplifies security monitoring by consolidating threat detection metrics, rule performance analytics, and actionable insights into a single view. Security teams can now respond to threats faster without having to navigate through multiple screens.

AWS Threat Intelligence enhances monitoring capabilities by analyzing two weeks of allowed traffic patterns to proactively identify potential vulnerabilities. The service examines critical traffic dimensions including IP reputation, distributed denial of service (DDoS) attacks, bot activities, anonymous IP sources, and vulnerable application traffic. When AWS WAF detects vulnerabilities, it recommends specific AWS Managed Rules to strengthen your security posture, as shown in Figure 4.

The new real-time monitoring dashboard, as shown in Figure 5, offers comprehensive security insights at a glance. It displays request counts for traffic within your specified time range and summarizes protection rules with their corresponding termination actions. A standout feature is the Sankey visualization, which maps protection activity to AWS WAF actions, helping security teams track traffic flow, identify rule interaction patterns, and optimize configurations.



### **Outcome driven dashboards for actionable insights**

The new dashboard, shown in Figure 6, displays security metrics based on business impact. The left panel contains four main categories: traffic, bot, rule, and CAPTCHA characteristics. The right panel shows metrics within each category. Under Traffic characteristics, you can view metrics by countries, attack types, and device types.

Bot characteristics include detection ratio, categories, token information, signals, session thresholds, IP token reuse thresholds, and coordinated activity. Rule characteristics highlight the top 10 managed rules, while CAPTCHA characteristics show solved, abandoned, and unsolved puzzle metrics. This organized structure helps you analyze data effectively, starting with category selection and progressing to rule evaluation. You can combine categories and metrics to visualize patterns, investigate incidents, and make informed decisions. Interactive features, such as IP blocking on hover, enable immediate action. The new console experience allows you to quickly identify threats, optimize WAF rules, and maintain effective security controls based on specific needs.
### **Query logs from the console**

The new AWS WAF console features an integrated log explorer. You can access two analysis options from the bottom of the new console page: sampled requests for immediate review or log explorer for detailed analysis. The log explorer, shown in Figure 7, requires Amazon CloudWatch logging and provides pre-built filters for rule actions and time frames, enabling quick pattern identification and trend analysis. If CloudWatch logging isn’t enabled, you can still analyze security events through sampled requests.

### **Availability and pricing**

Starting today, these dashboards are available by default in the AWS WAF console at no additional cost to you and require no additional setup to be completed.

### **Customer success**

Early adopters are already seeing significant benefits. Sarah Chen, Security Engineer at National Retail Corporation, reports: “With the new console, we configured protection for our PHP applications in under 10 minutes. The rule recommendations helped us identify and block sophisticated attacks targeting our applications, reducing our security incidents by 60 percent in the first month.”

### **Conclusion**

By combining intelligent monitoring, guided configuration, and straightforward access to specialized solutions, our enhanced console helps organizations to maintain robust security postures without the complexity traditionally associated with advanced security management.

