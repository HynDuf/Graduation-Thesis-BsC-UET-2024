#import "/template.typ" : *

#[
  #set heading(numbering: "Chương 1.1")
  = Đề xuất phương pháp MPBoot2 <chuong4>
]

== Các thay đổi so với MPBoot

Chúng tôi cài đặt MPBoot2 bằng ngôn ngữ C/C++ dưới dạng một phần mềm dòng lệnh mã nguồn mở, dựa trên mã nguồn công bố của MPBoot và cấu trúc cây của thư viện PLL @flouri2015phylogenetic. MPBoot2 được công khai mã nguồn tại địa chỉ Github #link("https://github.com/HynDuf/mpboot/tree/mpboot2")[https://github.com/HynDuf/mpboot/tree/mpboot2].

MPBoot2 đã được sửa nhiều lỗi và tối ưu hóa đáng kể so với phiên bản 1, dẫn đến cải thiện khả năng tìm kiếm cây tối ưu hóa tối đa parsimony ngay khi sử dụng. Ngoài ra, MPBoot2 đã được nâng cấp đáng kể để hỗ trợ đầy đủ thao tác tree bisection and reconnection (TBR). Dựa trên phương pháp MPBoot-TBR mô tả ở @chuong3, chúng tôi đã tích hợp TBR vào MPBoot hỗ trợ tính toán cho cả chi phí đồng nhất và không đồng nhất, sử dụng thuật toán Fitch @fitch1971toward và Sankoff @sankoff1975minimal.

Cú pháp dòng lệnh để chạy MPBoot2 với các thao tác TBR trên MSA gốc được chỉ định bởi `<alignment_file>` như sau:
```sh
$ mpboot -s <alignment_file> -tbr_pars
```

Chiến lược tìm kiếm mặc định cho các thao tác TBR là chiến lược "tốt nhất", trong đó đánh giá tất cả các cặp cạnh thêm vào $I_1, I_2$ có thể xảy ra cho mỗi cạnh cắt $R$ và chọn cặp nhánh mang lại cải tiến tốt nhất. Một chiến lược tìm kiếm khác là chiến lược "tốt hơn", đánh giá các cạnh thêm $I_2$ tốt nhất trên cây con còn lại cho mỗi cạnh cắt $R$ và cạnh thêm đầu tiên $I_1$. Để sử dụng chiến lược này, thêm tùy chọn "`-tbr_better`" vào dòng lệnh. Để thực hiện tìm kiếm với điều kiện dừng 100 vòng lặp, sử dụng tùy chọn "`-stop_cond 100`".

Một tính năng nổi bật khác được bổ sung vào MPBoot2 là tính năng checkpoint, cho phép chương trình tiếp tục từ checkpoint cuối cùng đã lưu trong trường hợp bị gián đoạn hoặc gặp sự cố. Tính năng này giúp tránh phải chạy lại toàn bộ phân tích, từ đó tiết kiệm thời gian và tài nguyên tính toán. Hệ thống checkpoint tương thích với cả thuật toán tìm kiếm cây MP tiêu chuẩn và phương pháp xấp xỉ bootstrap. Để kích hoạt tính năng này, thêm tùy chọn "`-ckp`". Các tùy chọn mở rộng bao gồm "`-ckp_all`", lưu tất cả các checkpoint thay vì chỉ lưu checkpoint gần nhất; "`-ckp_rerun`", bỏ qua các checkpoint hiện có và chạy lại phân tích từ đầu; và "`-ckptime <checkpoint_time_interval_in_seconds>`", đặt khoảng thời gian tối thiểu giữa các lần xuất dữ liệu checkpoint.

Ngoài ra, các cải tiến khác đã được thực hiện để nâng cao hiệu suất của MPBoot2 khi làm việc với các tập dữ liệu lớn (tự động phát hiện dữ liệu lớn), tối ưu hóa quản lý bộ nhớ và tốc độ xử lý để xử lý các phân tích phả hệ lớn hơn và phức tạp hơn.

