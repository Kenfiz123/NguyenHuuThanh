---
title: "Cải thiện khả năng phục hồi nền tảng tại Cash App"
weight: 1
chapter: false
pre: " <b> 3.1. </b> "
---



bởi Dustin Ellis, Deepak Garg, Ben Apprederisse, Jan Zantinge, và Rachel Sheikh  | vào 29 MAY 2025 | trong Amazon Elastic Kubernetes Service, AWS Fault Injection Service (FIS), Customer Solutions, Resilience | Permalink | 

Bài viết này được đồng tác giả với các kỹ sư tại Cash App, bao gồm Ben Apprederisse (Platform Engineering Technical Lead), Jan Zantinge (Traffic Engineer), và Rachel Sheikh (Compute Engineer).

Cash App, một dịch vụ ví số và thanh toán peer-to-peer hàng đầu của Block, Inc., đã phát triển để phục vụ hơn 57 triệu người dùng kể từ khi ra mắt vào năm 2013. Cung cấp nhiều sản phẩm như chuyển tiền tức thời, thẻ ghi nợ, đầu tư cổ phiếu và bitcoin, cho vay cá nhân, và khai thuế, Cash App liên tục nỗ lực khiến tiền trở nên gần gũi, dễ tiếp cận, và an toàn hơn. Để đáp ứng sứ mệnh này, nền tảng của họ xây dựng trên AWS phải luôn có khả năng mở rộng cao và khả năng phục hồi vững chắc.

Cash App đã triển khai các cải tiến về khả năng phục hồi trên toàn bộ stack công nghệ, nhưng trong bài viết này, chúng tôi khám phá hai cải tiến được triển khai trong năm 2024. Trước hết, chúng tôi thảo luận cách Cash App cải thiện khả năng phục hồi của nền tảng compute xây dựng trên Amazon Elastic Kubernetes Service (Amazon EKS) bằng cách triển khai topology dual-cluster nhằm giảm các điểm đơn lẻ gây lỗi (single points of failure). Chúng tôi cũng thảo luận cách Cash App sử dụng AWS Fault Injection Service (AWS FIS) để thực hiện kịch bản gián đoạn nguồn điện ở Availability Zone trong các môi trường không phải production, giúp đội nền tảng sẵn sàng cho các sự cố thực tế và đáp ứng các yêu cầu tuân thủ liên tục.


## **Chuyển sang Amazon EKS**

Cash App đã sử dụng Amazon EKS như một nền tảng dùng chung trong nhiều năm, và vào năm 2024, chúng tôi đã di chuyển những dịch vụ lớn nhất và quan trọng nhất cuối cùng sang đó, được thúc đẩy bởi sự dễ dàng trong quản lý và chiến lược chạy workload trên đám mây. Sự chuyển dịch này trao quyền cho các đội tập trung nhiều hơn vào việc delivery ứng dụng và ít hơn vào quản lý cluster, trừu tượng hóa một phần độ phức tạp của vận hành các Kubernetes cluster. Với Amazon EKS, AWS chịu trách nhiệm quản lý control plane của Kubernetes, bao gồm các control plane node, cơ sở dữ liệu ETCD, và các hạ tầng khác cần thiết để AWS cung cấp một dịch vụ với các tính năng bảo mật nâng cao. Với vai trò người dùng của Amazon EKS, chúng tôi vẫn chịu trách nhiệm cho các hạng mục như AWS Identity and Access Management (IAM), bảo mật pod, bảo mật runtime, networking, và cluster automatic scaling ở data plane cho worker node. AWS gọi đây là Shared Responsibility Model; để biết thêm chi tiết, tham khảo Best Practices for Security. Trong một thời gian, việc duy trì một EKS cluster dùng chung cho mỗi môi trường và mỗi AWS Region là chấp nhận được và đáp ứng yêu cầu kỹ thuật của chúng tôi.

## **Thách thức mở rộng với một EKS cluster dùng chung**

