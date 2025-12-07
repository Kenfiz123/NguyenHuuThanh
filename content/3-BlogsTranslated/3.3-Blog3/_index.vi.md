---
title: "Giới thiệu trải nghiệm console mới cho AWS WAF"
weight: 3
chapter: false
pre: " <b> 3.3. </b> "
---



bởi Harith Gaddamanugu | on 17 JUN 2025 |  in Announcements, AWS WAF, Intermediate (200), Security, Identity, & Compliance | Permalink | Comments |

Việc bảo vệ các ứng dụng web hướng công chúng có thể là một thách thức do bối cảnh mối đe dọa luôn thay đổi. Bạn phải phòng thủ trước các mối đe dọa tinh vi, bao gồm các lỗ hổng zero-day, các sự kiện tự động hóa, và các yêu cầu tuân thủ liên tục thay đổi. Việc điều hướng qua các console và lựa chọn các biện pháp bảo vệ phù hợp nhất với trường hợp sử dụng của bạn có thể phức tạp, đòi hỏi không chỉ chuyên môn về bảo mật mà còn phải hiểu sâu về các ứng dụng bạn muốn bảo vệ.

Hôm nay, chúng tôi vui mừng chia sẻ rằng AWS WAF đã ra mắt trải nghiệm console mới được thiết kế để đơn giản hóa cấu hình bảo mật. Giao diện nâng cấp này cung cấp một giải pháp bảo mật tích hợp mang đến khả năng bảo vệ toàn diện trên toàn bộ hệ sinh thái ứng dụng của bạn, với quy trình làm việc hợp nhất trên một trang giúp giảm thời gian triển khai từ hàng giờ xuống còn vài phút. AWS WAF hiện cung cấp các gói quy tắc được cấu hình sẵn cho các loại workload cụ thể, các đề xuất bảo mật tự động, và bảng điều khiển hợp nhất giúp hiển thị rõ ràng trạng thái bảo mật. Console mới cũng cung cấp các mức độ bảo vệ linh hoạt và tích hợp các giải pháp từ đối tác để giúp bạn mở rộng hoạt động bảo mật một cách hiệu quả.

Trong bài viết này, chúng tôi sẽ hướng dẫn bạn các tính năng của trải nghiệm console nâng cấp dành cho AWS WAF. Giờ đây bạn có thể chọn loại workload của mình để tự động áp dụng các gói bảo vệ được tuyển chọn bởi chuyên gia, giúp duy trì khả năng bảo vệ toàn diện trên các workload của bạn.


### **Giảm 80 phần trăm số bước triển khai bảo mật ứng dụng web**

Giao diện được đơn giản hóa hợp nhất các bước cấu hình vào một trang duy nhất, giúp giảm nhu cầu phải điều hướng qua nhiều trang. Sự hợp nhất này tạo nên một quy trình làm việc trực quan giúp giảm đáng kể độ phức tạp trong thiết lập. Bạn có thể hoàn tất các cấu hình vốn trước đây mất hàng giờ chỉ trong vài phút, tương đương với mức giảm 80 phần trăm thời gian triển khai.

Trải nghiệm mới cung cấp các cấu hình bảo mật mặc định được thiết lập sẵn và tài liệu hướng dẫn, giúp người dùng ở mọi trình độ kỹ thuật đều có thể bảo vệ ứng dụng một cách hiệu quả. Khi bắt đầu quá trình thiết lập, bạn chọn danh mục ứng dụng và trọng tâm tính năng để bảo vệ một API hoặc ứng dụng web, và AWS WAF sẽ tự động tùy chỉnh các tham số bảo vệ tương ứng.

AWS WAF hiện cũng được tích hợp với AWS Marketplace thông qua một trang chuyên dụng để triển khai trực tiếp các giải pháp từ đối tác.

Cách tiếp cận được tối ưu hóa này, như minh họa trong Hình 1, giúp biến một quy trình vốn phức tạp và tốn thời gian trở thành một quy trình đơn giản và hiệu quả, vừa duy trì các tiêu chuẩn bảo mật mạnh mẽ vừa giảm đáng kể thời gian triển khai và các lỗi cấu hình có thể xảy ra.


**Đơn giản hóa việc triển khai quy tắc AWS WAF thông qua các gói bảo vệ** 

AWS WAF đơn giản hóa việc triển khai bảo mật thông qua ba tùy chọn cấu hình, mỗi tùy chọn đều dựa trên chuyên môn bảo mật của AWS và sẵn sàng để triển khai ngay lập tức. Các gói bảo vệ này cung cấp cấu hình toàn diện được tối ưu hóa cho nhiều loại ứng dụng khác nhau.

Recommended (Đề xuất): Bật các biện pháp bảo vệ được khuyến nghị cho các danh mục ứng dụng và nguồn lưu lượng đã chọn


Essentials (Cơ bản): Bật các biện pháp bảo vệ thiết yếu cho các danh mục ứng dụng và nguồn lưu lượng đã chọn


You build it (Tự xây dựng): Chọn và tùy chỉnh các biện pháp bảo vệ từ các tùy chọn hiện có để phù hợp với nhu cầu của bạn

Việc triển khai chỉ yêu cầu một bước duy nhất: chọn gói bảo vệ phù hợp dựa trên nhu cầu bảo mật của bạn, như hiển thị trong Hình 2. Cách tiếp cận này giúp giảm thiểu việc cấu hình phức tạp trong khi vẫn duy trì các tiêu chuẩn bảo mật.


### **Giám sát theo thời gian thực, đề xuất tự động và trực quan hóa hoạt động bảo vệ**