Hơn nữa, MPBoot2 hiện hỗ trợ tốt hơn cho nhiều loại dữ liệu khác nhau. Nhiều lỗi đã được sửa để cải thiện khả năng xử lý dữ liệu morphology (thêm tùy chọn "`-st MORPH`") và dữ liệu nhị phân (thêm tùy chọn "`-st BIN`"), đảm bảo các phân tích chính xác và đáng tin cậy hơn trên các định dạng tập dữ liệu khác nhau.

== Đánh giá thực nghiệm trên các bộ dữ liệu vừa và nhỏ
=== Dữ liệu <mpboot2-dataset>

Để đánh giá MPBoot2 trên các bộ dữ liệu thực tế có kích thước nhỏ và trung bình, chúng tôi sử dụng dữ liệu từ TreeBASE @piel2000treebase, như đã được phân tích trước đây bởi @nguyen2015iq. Bộ dữ liệu này bao gồm 115 sắp hàng đa chuỗi (MSA), trong đó 70 MSAs là loại DNA, có kích thước từ 200 đến hơn 700 dãy. 45 MSAs còn lại bao gồm các chuỗi protein (axit amin), với số lượng chuỗi trong sắp hàng dao động từ 50 đến gần 200.

Đối với bộ dữ liệu đánh giá độ chính xác bootstrap, chúng tôi tạo ra các bộ dữ liệu mô phỏng bằng công cụ Seq-gen. Bộ dữ liệu này bao gồm ba bộ dữ liệu DNA và hai bộ dữ liệu protein, mỗi loại chứa 200 MSAs. Các bộ dữ liệu được tạo ra bằng mô hình Yule-Harding để mô phỏng các mối quan hệ tiến hóa.

Ngoài ra, chúng tôi thử nghiệm MPBoot2 trên 30 bộ dữ liệu morphology, cũng được lấy từ cơ sở dữ liệu TreeBASE @piel2000treebase.

Cuối cùng, chúng tôi đánh giá MPBoot2 bằng cách sử dụng một bộ dữ liệu nhị phân, được lấy từ nghiên cứu của @chifman2014quartet.

=== Cài đặt thực nghiệm <mpboot2-settings>

Chúng tôi so sánh phiên bản SPR gốc (MPBoot phiên bản 1), kí hiệu là SPR6 (leo đồi SPR với bán kính 6), với một số phương pháp từ MPBoot2: TBR5 và TBR6 (leo đồi TBR với bán kính lần lượt là 5 và 6, sử dụng chiến lược mặc định tìm kiếm "tốt nhất"), TBR5-SC100 (TBR5 với điều kiện dừng ngắn hơn là 100 lần lặp không thành công), và TBR5-BETTER (TBR5 sử dụng chiến lược tìm kiếm "tốt hơn"). Tất cả các phương pháp này giữ lại một cây tốt nhất duy nhất cho mỗi bản sao bootstrap. Đối với ma trận chi phí, chúng tôi sử dụng cả ma trận chi phí đồng nhất và không đồng nhất, như được mô tả trong @hoang2018mpboot. Việc phá cây bằng parsimony ratchet trong những iteration chẵn được dùng như nhau trong tất cả các phương pháp. 

Đối với TNT (phiên bản 1.6, tháng 11 năm 2023), chúng tôi sử dụng chiến lược tìm kiếm chuyên sâu của phần mềm. Cụ thể, chúng tôi áp dụng lệnh "`xmult = notarget hits 3 level 0 chklevel +1 1`" cho MSA gốc, kết hợp nhiều chiến lược tìm kiếm khác nhau, bao gồm ratchet, tree fusing, sectorial search và tree drifting @goloboff2023tnt. Sau đó, chúng tôi sử dụng lệnh "`mult = rep 1 hold 1`" trên các bootstrap MSAs, thực hiện việc thêm ngẫu nhiên theo từng bước, sau đó sử dụng leo đồi TBR đầy đủ.

