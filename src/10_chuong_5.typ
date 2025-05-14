#import "/template.typ" : *

#[
  #set heading(numbering: "Chương 1.1")
  = Đề xuất phương pháp MPBoot-RL <chuong5>
]

== Áp dụng ACO vào MPBoot2

Như đã phân tích ở @spr-vs-tbr, dù leo đồi sử dụng TBR5 nhìn chung có cải thiện hơn so với sử dụng SPR6, nhưng vẫn có nhiều bộ dữ liệu mà SPR6 tỏ ra hiệu quả hơn so với TBR5. Không những thế, với những bộ dữ liệu dễ, sử dụng thuật toán NNI khi đó sẽ tăng tốc độ tìm kiếm đáng kể. Vì những lí do trên, việc kết hợp NNI, SPR và TBR có tiềm năng cải thiện hiệu suất thuật toán, cải thiện điểm số, và từ đó tăng cường độ chính xác của bootstrap. Kết hợp các phép biến đổi cây có thể được thực hiện ở bước leo đồi ở pha khám phá của MPBoot (xem @mpboot-iter).

Chúng tôi đề xuất thuật toán MPBoot-RL để tăng cường pha khám phá (pha 2) của thuật toán MPBoot2 bằng cách sử dụng một phương pháp học tăng cường, cụ thể là giải thuật tối ưu đàn kiến (ACO). Thuật toán MPBoot-RL thay thế quá trình tối ưu hóa cây, trước đây chỉ sử dụng leo đồi SPR, bằng việc chọn một trong ba phép toán biến đổi cây: NNI, SPR và TBR (xem @mpboot-rl). Ngoài ra, chúng tôi thực hiện khảo sát liên quan giữa các thông số sử dụng các phép biến đổi cây với "độ khó" của tập dữ liệu (sử dụng Pythia @haag2022easy), gợi mở về cách dự đoán độ khó dữ liệu theo MPBoot2.

#figure(
  image("/images/mpboot-rl.png"),
  caption: [Minh họa cho khung thuật toán MPBoot-RL],
) <mpboot-rl>

=== Cấu trúc đồ thị

Cấu trúc đồ thị bao gồm một đỉnh khởi đầu $V_s$, một đỉnh kết thúc $V_e$ và một lớp giữa. Lớp này bao gồm ba đỉnh biểu diễn việc sử dụng các thuật toán leo đồi NNI, SPR và TBR. Đỉnh khởi đầu $V_s$ sẽ có các cạnh kết nối với ba đỉnh của lớp giữa. Cuối cùng, các đỉnh trong lớp sẽ kết nối với đỉnh kết thúc $V_e$. Tổng cộng, mạng bao gồm 5 đỉnh và 6 cạnh (xem @network-aco). 

#figure(
  image("/images/network.png", width: 50%),
  caption: [Cấu trúc đồ thị ACO],
) <network-aco>

=== Thông tin heuristic

Thông tin heuristics được cung cấp dưới dạng các tham số đầu vào, bao gồm các chi tiết heuristics cho các thuật toán leo đồi NNI, SPR và TBR. Do đó, thông tin heuristics cho một bước đi của con kiến sẽ được trích xuất tương ứng với đỉnh đích, cụ thể là NNI, SPR hoặc TBR. 

=== Vết mùi pheromone và các quy tắc cập nhật

Thông tin về vết mùi pheromone được đặt trên mỗi cạnh của cấu trúc đồ thị và được cập nhật theo các quy tắc cụ thể được sử dụng.

==== Quy tắc SMMAS

Quy tắc cập nhật của vết pheromone với hệ thống kiến SMMA (Smooth Max-Min Ant System) @do2008pheromone có thể được tổng kết như sau. Ban đầu, pheromone trên tất cả các cạnh được giảm ('bốc hơi') theo tỷ lệ $rho$ $(0 < rho < 1)$. Sau đó, nếu một cạnh thuộc giải pháp tốt nhất được tìm thấy trong thế hệ hiện tại, mức độ pheromone được cập nhật bổ sung tiến gần đến một giá trị tối đa $tau_"max"$; nếu không, nó được điều chỉnh về một giá trị tối thiểu $tau_"min"$.

