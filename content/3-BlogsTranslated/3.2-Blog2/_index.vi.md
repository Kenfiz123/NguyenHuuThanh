---
title: "Cải thiện khả năng bảo mật của bạn bằng cách sử dụng Amazon Threat Intelligence trên AWS Network Firewall
"
weight: 2
chapter: false
pre: " <b> 3.2. </b> "
---



by Amit Gaur, Prashanth Kalika, Saleem Muhammad, and Tim Sutton | on 17 JUN 2025 

| in Advanced (300), AWS Network Firewall, Featured, Security, Identity, & Compliance, Technical How-to | Permalink | Comments |

Hôm nay, khách hàng sử dụng AWS Network Firewall để bảo vệ các workload của họ khỏi các mối đe dọa bảo mật phổ biến. Tuy nhiên, họ thường phải dựa vào các nguồn threat feed và trình quét của bên thứ ba có khả năng quan sát hạn chế trong các workload AWS để bảo vệ chống lại các mối đe dọa đang hoạt động. Cách tiếp cận tự quản lý đối với bảo mật đám mây thông qua các nguồn threat intelligence truyền thống và các rule tùy chỉnh có thể dẫn đến phản ứng chậm trễ, khiến khách hàng dễ bị tổn thương trước các mối đe dọa đang hoạt động có liên quan đến workload AWS. Khách hàng đang tìm kiếm một cách tiếp cận tự động để phân tích mối đe dọa và triển khai các biện pháp giảm thiểu trên nhiều điểm thực thi để thiết lập phòng thủ nhất quán và muốn một giải pháp thống nhất, bản địa AWS (AWS-native) có thể nhanh chóng bảo vệ chống lại các mối đe dọa đang hoạt động trên toàn bộ hạ tầng đám mây của họ.

Bài viết này giới thiệu active threat defense, một nhóm rule được quản lý mới của Network Firewall cung cấp khả năng bảo vệ chống lại các mối đe dọa đang hoạt động có liên quan đến workload trong AWS. Active threat defense sử dụng khả năng quan sát hạ tầng toàn cầu của AWS và threat intelligence mở rộng để cung cấp các biện pháp bảo mật tự động, dựa trên intelligence. Tính năng này sử dụng hệ thống Amazon threat intelligence MadPot , hệ thống theo dõi liên tục hạ tầng tấn công, bao gồm các URL lưu trữ malware, máy chủ command and control của botnet, và mining pool cho crypto, xác định các indicator of compromise (IOC) cho các mối đe dọa đang hoạt động.

Active threat defense được cung cấp dưới dạng một nhóm rule AttackInfrastructure , nhóm này bảo vệ chống lại lưu lượng mạng độc hại bằng cách chặn các kết nối với hạ tầng tấn công được phát hiện. Sau khi nhóm rule được quản lý được cấu hình trong firewall policy của bạn, Network Firewall hiện tự động chặn lưu lượng đáng ngờ tới các IP, domain và URL độc hại cho các loại indicator như command-and-control (C2s), malware staging hosts, sinkholes, out-of-band testing (OAST), và mining-pools. Nó triển khai việc lọc toàn diện đối với cả lưu lượng inbound và outbound cho nhiều giao thức khác nhau, bao gồm TCP, UDP, DNS, HTTPS và HTTP, và sử dụng các indicator mối đe dọa cụ thể, đã được xác minh để đạt độ chính xác cao và giảm thiểu false positive.

Network Firewall với active threat defense bảo vệ các workload AWS bằng các cơ chế sau:
Threat prevention: Tự động chặn lưu lượng độc hại bằng cách sử dụng Amazon threat intelligence để xác định và ngăn chặn các mối đe dọa đang hoạt động nhắm vào workload trong AWS
Rapid protection: Liên tục cập nhật các rule của Network Firewall dựa trên các mối đe dọa mới được phát hiện, cho phép bảo vệ ngay lập tức chống lại chúng
Streamlined operations: Các phát hiện trong GuardDuty có gắn tên threat list “Amazon Active Threat Defense” hiện có thể được tự động chặn khi active threat defense được bật trên Network Firewall
Collective defense: Deep threat inspection (DTI) cho phép chia sẻ threat intelligence, cải thiện khả năng bảo vệ cho người dùng nhóm rule được quản lý active threat defense
Figure 1 minh họa việc sử dụng nhóm rule được quản lý active threat defense với Network Firewall. Nó cho thấy việc tạo các stateful rule tự động trong nhóm rule được quản lý bởi AWS bằng cách sử dụng dữ liệu mối đe dọa được thu thập từ MadPot.


## **Bắt đầu**