Khi EKS cluster dùng chung của Cash App phát triển và onboard hàng trăm microservice, chúng tôi trở thành một trong những người dùng sớm của Karpenter Cluster Autoscaler, điều này cải thiện tính sẵn sàng của ứng dụng và hiệu quả của cluster. Karpenter được thiết kế để nâng cao quản lý vòng đời node trong Kubernetes cluster. Nó tự động cung cấp và hủy cung cấp node dựa trên nhu cầu scheduling cụ thể của pod, cho phép scale hiệu quả và tối ưu chi phí. Chúng tôi cũng rà soát và áp dụng nhiều hướng dẫn Amazon EKS Best Practices Guides cho Reliability, Security, Networking, và Scalability.

Dù đã nỗ lực, vào năm 2023, chúng tôi nhận ra rằng việc có một EKS cluster dùng chung với hàng trăm worker node đã trở thành một phụ thuộc quan trọng trong kiến trúc nền tảng đám mây của chúng tôi, nơi các thao tác chuẩn như nâng cấp cluster tiềm ẩn rủi ro ảnh hưởng đến traffic production hoặc gây downtime. Dù chúng tôi có môi trường staging cho phép thử nghiệm tính năng và thay đổi trước khi phát hành ở production, nó không phải lúc nào cũng phản ánh các mô hình traffic thực tế khiến những thay đổi có tác động có thể không bị phát hiện ở môi trường thấp hơn. Ví dụ, cuối năm 2023, traffic production đã bị ảnh hưởng trong thời gian ngắn do một tính năng Kubernetes tương đối mới gọi là API Priority and Fairness (APF) gây ra việc throttling tạm thời ở control plane sau một lần nâng cấp cluster.

Là một đơn vị dẫn đầu trong ngành dịch vụ tài chính, bất kỳ gián đoạn nào tới dịch vụ của chúng tôi đều ảnh hưởng trực tiếp tới khả năng giao dịch và tham gia nền kinh tế của khách hàng, vì vậy tính sẵn sàng 24/7 của nền tảng là điều thiết yếu. Sau sự cố này, chúng tôi rà soát và triển khai các thực hành tốt nhất của Kubernetes Control Plane liên quan đến APF và thiết lập các phát hiện mới trong nền tảng quan sát để theo dõi các yếu tố như FlowS schemas và độ sâu hàng đợi (queue depth). Chúng tôi cũng xây dựng một case kinh doanh để đầu tư vào việc tiến hóa nền tảng và chuyển dịch sang topology multi-cluster. Trạng thái mong muốn là có cách an toàn hơn để nâng cấp cluster, sao cho traffic luôn được phục vụ bất kể trạng thái của một cluster đơn lẻ trong cụm.

Sơ đồ sau minh họa kiến trúc cơ bản của chúng tôi vào cuối năm 2023, mô tả một EKS cluster Multi-AZ đơn tại Cash App. Chúng tôi có hai đường ingress: đối với public ingress, chúng tôi dùng Amazon Route 53 tới một Network Load Balancer (NLB). Đối với internal ingress xuyên qua các Amazon Virtual Private Cloud (Amazon VPC) network (ví dụ, từ các đơn vị kinh doanh khác), chúng tôi thiết lập một VPC endpoint service. Các thành phần khác (chẳng hạn các phụ thuộc dịch vụ như database cluster và các Region khác) được cố ý lược bỏ khỏi sơ đồ cho đơn giản.


## **Các cải tiến nền tảng**

Năm 2024, đội nền tảng đám mây của chúng tôi triển khai các thay đổi kiến trúc để cải thiện độ tin cậy của nền tảng Amazon EKS dùng chung, vốn đã chạy hàng trăm dịch vụ và hơn 10.000 pod. Trong quá trình này, chúng tôi cũng nhận ra tầm quan trọng của chaos engineering để cung cấp kiểm thử thất bại có kiểm soát và khả năng sẵn sàng, đây cũng là một yêu cầu tuân thủ đang phát triển đối với các tổ chức tài chính. Đội của chúng tôi đã thực hiện nhiều cải tiến về khả năng phục hồi để áp dụng tính mở rộng dài hạn; phần còn lại của bài viết tập trung vào hai cải tiến mà chúng tôi tin rằng các khách hàng AWS khác có thể hưởng lợi.

## **Cải tiến 1: Triển khai topology dual-cluster**