Thực nghiệm được thực hiện cho cả dữ liệu mô phỏng và dữ liệu sinh học trên hệ thống tính toán hiệu năng cao của Trường Đại học Công Nghệ, ĐHQGHN.

=== Tiêu chí đánh giá <mpboot2-crit>
==== Điểm MP

Chúng tôi trước tiên so sánh các thuật toán theo điểm MP của cây $T^"best"$. Cụ thể, với phương pháp $X$ và dataset $Y$, chúng tôi tính số lượng bộ dữ liệu trong $Y$ mà phương pháp $X$ đạt được điểm số tốt nhất trong số các phương pháp khảo sát.

==== Độ chính xác bootstrap

Chúng tôi cũng so sánh chất lượng tập $cal(B)$ các cây bootstrap của các thuật toán nhờ tính toán độ chính xác bootstrap trên kết quả phân tích dữ liệu mô phỏng. Độ chính xác của một phương pháp bootstrap, $Z$, được định nghĩa bởi $f_(Z)(v)$, là tỷ lệ của số cạnh có mặt trong cây đúng trong số tất cả các cạnh có giá trị hỗ trợ bootstrap $v%$ (đếm trên các cây $T^"best"$) @hillis1993empirical.
==== Thời gian thực thi

Với thước đo thứ 3 là thời gian thực thi, chúng tôi quan sát tổng thời gian (giờ) của việc phân tích bootstrap trên các MSAs.

=== Kết quả

==== Điểm MP

Như mô tả trong @fig-treebase-score, hiệu suất của các phương pháp khác nhau thay đổi đáng kể giữa dữ liệu DNA và protein dưới các điều kiện chi phí đồng nhất và không đồng nhất. Đối với dữ liệu DNA, dưới điều kiện chi phí đồng nhất, phương pháp TNT đạt kết quả tốt nhất, với 60 bộ dữ liệu đạt được điểm tối đa theo phương pháp đơn giản hóa tối ưu. Hiệu suất này được theo sau bởi TBR6 (50), TBR5-BETTER (47), và cả TBR5 và TBR5-SC100 (47), thể hiện hiệu quả tương tự như SPR6 (47). Dưới điều kiện chi phí không đồng nhất, TBR6 (53) và TBR5-BETTER (51) là các phương pháp có hiệu suất cao nhất, trong khi TNT có phần thấp hơn với 58 bộ dữ liệu. Các phương pháp khác như TBR5 (49) và TBR5-SC100 (48) cũng thể hiện hiệu suất mạnh mẽ, trong khi đó SPR6 chỉ đạt được 45 bộ dữ liệu.

Đối với dữ liệu protein, điều kiện chi phí đồng nhất cho thấy kết quả đồng đều hơn giữa các phương pháp. TBR5, TBR5-BETTER, TBR6 đạt được 41 bộ dữ liệu và SPR6, TBR5-SC100, TNT đạt được 40 bộ dữ liệu được điểm tốt nhất. Tuy nhiên, dưới điều kiện chi phí không đồng nhất, TBR6 (42) và TBR5-SC100 (42) là các phương pháp tốt hơn. Ngược lại, TNT cho thấy sự suy giảm đáng kể về hiệu suất, chỉ đạt được 14 bộ dữ liệu, thấp nhất trong tất cả các phương pháp. Các phương pháp khác, bao gồm TBR5 (42), SPR6 (42), và TBR5-BETTER (42), duy trì hiệu suất ổn định.