Chúng tôi đề xuất áp dụng quy tắc SMMAS vào thuật toán MPBoot-ML như sau. Trong mỗi thế hệ kiến của thuật toán MPBoot-RL, quá trình cập nhật bao gồm một quy trình lựa chọn cẩn thận các giải pháp tốt nhất nhằm tối đa hóa điểm MP. Thuật toán xác định các con kiến có giải pháp tìm ra một cây có điểm MP tốt hơn hoặc bằng với điểm MP tốt nhất hiện tại đã tìm được của thuật toán. Những giải pháp này được coi là đáng kỳ vọng và được chọn cho quá trình cập nhật tiếp theo. Tuy nhiên, nếu không có giải pháp nào đáp ứng tiêu chí này, phép biến đổi cây nhanh nhất (phép NNI) sẽ được chọn.

Sau khi một thế hệ kiến hoàn thành, thuật toán tiến hành cập nhật vết mùi pheromone trên các cạnh. Tất cả các cạnh tồn tại trong ít nhất một trong các giải pháp tốt được lựa chọn được cập nhật lên mức pheromone tối đa $tau_"max"$, phản ánh sự đóng góp của chúng vào các giải pháp có triển vọng.

$ tau_e arrow.l.long (1- rho) dot.c tau_e + rho dot.c tau_"max" $

Ngược lại, các cạnh không thuộc bất kỳ giải pháp được lựa chọn nào sẽ được cập nhật xuống mức pheromone tối thiểu $tau_"min"$.

$ tau_e arrow.l.long (1- rho) dot.c tau_e + rho dot.c tau_"min" $

Quá trình cập nhật này củng cố các đường đi liên quan đến các giải pháp tốt và "né tránh" những đường đi không đóng góp đáng kể vào việc cải thiện điểm MP.

==== Quy tắc thử nghiệm SMMAS-multiple

Quy tắc thử nghiệm SMMAS-multiple đề xuất thêm một sự thay đổi cho mô hình cập nhật vết mùi pheromone đã được mô tả trước đó trong thuật toán MPBoot-ACO. Khác với quy tắc SMMAS ban đầu, nơi mỗi cạnh được cập nhật một lần duy nhất trong một thế hệ kiến, quy tắc SMMAS-multiple được thiết kế để ưu tiên cạnh mà tham gia vào *nhiều* (thay vì chỉ một) giải pháp tốt. 

Theo quy tắc SMMAS-multiple, tiêu chí lựa chọn để xác định các giải pháp triển vọng vẫn được giữ nguyên. Tuy nhiên, khác với quy tắc SMMAS gốc, cách tiếp cận này cho phép cạnh tham gia trong nhiều giải pháp được chọn được cập nhật nhiều lần lên mức pheromone tối đa. Cụ thể, nếu một cạnh đóng góp $k$ lần trong các giải pháp được chọn, nó sẽ được cập nhật $k$ lần để đạt đến mức pheromone tối đa $tau_"max"$.

$ tau_e arrow.l.long (1- rho) dot.c tau_e + rho dot.c tau_"max" space space "(lặp lại" k "lần)" $ 

Các cạnh không đóng góp vào bất kỳ giải pháp được chọn nào vẫn tuân theo quy tắc cập nhật SMMAS gốc, được cập nhật một lần đến mức pheromone tối thiểu $tau_"min"$.

Bằng cách cho phép các cạnh tích lũy cập nhật dựa trên sự đóng góp của chúng trong các giải pháp được chọn, cơ chế cập nhật SMMAS-multiple củng cố sự ảnh hưởng của các cạnh liên quan đến các giải pháp đã thể hiện thành công liên tục qua nhiều vòng lặp.

=== Quy trình bước đi ngẫu nhiên để xây dựng giải pháp

Con kiến di chuyển tuần tự từ $V_s$ đến lớp đầu tiên và sau đó trở lại $V_e$. Giả sử con kiến đang ở đỉnh $A$, nó sẽ di chuyển ngẫu nhiên dọc theo một cạnh đến một đỉnh trong lớp tiếp theo. Xác suất cho con kiến tại đỉnh $A$ di chuyển đến đỉnh $B$ tỉ lệ phụ thuộc vào mức độ của vết mùi pheromone và thông tin heuristic của đường đi $A arrow.r B$. 