Khi nghiên cứu các topology multi-cluster và tương tác với các chuyên gia AWS, chúng tôi tìm hiểu được các mẫu kiến trúc để cải thiện khả năng phục hồi nền tảng với mức độ phức tạp khác nhau. Điều này bao gồm cell-based architecture, Route 53 weighted routing, và NLB chaining, cùng các mẫu khác. Yêu cầu ban đầu của chúng tôi cho kiến trúc multi-cluster như sau:
Triển khai một dịch vụ trên hai hoặc nhiều cluster một cách dễ dàng
Phục vụ traffic production từ nhiều cluster cùng lúc khi cần
Nâng cấp một production cluster một cách liền mạch mà không ảnh hưởng traffic production
Có khả năng đưa một cluster ra khỏi luồng traffic trong các sự kiện có kế hoạch và không có kế hoạch
Đạt được các cải thiện về độ tin cậy với thay đổi kiến trúc và chi phí tối thiểu
Dựa trên các yêu cầu ban đầu này và mức độ phức tạp cần thiết để triển khai đúng một cell-based architecture, chúng tôi quyết định bắt đầu với Route 53 weighted routing cho public ingress, và NLB chaining cho internal ingress để đạt được cải thiện ngay lập tức. Dù chúng tôi có kế hoạch triển khai cell-based architecture trong tương lai, nó đòi hỏi cân nhắc kỹ lưỡng và đầu tư kỹ thuật (ví dụ, tạo một cell router và hệ thống cell provisioning). Tại thời điểm đó, chúng tôi cần một giải pháp đơn giản, ngắn hạn có thể cải thiện tổng thể khả năng mở rộng và độ tin cậy. Từ góc nhìn Kubernetes, chúng tôi bắt đầu với hai Multi-AZ cluster trong môi trường production, mỗi cluster vận hành độc lập, sao cho sự kiện có kế hoạch hoặc không có kế hoạch ở một cluster sẽ không ảnh hưởng cluster còn lại. Các pipeline hiện có được mở rộng để deploy cùng một tài nguyên Kubernetes vào cả hai cluster, vốn sẽ chủ động phục vụ ingress traffic bằng NLB. Khi cần, chúng tôi có thể điều hướng toàn bộ ingress traffic tới một cluster trong các sự kiện có kế hoạch hoặc không có kế hoạch bằng cách cập nhật các weight trong Route 53 (đối với public ingress) hoặc cập nhật listener rule và target group trên NLB frontend (đối với internal ingress). Trong các phần sau, chúng tôi đi sâu hơn vào cả hai cách tiếp cận.

## **Thay đổi đối với public ingress**

Đối với public ingress, request vẫn được xử lý bởi Route 53. Với việc giới thiệu weighted routing, request có thể được định tuyến đồng đều giữa hai NLB backend (mỗi cluster một NLB). Thiết lập này cho phép Cash App chia traffic đều giữa các cluster hoặc tạm thời định tuyến toàn bộ traffic tới một cluster trong quá trình nâng cấp. Ví dụ, trong quá trình nâng cấp cluster A, chúng tôi có thể chuyển hướng ingress traffic tới cluster B, cho phép quy trình nâng cấp tuần tự với gián đoạn tối thiểu. Cách tiếp cận dual-cluster này giúp giảm các single point of failure và thiết lập nền tảng cho các cải tiến về độ tin cậy. Sơ đồ sau minh họa kiến trúc này.


## **Thay đổi đối với internal ingress**

Cash App làm việc chặt chẽ với các đơn vị kinh doanh khác như Square, do đó cần có một đường ingress an toàn và có khả năng mở rộng cho traffic cross-VPC. Để hỗ trợ các trường hợp này, internal ingress request vẫn được định tuyến từ các VPC của đơn vị kinh doanh khác đến NLB gắn với VPC endpoint service của chúng tôi. Từ đó, request được cân bằng tải xấp xỉ đồng đều tới hai NLB backend (mỗi cluster một NLB) bằng cách sử dụng listener rule. Sơ đồ sau minh họa kiến trúc này.

## **Các lưu ý chính**
## **Cân nhắc những điều sau khi đánh giá các cách tiếp cận này:**