Những kết quả này cho thấy rõ sự thay đổi trong hiệu suất của các phương pháp phụ thuộc vào kiểu dữ liệu và điều kiện chi phí. Phương pháp TNT cho thấy hiệu suất vượt trội với dữ liệu DNA dưới điều kiện chi phí đồng nhất, nhưng hiệu suất giảm mạnh đối với dữ liệu protein dưới điều kiện chi phí không đồng nhất. Mặt khác, các phương pháp TBR\* mang lại độ chính xác cao ổn định trên cả hai loại dữ liệu và điều kiện chi phí, làm nổi bật tính tin cậy và mạnh mẽ của chúng, đặc biệt trong các tình huống yêu cầu hiệu suất ổn định trên các điều kiện khác nhau.

#figure(
  image("/images/treebase_4.png"),
  caption: [Hiệu suất của các phương pháp đánh giá trên bộ dữ liệu DNA và protein từ TreeBASE. Các biểu đồ cột thể hiện số lượng bộ dữ liệu (trong tổng số 115 bộ) mà phương pháp đạt được điểm số tốt nhất trong số các phương pháp khảo sát.],
) <fig-treebase-score>

==== Thời gian thực thi

Tổng thời gian chạy (tính bằng giờ) của mỗi phương pháp trên 115 bộ dữ liệu từ TreeBASE được trình bày trong  @tab-time-treebase, so sánh hiệu suất trong các điều kiện chi phí đồng nhất và không đồng nhất. Ngoài ra, bảng còn cung cấp tỷ lệ thời gian trung bình và trung vị so với SPR6 cho cả hai điều kiện chi phí.

Trong điều kiện chi phí đồng nhất, phương pháp nhanh nhất là TBR5-SC100 (30,2 giờ), tiếp theo là SPR6 (37,2 giờ). Các phương pháp chậm nhất là TBR6 (78,2 giờ) và TNT (75,5 giờ). Tỷ lệ thời gian trung bình của các phương pháp so với SPR6 trong điều kiện chi phí đồng nhất là 1.04 cho TBR5-SC100, 1.42 cho TBR5, 1.62 cho TBR5-BETTER, và 1.98 cho TBR6, với giá trị trung vị lần lượt là 0.96, 1.43, 1.60, và 1.96. TNT có tỷ lệ thời gian trung bình là 1.23 và trung vị là 0.47.

Trong điều kiện chi phí không đồng nhất, SPR6 vẫn là phương pháp hiệu quả nhất với thời gian chạy là 146.8 giờ, vượt trội hơn TBR5-SC100 (192.8 giờ) và TBR5 (240.1 giờ). Các phương pháp chậm nhất là TBR6 (338.8 giờ) và TNT (682.3 giờ). Tỷ lệ thời gian trung bình trong điều kiện chi phí không đồng nhất là 1.26 cho TBR5-SC100, 1.52 cho TBR5, 1.72 cho TBR5-BETTER, và 2.21 cho TBR6, với giá trị trung vị lần lượt là 1.17, 1.52, 1.71, và 2.18. TNT cho thấy tỷ lệ thời gian cao đáng kể với giá trị trung bình là 6.47 và trung vị là 3.55.

Đáng chú ý, TBR5-SC100 rất hiệu quả trong điều kiện chi phí đồng nhất nhưng kém cạnh tranh hơn trong điều kiện không đồng nhất, như được thể hiện qua cả thời gian chạy và tỷ lệ thời gian so với SPR6.

Tóm lại, TBR5-SC100 và SPR6 là hai phương pháp cân bằng, vừa nhanh vừa cho kết quả đủ tốt. Trong điều kiện chi phí đồng nhất, TBR5-SC100 chạy nhanh hơn SPR6, trong khi ở điều kiện chi phí không đồng nhất, TBR5-SC100 chạy chậm hơn một chút nhưng đạt được điểm MP tốt hơn so với SPR6. Chi tiết phân tích về điểm số và thời gian giữa các phương pháp được trình bày bổ sung ở @pl-2