$ "prob"_(A arrow.r B) = (tau_(A arrow.r B) dot.c eta_B) / (sum_(C in "adj"(A)) tau_(A arrow.r C) dot.c eta_C) $
trong đó:
- $"prob"_(A arrow.r B)$ là xác suất con kiến ở đỉnh $A$ di chuyển đến đỉnh $B$.
- $tau_(A arrow.r B)$ là mức độ pheromone của cạnh từ $A$ đến $B$.
- $eta_B$ là thông tin heuristic của đỉnh $B$.
- $"adj"(A)$ là tập các đỉnh mà $A$ nối tới.

=== Cài đặt

MPBoot-RL được triển khai bằng C/C++ như một chương trình dòng lệnh mã nguồn mở, dựa trên mã nguồn mở của MPBoot2. Dòng lệnh để chạy tìm kiếm cây đơn giản của MPBoot-RL với chiến lược SMMAS-multiple (hay ACO-MUL) trên MSA gốc được chỉ định bởi "`<alignment_file>`", có cú pháp như sau: 

```sh
$ mpboot -s <alignment_file> -aco
```
Cú pháp để tìm kiếm với chiến lược SMMAS gốc (hay ACO-ONCE) là:
```sh
$ mpboot -s <alignment_file> -aco -aco_once
```
Cú pháp đầy đủ để tìm kiếm với các tham số tùy chỉnh:

```sh
$ mpboot -s <alignment_file> -aco -aco_nni_prior 0.3 -aco_spr_prior 0.4 -aco_tbr_prior 0.4 -aco_evaporation_rate 0.25 -aco_update_iter 15 
```
Để thực hiện MP bootstrapping với $B$ sắp hàng bootstrap, thêm "`-bb <B>`" vào dòng lệnh.
== Đánh giá thực nghiệm
=== Cài đặt thực nghiệm

Chúng tôi so sánh hai phiên bản của MPBoot-RL (ACO-MUL (sử dụng quy tắc cập nhật mùi SMMAS-multiple) và ACO-ONCE (sử dụng quy tắc cập nhật mùi SMMAS gốc)) với các phương pháp được đề cập ở @mpboot2-settings. Các phiên bản MPBoot-RL sử dụng SPR với bán kính 6 (SPR6) và TBR với bán kính 5 (TBR5). Chúng tôi thử nghiệm hai phiên bản trên với nhiều tập siêu tham số khác nhau nhưng chỉ trình bày ở đây bộ siêu tham số cho kết quả tốt nhất đối với từng phiên bản. Tổng hợp kết quả của các tập siêu tham số khác nhau được trình bày ở @pl-aco

#[]
Đối với ACO-MUL:
- $tau_"max" = 1.0, space tau_"min" = 0.1$
- Độ bay hơi: $rho = 0.25$
- Thông tin heuristic: $eta_"NNI" = 0.3, space eta_"SPR" = 0.4, space eta_"TBR" = 0.4$
- Số lượng kiến ở mỗi thế hệ: $L = L_0 + ceil(n/100)$ với $L_0 = 15$ trong đó $n$ là số lượng taxa của sắp hàng gốc. Dễ thấy, số kiến được điều chỉnh động dựa trên kích thước của MSA đầu vào.
Đối với ACO-ONCE:
- $tau_"max" = 1.0, space tau_"min" = 0.1$
- Độ bay hơi: $rho = 0.1$
- Thông tin heuristic: $eta_"NNI" = 0.3, space eta_"SPR" = 0.4, space eta_"TBR" = 0.4$
- Số lượng kiến ở mỗi thế hệ: $L = L_0 + ceil(n/100)$ với $L_0 = 5$ trong đó $n$ là số lượng taxa của sắp hàng gốc. Dễ thấy, số kiến được điều chỉnh động dựa trên kích thước của MSA đầu vào.

#[]
Các thí nghiệm được tiến hành bằng dữ liệu mô phỏng và dữ liệu sinh học (70 bộ DNAs và 45 bộ protein) như đề cập ở @mpboot2-dataset trên hệ thống tính toán hiệu suất cao tại trường Đại học Công nghệ - Đại học Quốc gia Hà Nội. Các tiêu chí đánh giá cũng đã được đề cập ở @mpboot2-crit.

MPBoot-RL được công khai mã nguồn tại địa chỉ Github #link("https://github.com/HynDuf/mpboot/tree/mpboot-rl")[https://github.com/HynDuf/mpboot/tree/mpboot-rl].

