#import "/template.typ" : *

#[
  #set heading(numbering: "Chương 1.1")
  = Kết luận <chuong6>
]

== Kết quả đạt được

Qua quá trình nghiên cứu, cài đặt, thực nghiệm và hiệu chỉnh tham số, khóa luận
đã đạt được những kết quả như sau:

- Trình bày những khái niệm cơ bản về bài toán xây dựng cây bootstrap tiến hóa, thuật toán bootstrap chuẩn và xấp xỉ, các tiêu chuẩn đánh giá cây tiến hóa, các kĩ thuật biến đổi cây và các công trình liên quan.

- Trình bày những kiến thức về mô hình giải thuật tối ưu đàn kiến (ACO), các thành phần và các biến thể của thuật toán.

- Trình bày đề xuất tích hợp phép biến đổi cây TBR vào khung thuật toán MPBoot, chi tiết phương pháp cài đặt, tối ưu tính toán và sử dụng leo đồi TBR vào MPBoot. Hai chiến lược tìm kiếm với TBR được đề xuất bao gồm chiến lược tìm kiếm "tốt nhất" và chiến lược tìm kiếm "tốt hơn".

- Trình bày đề xuất MPBoot2 -- chính thức tích hợp TBR vào MPBoot cùng với cài đặt nhiều tính năng mới cho MPBoot như checkpoint, khả năng xử lý dữ liệu lớn, dữ liệu morphology, dữ liệu nhị phân...

- Trình bày đề xuất MPBoot-RL -- kết hợp các phép biến đổi cây NNI, SPR và TBR vào pha khám phá leo đồi của MPBoot sử dụng giải thuật tối ưu đàn kiến. Hai phiên bản được đề xuất bao gồm ACO-MUL (sử dụng quy tắc cập nhật mùi SMMAS-multiple) và ACO-ONCE (sử dụng quy tắc cập nhật mùi SMMAS gốc).

- Kết quả thực nghiệm cho thấy các phiên bản TBR cho điểm MP tốt hơn so với phiên bản MPBoot cũ (SPR6) nhưng hầu hết có thời gian thực thi lâu hơn, trừ phiên bản TBR5-SC100 có thời gian tương đương với SPR6. So với TNT, các phiên bản của MPBoot2, tuy không bằng TNT với điều kiện chi phí đồng nhất, áp đảo TNT với điều kiện chi phí không đồng nhất. Với các phiên bản MPBoot-RL, ACO-MUL và ACO-ONCE cho thấy kết quả điểm số tốt hơn hầu hết các phiên bản MPBoot khác và thời gian thực thi áp đảo.

- Thông qua thực nghiệm trên dữ liệu sinh theo mô hình Yule-Harding cho thấy độ chính xác bootstrap được đảm bảo tương đương với thuật toán gốc.

- Mã nguồn của MPBoot2 và MPBoot-RL được công bố lần lượt tại #link("https://github.com/HynDuf/mpboot/tree/mpboot2")[https://github.com/HynDuf/mpboot/tree/mpboot2] và #link("https://github.com/HynDuf/mpboot/tree/mpboot-rl")[https://github.com/HynDuf/mpboot/tree/mpboot-rl].

== Các định hướng phát triển
Các định hướng phát triển thuật toán trong tương lai bao gồm:
- Thử nghiệm MPBoot-RL với các quy tắc cập nhật mùi khác.

- Phân tích độ khó bộ dữ liệu dựa trên thông số sử dụng các phép biến đổi cây kết hợp với các đặc tính khác của bộ dữ liệu.

- Ý tưởng áp dụng giải thuật đàn kiến có thể áp dụng tương tự vào quá trình phá cây (các thuật toán phá cây như ratchet, random NNIs, IQP...)

- Tái cấu trúc phần cài đặt nhằm tối ưu việc thêm một phép biến đổi cây khác và kết hợp chúng sử dụng ACO trong tương lai.

#pagebreak()