#figure(
  table(
    columns: (2fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    inset: 7pt,
    align: (left, horizon, horizon, horizon, horizon, horizon, horizon),
    table.cell(rowspan: 2, align: horizon + center)[*Method*], table.cell(colspan: 3)[*Uniform cost*], table.cell(colspan: 3)[*Non-uniform cost*],
    [Time (hours)], [Mean], [Median], [Time (hours)], [Mean], [Median],
    [SPR6], [37.2], [1.00], [1.00], [*146.8*], [1.00], [1.00],
    [TBR5-SC100], [*30.2*], [1.04], [0.96], [192.8], [1.26], [1.17],
    [TBR5], [54.5], [1.42], [1.43], [240.1], [1.52], [1.52],
    [TBR5-BETTER], [67.3], [1.62], [1.60], [269.3], [1.72], [1.71],
    [TBR6], [78.2], [1.98], [1.96], [338.8], [2.21], [2.18],
    [TNT], [75.5], [1.23], [0.47], [682.3], [6.47], [3.55],
  ), 
  caption: [Thời gian chạy tổng cộng (giờ) và tỷ lệ thời gian (so với SPR6) của các phương pháp trên 115 bộ dữ liệu từ bộ dữ liệu TreeBASE]
) <tab-time-treebase>

Các thông tin trong @fig-treebase-score và @tab-time-treebase chỉ cung cấp thống kê tổng quan về các phương pháp, nên chúng tôi so sánh TBR5-SC100 (phương pháp cân bằng nhất) và  TNT toàn diện hơn trong @fig-tbr5sc100-tnt. Mỗi điểm trong hình biểu thị một bộ dữ liệu (trong tổng số 115 bộ), với trục ngang biểu thị sự chênh lệch điểm số parsimony tối đa và trục dọc biểu thị sự chênh lệch thời gian chạy. Các biểu đồ cột được đặt ở phía trên và bên cạnh cung cấp tần suất biên. Các điểm nằm bên trái đường đứt nét dọc biểu thị các căn chỉnh mà TBR5-SC100 đạt được điểm số parsimony tốt hơn. Các điểm nằm bên dưới đường đứt nét ngang biểu thị các trường hợp mà phân tích bootstrap của TBR5-SC100 nhanh hơn. Các tỷ lệ phần trăm trong các vùng của biểu đồ cột biểu thị tỷ lệ các điểm dữ liệu trong các khu vực đó. Các tỷ lệ phần trăm dọc theo đường đứt nét biểu thị tỷ lệ các sắp hàng mà cả hai phương pháp đều đạt được cùng một điểm số MP. 

Đối với các bộ dữ liệu DNA (xem #ref(label("fig-tbr5sc100-tnt"))a và c), TNT cho thấy điểm số MP tốt hơn trong điều kiện chi phí đồng nhất (30% so với 5.7%) và trong điều kiện chi phí không đồng nhất (22.1% so với 5.9%). Tuy nhiên, đối với các bộ dữ liệu protein (Hình #ref(label("fig-tbr5sc100-tnt"))b và d), TBR5-SC100 vượt trội hơn TNT trong điều kiện chi phí không đồng nhất (63.6% so với 0%) và kém hơn một chút so với TNT trong điều kiện chi phí đồng nhất (6.7% so với 8.9%).

Về thời gian chạy, trong điều kiện chi phí không đồng nhất (xem #ref(label("fig-tbr5sc100-tnt"))c và d), TBR5-SC100 chạy nhanh hơn đáng kể so với TNT (77.9% so với 22.1% cho các bộ dữ liệu DNA và 100% so với 0% cho các bộ protein). Tuy nhiên, trong điều kiện chi phí đồng nhất, TNT nhanh hơn so với TBR5-SC100 (xem #ref(label("fig-tbr5sc100-tnt"))a và b).

#figure(
  image("/images/tbr5_sc100_tnt.png", width: 95%),
  caption: [So sánh TBR5-SC100 và TNT trên chi phí đồng nhất (*a*, *b*) và chi phí không đồng nhất (*c*, *d*) trên các MSAs DNA và protein từ TreeBASE.],
) <fig-tbr5sc100-tnt>

==== Độ chính xác bootstrap

Hàm $f_("SPR6")(v)$ (đường màu đen), hàm $f_("TBR5")(v)$ (đường màu cam) và hàm $f_("TBR5-BETTER")(v)$ (đường màu xanh) cho 5 bộ YuleHarding được minh họa ở @bootstrap-acc. Trong cả 5 đồ thị, 2 đường cong của 2 hàm này nằm sát nhau và cùng nằm phía trên đường chéo cho thấy phiên bản mới cho độ chính xác bootstrap tương đương MPBoot.

#figure(
  image("/images/bootstrap.png", width: 90%),
  caption: [Độ chính xác bootstrap của các phương pháp TBR5 (đường màu cam), TBR5-BETTER (đường màu xanh) và SPR6 (đường màu đen - phiên bản MPBoot cũ)],
) <bootstrap-acc>

