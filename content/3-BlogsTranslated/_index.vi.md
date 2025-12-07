---
title: "Translated Blogs"

weight: 3
chapter: false
pre: " <b> 3. </b> "
---

Phần này liệt kê và giới thiệu các blog bạn đã dịch:

###  [Blog 1 - Cải thiện khả năng phục hồi nền tảng tại Cash App](3.1-Blog1/)
Bài viết này trình bày cách Cash App tăng cường độ bền vững của nền tảng đám mây bằng cách hiện đại hóa kiến trúc Amazon EKS và áp dụng AWS Fault Injection Service để thử nghiệm sự cố có kiểm soát. Nội dung mô tả việc chuyển sang mô hình hai cụm EKS nhằm loại bỏ điểm lỗi đơn lẻ, sử dụng Route 53 weighted routing và NLB chaining để chuyển hướng traffic an toàn, và triển khai kịch bản mô phỏng mất điện Availability Zone bằng AWS FIS để xác thực khả năng failover. Tổng thể, các cải tiến này giúp tăng độ tin cậy, đáp ứng yêu cầu kiểm định, và tạo nền tảng cho hệ thống mở rộng và chịu lỗi tốt hơn.

###  [Blog 2 - Cải thiện khả năng bảo mật của bạn bằng cách sử dụng Amazon Threat Intelligence trên AWS Network Firewall](3.2-Blog2/)
AWS giới thiệu Active Threat Defense cho Network Firewall — một managed rule group dùng Amazon threat intelligence (MadPot) để tự động chặn IP/domain/URL độc hại liên quan đến malware, C2, botnet, mining… Rule group AttackInfrastructure cập nhật liên tục, bảo vệ inbound/outbound, giảm false positive và tự tích hợp với GuardDuty.

###  [Blog 3 - Giới thiệu trải nghiệm console mới cho AWS WAF](3.3-Blog3/)
AWS WAF đã ra mắt giao diện console mới giúp đơn giản hóa mạnh việc thiết lập và quản lý bảo mật. Giao diện được thiết kế lại với quy trình một trang, các gói bảo vệ dựng sẵn, gợi ý rule tự động, và dashboard hợp nhất để theo dõi thời gian thực. Nhờ đó giảm tới 80% số bước cấu hình.
Bạn có thể chọn các gói bảo vệ theo từng loại workload (Recommended, Essentials, hoặc You Build It), triển khai rule chỉ trong một bước, và theo dõi hệ thống qua dashboard mới hiển thị lưu lượng, bot, rule, CAPTCHA và biểu đồ Sankey. Console cũng có log explorer tích hợp để phân tích request nhanh hơn. Tính năng này có sẵn miễn phí.