Active threat defense managed rule group có thể được kích hoạt trực tiếp trong Network Firewall bằng cách sử dụng AWS Management Console, AWS Command Line Interface (AWS CLI), hoặc AWS SDK. Sau đó, bạn có thể liên kết nhóm rule được quản lý với Network Firewall policy. Nhóm rule sẽ nhận các bản cập nhật thường xuyên với các threat indicator và signature mới, đồng thời tự động loại bỏ các signature không còn hoạt động hoặc đã hết hạn.

## **Điều kiện tiên quyết**

Để bắt đầu với Network Firewall cùng active threat defense, hãy truy cập bảng điều khiển Network Firewall hoặc xem AWS Network Firewall Developers Guide. Active threat defense được hỗ trợ ở tất cả các AWS Region nơi Network Firewall hiện đang khả dụng, bao gồm các Region AWS GovCloud (US) và China.
Nếu đây là lần đầu bạn sử dụng Network Firewall, hãy đảm bảo hoàn thành các điều kiện tiên quyết sau. Nếu bạn đã có firewall policy và firewall, bạn có thể bỏ qua phần này.
Create a firewall policy
Create a firewall

## **CThiết lập nhóm quy tắc được quản lý phòng thủ mối đe dọa chủ động**

Với các điều kiện tiên quyết đã được thiết lập, bạn có thể thiết lập và sử dụng nhóm rule được quản lý active threat defense.
Để thiết lập nhóm quy tắc được quản lý:
Trong bảng điều khiển AWS Network Firewall, chọn Firewall policies trong bảng điều hướng.
Chọn một firewall policy hiện có hoặc policy mà bạn đã tạo như một phần của các điều kiện tiên quyết.
Hình 2: Chọn chính sách Tường lửa mạng
Cuộn xuống Stateful rule groups. Ở phía bên phải, chọn Actions và chọn Add managed stateful rule groups.

            Hình 3: Thêm nhóm quy tắc
Trên trang Add managed stateful rule groups, cuộn xuống active threat defense. Chọn nhóm rule AttackInfrastructure. Dựa trên yêu cầu của bạn đối với Deep threat inspection, bạn có thể chọn không tham gia nếu bạn không muốn Network Firewall xử lý service logs. Chọn Add to policy
Hình 4: Thêm nhóm quy tắc vào chính sách
Bạn có thể xác minh trên trang tiếp theo rằng nhóm rule được quản lý đã được thêm vào policy.
Hình 5: Xác minh rằng nhóm quy tắc được quản lý đã được thêm vào chính sách


## **Giá cả**

Để biết thông tin về pricing của active threat defense, xem AWS Network Firewall pricing.

## **Những cân nhắc**

Điều cần xem xét đầu tiên là hiểu cách Network Firewall hiệu quả hơn trong việc phát hiện và giảm thiểu các mối đe dọa liên quan đến lưu lượng HTTPS khi tính năng TLS inspection được sử dụng cùng với nhóm rule được quản lý active threat defense. TLS inspection cho phép active threat defense phân tích nội dung thực tế của các kết nối được mã hóa, cho phép xác định và chặn các URL độc hại có thể vượt qua mà không bị phát hiện. Quá trình này bao gồm giải mã lưu lượng, kiểm tra nội dung để tìm các mẫu hoặc hành vi URL độc hại đã biết, sau đó mã hóa lại lưu lượng nếu nó được coi là an toàn. Để biết thêm thông tin về các lưu ý liên quan đến TLS inspection, xem Considerations for TLS inspection. Các tổ chức phải cân bằng lợi ích bảo mật với khả năng trì hoãn tiềm ẩn và đảm bảo rằng họ có các biện pháp kiểm soát phù hợp để xử lý dữ liệu đã giải mã nhạy cảm.
Một lưu ý khác là việc giảm thiểu false positive. Khi bạn sử dụng nhóm rule được quản lý này trong firewall policy của mình, bạn có thể chỉnh sửa cài đặt rule group alert settings để giúp xác định false positive như một phần của chiến lược giảm thiểu. Để biết thêm thông tin, xem mitigating false-positives.
Lưu ý cuối cùng là cách việc sử dụng nhóm rule được quản lý được tính vào giới hạn stateful rules cho mỗi policy. Để biết thêm thông tin, xem AWS Network Firewall quotas và Setting rule group capacity in AWS Network Firewall.


## **Kết luận**

Trong bài viết này, bạn đã tìm hiểu cách sử dụng nhóm quy tắc được quản lý phòng thủ mối đe dọa chủ động của AWS Network Firewall để bảo vệ khối lượng công việc khỏi các mối đe dọa đang hoạt động.