==== Dữ liệu morphology và nhị phân

#figure(
  image("/images/morp-score.png", width: 90%),
  caption: [Hiệu suất của các phương pháp đánh giá trên bộ dữ liệu morphology từ TreeBASE. Các biểu đồ cột thể hiện tỉ lệ số bộ dữ liệu (trong tổng số 30 bộ) mà phương pháp đạt được điểm số tốt nhất trong số các phương pháp khảo sát],
) <morp-score>

#figure(
  table(
    columns: 2,
    inset: 10pt,
    align: horizon,
    [*Method*], [*Runtime (hours)*],
    [SPR6], [1.9],
    [TBR5-SC100], [*1.6*],
    [TBR5], [2.4],
    [TBR5-BETTER], [3.1],
    [TBR6], [3.5],
    [TNT], [6.9],
  ),
  caption: [Thời gian chạy tổng cộng (giờ) của các phương pháp trên 30 bộ dữ liệu morphology]
) <tab-morp>

Trước đây, phiên bản MPBoot không hỗ trợ dữ liệu morphology. Trong phiên bản MPBoot2, tính năng này đã được hỗ trợ chính thức. Hiệu suất được trình bày trong @morp-score và @tab-morp. Mặc dù tất cả các phương pháp trong MPBoot2 không hiệu quả bằng TNT về điểm MP, nhưng lại nhanh hơn đáng kể.

Đối với dữ liệu nhị phân, MPBoot2 hiện cũng đã hỗ trợ. Khi chạy trên một bộ dữ liệu duy nhất, tất cả các phương pháp đều đạt được điểm tốt nhất là 1,847,943. NNI mất 144 giây, SPR6 mất 2,074 giây, TBR5 mất 3,264 giây, TBR5-BETTER mất 3,159 giây, và TNT mất 1,217 giây.

=== Phân tích về hiệu năng của TBR5 so với SPR6 <spr-vs-tbr>

Trong @tbr5_spr6 là phần phân tích kỹ càng hơn về hai phương pháp TBR5 và SPR6. Có thể thấy rằng, nhìn chung, TBR5 cho điểm MP tốt hơn SPR6, nhưng SPR6 lại chạy nhanh hơn đáng kể. Tuy nhiên, khi phân tích chi tiết hơn (xem @tbr5_vs_spr6) trên 115 bộ dữ liệu TreeBASE, xét trong hai trường hợp:

Đối với chi phí đồng nhất và chi phí không đồng nhất:

  - (1) Những bộ dữ liệu mà TNT tốt hơn SPR6, nhưng TBR5 lại tốt hơn hoặc bằng TNT.

  - (2) Những bộ dữ liệu mà TNT tốt hơn TBR5, nhưng SPR6 lại tốt hơn hoặc bằng TNT. 