Cách tiếp cận NLB chaining dùng cho internal ingress cho phép failover và bảo trì có kiểm soát với gián đoạn tối thiểu bằng cách điều chỉnh NLB listeners và target group, và giảm single point of failure bằng cách phân phối request qua hai hoặc nhiều cluster.

Mặc dù mẫu này đáp ứng yêu cầu ban đầu của chúng tôi và giúp có thể chuyển traffic từ một cluster sang cluster khác, nó không chi tiết như chúng tôi mong muốn (ví dụ, chỉ chuyển traffic cho riêng service A sang cluster B, và để tất cả traffic khác ở cluster A). Chúng tôi sẽ tiếp tục tiến hóa kiến trúc và triển khai một ingress router thông minh hơn và hệ thống cell provisioning. Hơn nữa, tại thời điểm viết bài, NLB chưa hỗ trợ weighted target group routing.

Sử dụng cách tiếp cận NLB chaining làm tăng chi phí do có nhiều NLB trong đường traffic. Với NLB, bạn bị tính phí cho mỗi giờ hoặc phần giờ mà một NLB chạy, và số Network Load Balancer Capacity Unit (NLCU) được NLB sử dụng mỗi giờ.

Cách tiếp cận NLB chaining không đạt được đầy đủ lợi ích của cell-based architecture, vốn cung cấp khả năng cô lập và ranh giới cô lập lỗi tốt hơn. Chuyển sang cell-based architecture đòi hỏi phức tạp và phối hợp nhiều hơn, vì vậy chúng tôi quyết định bắt đầu với NLB chaining và Route 53 weighted routing để có cải thiện ngay và ít tái kiến trúc.
Trong tương lai, chúng tôi dự định triển khai cell-based architecture phù hợp với chiến lược compute của Block. Việc này sẽ bao gồm một lớp quản lý cell (để tạo, cập nhật, và xóa cell) và một lớp định tuyến cell (để định tuyến request tới đúng cell), cho phép định tuyến traffic chi tiết hơn.


## **Cải tiến 2: Sử dụng AWS FIS cho gián đoạn nguồn điện ở Availability Zone**

Sau khi chuyển sang topology dual-cluster, chúng tôi nghiên cứu cách để kiểm thử khả năng phục hồi nền tảng liên tục. Cụ thể, chúng tôi muốn kiểm thử điều gì sẽ xảy ra với môi trường trong các sự cố suy giảm ở một Availability Zone đơn lẻ và cách dịch vụ cùng datastore của chúng tôi sẽ phục hồi. Điều này dẫn chúng tôi đến AWS FIS, mà chúng tôi có thể dùng để thực hiện kịch bản gián đoạn nguồn điện ở Availability Zone trong môi trường staging. AWS FIS là dịch vụ được quản lý toàn phần để chạy các thí nghiệm fault injection trên hạ tầng AWS, giúp bắt đầu với chaos engineering trở nên đơn giản. Chaos engineering là thực hành gây áp lực lên ứng dụng trong môi trường kiểm thử hoặc production bằng cách tạo các sự kiện gây gián đoạn, như tăng đột ngột mức sử dụng CPU hoặc bộ nhớ, quan sát cách hệ thống phản ứng, và triển khai cải tiến.

Thí nghiệm AWS FIS ban đầu của chúng tôi sử dụng nhiều action, bao gồm gián đoạn mạng, failover cơ sở dữ liệu (nhắm tới Amazon Aurora và Amazon ElastiCache cluster), và gián đoạn EKS worker node (trục xuất pod và sắp xếp lại). Để biết đầy đủ danh sách action của AWS FIS, tham khảo AZ Availability: Power Interruption. Với thí nghiệm ban đầu, chúng tôi nhắm mục tiêu hạ tầng trong một staging account đơn lẻ; tuy nhiên, AWS FIS hỗ trợ thí nghiệm multi-account bằng cách thiết lập một orchestrator account cho phép cấu hình, quản lý và logging tập trung. Orchestrator account sở hữu AWS FIS experiment template. Với các thí nghiệm AWS FIS trong tương lai, chúng tôi dự định nhắm mục tiêu nhiều account và tài nguyên hơn, hoạt động trong các giới hạn AWS FIS quotas and limits.