=== Kết quả
==== Điểm MP

Kết quả về điểm MP của 2 phương pháp MPBoot-RL với các phương pháp khác được trình bày trong @treebase-aco. ACO-MUL hầu hết đạt được điểm MP tốt nhất so với các phương pháp khác của MPBoot, chỉ thua TBR6 ở dữ liệu DNA với chi phí không đồng nhất. Trong khi đó, ACO-ONCE có số bộ dữ liệu đạt điểm MP tốt nhất ngang với TBR5-SC100, nhỉnh hơn TBR5-SC100 một bộ dữ liệu DNA với chi phí không đồng nhất.

#figure(
  image("/images/treebase_4_aco.png"),
  caption: [Hiệu suất của các phương pháp đánh giá trên bộ dữ liệu DNA và protein từ TreeBASE. Các biểu đồ cột thể hiện số lượng bộ dữ liệu (trong tổng số 115 bộ) mà phương pháp đạt được điểm số tốt nhất trong số các phương pháp khảo sát.],
) <treebase-aco>

==== Thời gian thực thi

Trong @tab-time-aco, dễ thấy ACO-MUL và ACO-ONCE là hai trong những phiên bản có thời gian thực thi nhanh nhất (ACO-ONCE nhanh hơn ACO-MUL nhưng không nhiều). Với điều kiện chi phí đồng nhất, hai phiên bản này chỉ chậm hơn một ít so với TBR5-SC100 (31,5 giờ (ACO-MUL) và 30,6 giờ (ACO-ONCE) so với 30,2 giờ (TBR5-SC100)). Không những thế, với điều kiện chi phí không đồng nhất, ACO-MUL và ACO-ONCE là hai phiên bản có thời gian thực thi nhanh nhất. Khi tính tỷ số thời gian chạy với phiên bản SPR6, cả hai phương pháp ACO đều cho thấy tốc độ tính toán nhanh hơn ($approx 0,78$ với điều kiện chi phí đồng nhất và $approx 0,84$ với điều kiện chi phí không đồng nhất).

#figure(
  table(
    columns: (2fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    inset: 7pt,
    align: (left, horizon, horizon, horizon, horizon, horizon, horizon),
    table.cell(rowspan: 2, align: horizon + center)[*Method*], table.cell(colspan: 3)[*Uniform cost*], table.cell(colspan: 3)[*Non-uniform cost*],
    [Time (hours)], [Mean], [Median], [Time (hours)], [Mean], [Median],
    [*ACO-MUL*], [*31.5*], [*0.79*], [*0.79*], [*144.7*], [*0.85*], [*0.84*],
    [*ACO-ONCE*], [*30.6*], [*0.78*], [*0.79*], [*141.0*], [*0.85*], [*0.84*],
    [SPR6], [37.2], [1.00], [1.00], [146.8], [1.00], [1.00],
    [TBR5-SC100], [30.2], [1.04], [0.96], [192.8], [1.26], [1.17],
    [TBR5], [54.5], [1.42], [1.43], [240.1], [1.52], [1.52],
    [TBR5-BETTER], [67.3], [1.62], [1.60], [269.3], [1.72], [1.71],
    [TBR6], [78.2], [1.98], [1.96], [338.8], [2.21], [2.18],
    [TNT], [75.5], [1.23], [0.47], [682.3], [6.47], [3.55],
  ), 
  caption: [Thời gian chạy tổng cộng (giờ) và tỷ lệ thời gian (so với SPR6) của các phương pháp trên 115 bộ dữ liệu từ bộ dữ liệu TreeBASE]
) <tab-time-aco>

Từ các thông số trên, có thể thấy ACO-MUL có khả năng tối ưu điểm MP tốt ngang ngửa với TBR6 nhưng tốc độ thực thi nhanh gấp $approx 2.3$ lần so với TBR6. Chi tiết các phân tích về điểm số và thời gian giữa các phương pháp được trình bày bổ sung ở @pl-aco-1

==== Độ chính xác bootstrap