#figure(
  table(
    columns: 6,
    inset: 10pt,
    align: horizon,
    table.cell(rowspan: 2)[], table.cell(rowspan: 2)[], table.cell(rowspan: 2)[*Testcases*], 
    table.cell(colspan: 3)[*MP Score*], [*SPR6*], [*TBR5*], [*TNT*],
    table.cell(rowspan: 8, rotate(-90deg, reflow: true)[
      *Uniform Cost*
    ]),
    table.cell(rowspan: 4)[*(1)*],
    [dna_M7929_428_15016], [91399], [*91395*], [91396],
    [dna_M7964_640_25260], [256917], [*256916*], [*256916*],
    [dna_M4794_204_12113], [34926], [*34923*], [*34923*],
    [prot_M11344_84_691], [9230], [*9228*], [*9228*],
    table.cell(rowspan: 4)[*(2)*],
    [dna_M1838_228_1131], [*20531*], [20534], [20532],
    [dna_M11745_316_1494], [*3277*], [3278], [*3277*],
    [dna_M9143_228_1223], [*1146*], [1148], [1147],
    [prot_M1118_137_348], [*2153*], [2154], [*2153*],
    table.cell(rowspan: 9, rotate(-90deg, reflow: true)[
      *Non-uniform Cost*
    ]),
    table.cell(rowspan: 5)[*(1)*],
    [dna_M7929_428_15016], [120458], [*120457*], [*120457*],
    [dna_M7024_767_5814], [122834], [*122825*], [*122825*],
    [dna_M7292_213_7572], [61697], [*61696*], [*61696*],
    [dna_M9033_300_1394], [5955], [*5954*], [*5954*],
    [dna_M3031_276_1518], [4232], [*4228*], [*4228*],
    table.cell(rowspan: 4)[*(2)*],
    [dna_M1224_210_8235], [*80910*], [80912], [*80910*],
    [dna_M5931_298_4948], [*16631*], [16632], [*16631*],
    [dna_M11745_316_1494], [*4169*], [4170], [4169],
    [prot_M11338_100_567], [*8219*], [8220], [*8219*],
  ),
  caption: [Phân tích các bộ dữ liệu mà SPR6 hoặc TBR5 vươn lên so với phương pháp còn lại]
) <tbr5_vs_spr6>

Nhận thấy ở cả hai trường hợp, số lượng bộ dữ liệu mà một phương pháp vượt trội so với phương pháp còn lại là tương đương nhau. Điều này gợi ý rằng SPR6 và TBR5 phù hợp tùy thuộc vào từng bộ dữ liệu cụ thể và mỗi phương pháp có điểm mạnh riêng. Nếu có một cách kết hợp cả hai phép biến đổi này, rất có thể sẽ tận dụng được các điểm mạnh của cả hai phương pháp.

#figure(
  image("/images/tbr5_spr6.png"),
  caption: [So sánh kết quả của TBR5 với SPR6 trên 115 bộ dữ liệu TreeBASE],
) <tbr5_spr6>


== Đánh giá thực nghiệm trên các bộ dữ liệu lớn

Chúng tôi sử dụng các bộ dữ liệu lớn, bao gồm Plant ($38 times 432014$), Bird ($52 times 4519041$), Insect ($144 times 383161$), và Mammal ($90 times 1848196$) được lấy từ @minh2021qmaker. Chúng tôi so sánh hiệu suất của một số phương pháp trên các bộ căn chỉnh chuỗi lớn (MSAs) này bằng cách sử dụng cả mô hình chi phí đồng nhất và không đồng nhất. Kết quả được tóm tắt trong @tab-fitch-big và @tab-sankoff-big, trình bày điểm MP đạt được và thời gian chạy (tính bằng giờ) của từng phương pháp.