Để truyền thông rõ ràng trong quá trình thí nghiệm AWS FIS, đội nền tảng của chúng tôi phối hợp với các stakeholder ứng dụng nội bộ và đội tài khoản AWS của chúng tôi, theo dõi metric để đánh giá phản ứng failover và phục hồi. Sau thí nghiệm, chúng tôi tổng kết với các đội AWS và gửi yêu cầu tính năng sản phẩm để hỗ trợ sự phát triển dịch vụ liên tục. Tiếp tới, chúng tôi dự định thực hiện thí nghiệm AWS FIS ít nhất hai lần mỗi năm để củng cố các best practice về độ tin cậy và tuân thủ các yêu cầu pháp lý liên tục. Chúng tôi cũng sẽ đa dạng hóa các loại thí nghiệm fault injection mà chúng tôi thực hiện, và mở rộng vượt ra ngoài các bài kiểm thử sự cố ở một Availability Zone đơn lẻ. Ví dụ, chúng tôi có thể giới thiệu một khả năng cho phép các đội ứng dụng thực hiện thí nghiệm AWS FIS một lần chỉ cho dịch vụ của họ và hạ tầng cơ sở dữ liệu backend theo cách tự phục vụ, có kiểm soát. Một lợi ích bổ sung của việc sử dụng AWS FIS là không có agent hay hạ tầng nào cần triển khai hoặc quản lý, và bạn chỉ bị tính phí theo thời lượng của thí nghiệm. Điều này khiến việc bắt đầu với chaos engineering vừa đơn giản vừa tiết kiệm. Sơ đồ sau minh họa kiến trúc của kịch bản gián đoạn nguồn điện ở Availability Zone nhắm tới subnet, compute, và database cluster.

Các lưu ý chính Thiết lập thí nghiệm AWS FIS yêu cầu chúng tôi điều chỉnh limit và quota dịch vụ mặc định để phù hợp với quy mô và phạm vi, như số lượng tài nguyên mục tiêu cho ElastiCache, Amazon Relational Database Service (Amazon RDS), và subnet. Chúng tôi khuyến nghị xem xét quota, service limit, và các dịch vụ được hỗ trợ trước khi thực hiện thí nghiệm của riêng bạn, và hợp tác với đội tài khoản AWS để có trải nghiệm liền mạch.

Chúng tôi cũng học được rằng một số sự cố, như failover cơ sở dữ liệu, cần nhiều hơn các action gián đoạn mạng đơn thuần—cần cấu hình các failover action cụ thể trong AWS FIS experiment template để kích hoạt hành vi mong muốn, như được nêu trong tài liệu dịch vụ. Nếu bạn bắt đầu với kịch bản gián đoạn nguồn điện ở Availability Zone, hãy đảm bảo bao gồm tất cả action cần thiết để đạt được kết quả mong muốn. Cuối cùng, chúng tôi khuyến nghị sử dụng AWS FIS ở các môi trường thấp hơn vì các action của AWS FIS sẽ có tác động thực đến trạng thái và tính sẵn sàng của tài nguyên mục tiêu.


## **Kết luận**

Thông qua các cải tiến này, Cash App đã cải thiện tư thế khả năng phục hồi tổng thể và đặt nền móng cho các cải tiến trong tương lai. Ở phía Amazon EKS, chúng tôi hướng tới việc triển khai một lớp định tuyến ingress thông qua các mẫu cell-based architecture, cho phép định tuyến traffic chi tiết hơn và cải thiện ranh giới cô lập lỗi. Chúng tôi sẽ tiếp tục sử dụng Karpenter cho cluster automatic scaling, và đang trong quá trình triển khai instance dựa trên AWS Graviton để cải thiện hiệu quả tài nguyên hơn nữa. Cuối cùng, chúng tôi sẽ tiếp tục sử dụng AWS FIS cho chaos engineering ở cả cấp nền tảng và ứng dụng, thực hiện các thí nghiệm AWS FIS quy mô lớn hơn với nhiều phức tạp hơn.