Bảng điều khiển (console) mới cung cấp một bảng điều khiển hướng theo kết quả, như minh họa trong Hình 3, giúp đơn giản hóa việc giám sát bảo mật bằng cách hợp nhất các chỉ số phát hiện mối đe dọa, phân tích hiệu suất quy tắc và các thông tin chi tiết có thể hành động trong một giao diện duy nhất. Các nhóm bảo mật giờ đây có thể phản ứng với các mối đe dọa nhanh hơn mà không cần phải điều hướng qua nhiều màn hình.
AWS Threat Intelligence tăng cường khả năng giám sát bằng cách phân tích các mẫu lưu lượng được cho phép trong hai tuần để chủ động xác định các lỗ hổng tiềm ẩn. Dịch vụ này kiểm tra các khía cạnh lưu lượng quan trọng bao gồm danh tiếng IP, các cuộc tấn công từ chối dịch vụ phân tán (DDoS), hoạt động bot, nguồn IP ẩn danh và lưu lượng ứng dụng dễ bị tấn công. Khi AWS WAF phát hiện các lỗ hổng, nó sẽ đề xuất các AWS Managed Rules cụ thể để tăng cường tư thế bảo mật của bạn, như hiển thị trong Hình 4.
Bảng điều khiển giám sát theo thời gian thực mới, như minh họa trong Hình 5, cung cấp cái nhìn tổng quan về bảo mật một cách toàn diện. Nó hiển thị số lượng yêu cầu trong phạm vi thời gian bạn chỉ định và tóm tắt các quy tắc bảo vệ cùng với hành động kết thúc tương ứng của chúng. Một tính năng nổi bật là biểu đồ Sankey, giúp ánh xạ hoạt động bảo vệ tới các hành động của AWS WAF, hỗ trợ các nhóm bảo mật theo dõi luồng lưu lượng, xác định các mẫu tương tác quy tắc và tối ưu hóa cấu hình.

### **Các bảng điều khiển định hướng theo kết quả để cung cấp thông tin chi tiết có thể hành động**

Bảng điều khiển mới, như được minh họa trong Hình 6, hiển thị các chỉ số bảo mật dựa trên tác động tới doanh nghiệp. Bảng điều khiển bên trái chứa bốn danh mục chính: đặc điểm lưu lượng, bot, quy tắc và CAPTCHA. Bảng điều khiển bên phải hiển thị các chỉ số trong từng danh mục. Trong phần Đặc điểm lưu lượng (Traffic characteristics), bạn có thể xem các chỉ số theo quốc gia, loại tấn công và loại thiết bị.
Các đặc điểm bot bao gồm tỷ lệ phát hiện, danh mục, thông tin token, tín hiệu, ngưỡng phiên, ngưỡng tái sử dụng token IP và hoạt động phối hợp. Đặc điểm quy tắc làm nổi bật 10 quy tắc được quản lý hàng đầu, trong khi đặc điểm CAPTCHA hiển thị các chỉ số về số câu đố được giải, bị bỏ dở và không giải được. Cấu trúc được tổ chức này giúp bạn phân tích dữ liệu hiệu quả hơn, bắt đầu từ việc chọn danh mục đến đánh giá quy tắc. Bạn có thể kết hợp các danh mục và chỉ số để trực quan hóa các mẫu, điều tra sự cố và đưa ra quyết định sáng suốt. Các tính năng tương tác, chẳng hạn như chặn IP khi di chuột, cho phép hành động ngay lập tức. Trải nghiệm bảng điều khiển mới cho phép bạn nhanh chóng xác định mối đe dọa, tối ưu hóa quy tắc WAF và duy trì các biện pháp kiểm soát bảo mật hiệu quả dựa trên nhu cầu cụ thể.


### **Truy vấn log ngay từ bảng điều khiển** 

Bảng điều khiển AWS WAF mới có tính năng khám phá log (log explorer) được tích hợp sẵn. Bạn có thể truy cập hai tùy chọn phân tích từ cuối trang bảng điều khiển mới: các yêu cầu được lấy mẫu (sampled requests) để xem xét ngay lập tức hoặc log explorer để phân tích chi tiết hơn. Log explorer, như minh họa trong Hình 7, yêu cầu bật tính năng ghi log lên Amazon CloudWatch và cung cấp các bộ lọc dựng sẵn cho hành động của quy tắc và khung thời gian, giúp bạn nhanh chóng xác định mẫu và phân tích xu hướng. Nếu CloudWatch logging chưa được bật, bạn vẫn có thể phân tích các sự kiện bảo mật thông qua các yêu cầu được lấy mẫu
### **Khả dụng và giá thành**

Bắt đầu từ hôm nay, các bảng điều khiển này được bật mặc định trong AWS WAF console mà không phát sinh thêm chi phí nào và không yêu cầu thiết lập bổ sung.


### **Thành công của khách hàng**

Những người dùng sớm đã nhận thấy lợi ích rõ rệt. Sarah Chen, Kỹ sư Bảo mật tại National Retail Corporation, chia sẻ: “Với bảng điều khiển mới, chúng tôi đã cấu hình bảo vệ cho các ứng dụng PHP của mình chỉ trong chưa đầy 10 phút. Các đề xuất quy tắc đã giúp chúng tôi xác định và chặn các cuộc tấn công tinh vi nhắm vào ứng dụng, giảm 60 phần trăm số sự cố bảo mật chỉ trong tháng đầu tiên.”


### **Kết luận**

Bằng cách kết hợp giám sát thông minh, cấu hình có hướng dẫn và khả năng truy cập đơn giản vào các giải pháp chuyên biệt, bảng điều khiển được nâng cấp của chúng tôi giúp các tổ chức duy trì tư thế bảo mật mạnh mẽ mà không phải đối mặt với sự phức tạp vốn có của việc quản lý bảo mật nâng cao.