Như trình bày trong @tab-fitch-big, tất cả các phương pháp --- NNI, SPR6, TBR5, và TNT --- đều đạt được các điểm MP bằng nhau trên cả bốn bộ MSA (Plant, Bird, Insect, và Mammal). Các điểm số này cho thấy các phương pháp đều chính xác ngang nhau đối với tiêu chí Maximum Parsimony. Tuy nhiên, hiệu suất thời gian chạy lại khác biệt đáng kể. NNI luôn cho thấy thời gian chạy nhanh nhất trên tất cả các bộ dữ liệu, với thời gian từ 0.3 giờ đối với bộ dữ liệu Plant đến 5.7 giờ đối với bộ dữ liệu Bird. Ngược lại, TNT có thời gian thực thi lâu nhất, với bộ dữ liệu Bird mất 7.2 giờ, tiếp theo là Mammal, Insect, và Plant với lần lượt 6.0, 13.0, và 0.5 giờ. SPR6 và TBR5 có thời gian chạy trung bình, trong đó TBR5 thường mất nhiều thời gian hơn SPR6.

Đối với điều kiện chi phí không đồng nhất, như trình bày trong @tab-sankoff-big, chúng tôi nhận thấy rằng các phương pháp khác mất quá nhiều thời gian để có thể so sánh, vì vậy chúng tôi chỉ trình bày kết quả cho NNI và TNT. NNI đạt được điểm MP tốt hơn TNT đối với cả hai bộ dữ liệu Plant và Insect, với điểm số lần lượt là 1,684,167 và 6,797,376, so với 1,684,262 và 6,797,627 của TNT. Mặc dù sự khác biệt về điểm số là rất nhỏ, NNI cũng vượt trội hơn TNT về thời gian chạy, hoàn thành phân tích bootstrap trong 81.2 giờ đối với Plant và 76.3 giờ đối với Insect. Trong khi đó, TNT chạy mất 112.9 giờ đối với Plant và lâu hơn nhiều đối với Insect (587.0 giờ), cho thấy một khoảng cách lớn về hiệu năng giữa hai phương pháp trong điều kiện chi phí không đồng nhất.

#figure(
  table(
    columns: (auto, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    inset: 7pt,
    align: (left, horizon, horizon, horizon, horizon, horizon, horizon, horizon, horizon),
    table.cell(rowspan: 2, align: horizon + center)[*MSA*], table.cell(colspan: 4)[*Maximum Parsimony Score*], table.cell(colspan: 4)[*Runtime (hours)*],
    [NNI], [SPR6], [TBR5], [TNT], [NNI], [SPR6], [TBR5], [TNT],
    [Plant], table.cell(colspan: 4)[1,520,763], [*0.3*], [1.7], [2.4], [0.5],
    [Bird], table.cell(colspan: 4)[7,378,469], [*5.7*], [49.3], [67.1], [7.2],
    [Insect], table.cell(colspan: 4)[5,651,669], [*2.0*], [24.0], [34.1], [13.0],
    [Mammal], table.cell(colspan: 4)[7,260,920], [*3.8*], [34.5], [57.8], [6.0],
  ), 
  caption: [Điểm MP và thời gian chạy (giờ) của các phương pháp trên các bộ dữ liệu lớn với điều kiện chi phí đồng nhất]
) <tab-fitch-big>
#figure(
  table(
    columns: (auto, 1fr, 1fr, 1fr, 1fr),
    inset: 7pt,
    align: (left, horizon, horizon, horizon, horizon),
    table.cell(rowspan: 2, align: horizon + center)[*MSA*], table.cell(colspan: 2)[*Maximum Parsimony Score*], table.cell(colspan: 2)[*Runtime (hours)*],
    [NNI], [TNT], [NNI], [TNT],
    [Plant], [*1,684,167*], [1,684,262], [*81.2*], [112.9],
    [Insect], [*6,797,376*], [6,797,627], [*76.3*], [587.0],
  ), 
  caption: [Điểm MP và thời gian chạy (giờ) của các phương pháp trên các bộ dữ liệu lớn với điều kiện chi phí không đồng nhất]
) <tab-sankoff-big>

#pagebreak()