Hàm $f_("SPR6")(v)$ (đường màu đen), hàm $f_("ACO-MUL")(v)$ (đường màu cam) và hàm $f_("ACO-ONCE")(v)$ (đường màu xanh) cho 5 bộ YuleHarding được minh họa ở @bootstrap-acc-aco. Trong cả 5 đồ thị, 2 đường cong của 2 hàm ACO này nằm sát nhau và cùng nằm phía trên đường chéo cho thấy phiên bản mới cho độ chính xác bootstrap tương đương MPBoot.

#figure(
  image("/images/bootstrap-aco.png"),
  caption: [Độ chính xác bootstrap của các phương pháp ACO-MUL (đường màu cam), ACO-ONCE (đường màu xanh) và SPR6 (đường màu đen - của phiên bản MPBoot)],
) <bootstrap-acc-aco>

=== Khảo sát giữa các phép biến đổi cây với độ khó của dữ liệu

Liên quan đến độ khó của bộ dữ liệu, các nghiên cứu gần đây của @togkousidis2023adaptive và @haag2022easy đã giới thiệu Pythia, một mô hình hồi quy Random Forest nhằm giải quyết vấn đề độ khó của bộ dữ liệu trong suy luận tiến hóa, và Adaptive RAxML-NG, một chiến lược thích ứng dựa trên mô hình Maximum Likelihood. Chiến lược thích ứng của họ điều chỉnh mức độ kỹ lưỡng trong việc tìm kiếm cây dựa trên độ khó được dự đoán. Pythia cho chỉ số độ khó trong khoảng từ 0.0 (dễ nhất) đến 1.0 (khó nhất).

Chúng tôi khảo sát tỉ lệ sử dụng 3 phép biến đổi cây NNI, SPR và TBR trên 115 bộ dữ liệu TreeBASE với độ khó tương ứng của từng bộ được Pythia dự đoán ở @aco-diff. Dễ thấy rằng bộ dữ liệu mà Pythia đánh giá càng "khó" (chỉ số càng lớn), thì phép biến đổi SPR và TBR sẽ được sử dụng càng nhiều. Không những thế, trong những bộ dữ liệu khó đó, tỷ lệ tìm kiếm sử dụng phép TBR thường sẽ lớn hơn so với SPR.

#figure(
  grid(
    columns: 1,
    align: horizon,
    gutter: 10pt,
    [*(a) ACO-MUL*],     
    image("/images/acomul_diff.png"), 
    [$space$*(b) ACO-ONCE*],
    image("/images/acoonce_diff.png"),
  ),
  caption: [Khảo sát liên quan giữa ba phép biến đổi cây với độ khó Pythia của ACO-MUL và ACO-ONCE (đã làm mượt với window size = 30)],
) <aco-diff>

Khảo sát trên gợi ý cho việc đánh giá độ khó bộ dữ liệu sử dụng thông số sử dụng các phép biến đổi cây là khả thi. Một đề xuất đơn giản có thể là khi tỉ lệ sử dụng NNI lớn hơn so với 2 phép biến đổi còn lại thì bộ dữ liệu sẽ được đánh giá là "dễ" (tương ứng với độ khó Pythia $in (0.0;0.35)$), trong trường hợp 3 tỉ lệ ngang nhau sẽ được đánh giá là "trung bình" (tương ứng với độ khó Pythia $in (0.35;0.45)$) và các trường hợp còn lại sẽ được đánh giá lá "khó" (độ khó Pythia $in (0.45; 1.0)$. Tuy nhiên, để việc đánh giá độ khó được chính xác và khoa học hơn cần nghiên cứu thêm kết hợp một số đặc tính khác của bộ dữ liệu. 

Chú ý rằng, phương pháp Pythia khác biệt so với phương pháp của chúng tôi, vì Adaptive RAxML-NG yêu cầu huấn luyện mô hình trên một bộ dữ liệu tự gán nhãn. Sau khi huấn luyện, mô hình được sử dụng để dự đoán độ khó và triển khai một thuật toán chiến lược dựa trên độ khó đã dự đoán. Ngược lại, nghiên cứu của chúng tôi tập trung vào khả năng tự điều chỉnh và lựa chọn các phép biến đổi cây một cách tự nhiên bằng cách sử dụng thuật toán tối ưu hóa đàn kiến (Ant Colony Optimization). Sau đó, chúng tôi có thể phân tích sâu vào quy trình tự điều chỉnh này để ước lượng độ khó của bộ dữ liệu.

#pagebreak()
