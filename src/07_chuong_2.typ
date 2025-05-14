#import "/template.typ" : *

#[
  #set heading(numbering: "Chương 1.1")
  = Các khái niệm cơ sở <chuong2>
]

== Bài toán xây dựng cây bootstrap tiến hóa
=== Mô hình bài toán

Bài toán xây dựng cây tiến hóa bootstrap nhận vào một ma trận $A^("data")$ kích thước $n times m$,
đại diện cho $n$ chuỗi, mỗi chuỗi có $m$ ký tự. Mỗi chuỗi trong số $n$ chuỗi này tương ứng
với chuỗi sinh học của một loài đang được nghiên cứu. Các đặc điểm sinh học rất đa dạng và
có thể bao gồm DNA, protein, morphology hoặc dữ liệu nhị phân. Ngoài ra, một số $B$ (thông
thường $B=1000$) được cung cấp, đại diện cho số lượng các mẫu bootstrap. Mỗi cây tiến hóa
ứng viên $T$ cho $A^"data"$ là một cây nhị phân có gốc với $n$ lá, trong đó mỗi lá tương
ứng với một chuỗi (xem @msa).

#figure(
  image("/images/msa.png", width: 90%),
  caption: [Ví dụ sắp hàng đa chuỗi (MSA) và cây tiến hóa đơn giản],
) <msa>

Kết quả đầu ra của bài toán là cây tốt nhất $T^"best"$, giải thích tốt nhất sắp hàng $A^"data"$,
và một tập hợp $cal(B)$ các cây tốt nhất $T^"best"_b$ cho các mẫu bootstrap $A_b$ (với $b = 1, dots , B$).
Mỗi sắp hàng bootstrap $A_b$ là một mẫu bootstrap của sắp hàng ban đầu $A^"data"$, được
tạo ra với cùng kích thước bằng cách lấy mẫu cột (cho phép lặp lại)
đúng $m$ lần từ $A^"data"$. Chất lượng của một cây được đánh giá dựa trên một tiêu
chí xác định trước.

Tập hợp các cây bootstrap $cal(B)$ thường được tóm tắt dưới dạng một vectơ tần suất của
các phân hoạch nhị phân được ánh xạ lên $T^"best"$ (xem @boot-example) hoặc dưới dạng một
cây đồng thuận. Hai phương pháp tóm tắt phổ biến là bootstrap chuẩn và bootstrap xấp xỉ.
Phương pháp bootstrap chuẩn @efron1992bootstrap@felsenstein1985confidence xây dựng các cây
trong tập $cal(B)$ một cách độc lập bằng cách thực hiện các lần duyệt không gian tìm kiếm
riêng biệt cho từng mẫu bootstrap. Tần suất được gán cho mỗi phân hoạch nhị phân trên $T^"best"$ được
gọi là giá trị hỗ trợ bootstrap cho nhánh đó.

Do mỗi cây bootstrap được tối ưu bằng cách thực hiện một lần tìm kiếm độc lập trên mỗi sắp
hàng bootstrap, phương pháp này tiêu tốn khá nhiều chi phí tính toán. MPBoot tối ưu bằng
phương pháp bootstrap xấp xỉ, chỉ thực hiện một lần duyệt không gian tìm kiếm duy nhất, và
tập hợp các cây $cal(B)$ được chọn từ các cây mà thuật toán đã đánh giá trong lần tìm kiếm này.

#figure(
  image("/images/boot-example.png"),
  caption: [Ví dụ minh họa tổng hợp kết quả bootstrap],
) <boot-example>

Các nghiên cứu về việc xây dựng cây tiến hóa thường dựa vào hai giả định quan trọng sau
đây @dhar2015maximum:

- Sự tiến hóa giữa các cột trong dữ liệu (trên một cây nhất định) là độc lập.
- Quá trình tiến hóa là độc lập giữa các phân hoạch nhị phân trên cây.

=== Tiêu chuẩn đánh giá cây tiến hóa

Trong bài toán xây dựng cây tiến hóa, ba tiêu chuẩn thường được sử dụng để đánh giá một
cây tiến hóa là:

- Tiếp cận Bayesian

- Tiêu chuẩn Maximum Likelihood
- Tiêu chuẩn Maximum Parsimony

==== Tiếp cận Bayesian

Tiếp cận Bayes sử dụng suy diễn Bayes để đánh giá một cấu trúc cây. Với một vectơ độ dài
nhánh $"l"$ và mô hình thay thế $theta$, công thức @bayesian sau đánh giá mức độ phù hợp
của cấu trúc cây $T$ với sắp xếp $A^"data"$:

#numbered_equation(
  $ P(T, l, theta | A^"data") = (P(A^"data" | T, l, theta) dot.c P(T, l, theta)) / P(D) $,
  <bayesian>,
)
Trong đó:
- $P(A^"data" | T, "l", theta)$ là xác suất hợp lý của $A^"data"$ cho cây $T$.
- $P(T, l, theta)$ là xác suất tiên nghiệm.
- $P(D)$ là xác suất biên.

Xác suất hợp lý $P(A^"data" | T, l, theta)$ được tính bằng thuật toán cắt tỉa Felsenstein.
Do không gian tìm kiếm rất lớn, tiếp cận Bayes thường được sử dụng cùng các thuật toán
Markov Chain Monte Carlo (MCMC) để xấp xỉ.

==== Tiêu chuẩn Maximum Likelihood

Ước lượng hợp lý cực đại (Maximum Likelihood Estimation - MLE) là phương pháp ước lượng
tham số tối ưu để tối đa hóa xác suất quan sát dữ liệu thực tế dưới một mô hình. Trong xây
dựng cây tiến hóa loài, MLE dùng hàm likelihood để tính xác suất dữ liệu trình tự sinh học
dọc theo cấu trúc cây và độ dài nhánh.

Hàm likelihood $L(T, l, theta)$ cho sắp xếp dữ liệu $A^"data"$, cấu trúc cây $T$, độ dài
nhánh $l$, và mô hình thay thế $theta$ được định nghĩa theo công thức @llh1 (dựa trên giả
định về sự tiến hóa của các cột $A^"data"_i$ là độc lập):

#numbered_equation(
  $ L(A^"data" | T, l, theta) = product_(i=1)^n P(A^"data"_i | T, l, theta) $,
  <llh1>,
)
Trong đó:
- $A^"data"_i$ là cột thứ $i$ của sắp xếp dữ liệu $A^"data"$,
- $P(A^"data"_i | T, l, theta)$ là xác suất hợp lý cho cột thứ $i$ của sắp xếp dữ liệu.

Xác suất $P(A^"data"_i | T, l, theta)$ được tính qua thuật toán cắt tỉa Felsenstein, là
tổng hợp các xác suất chuyển trạng thái dọc theo các nhánh của cây, tính theo công thức
@llh2:
#numbered_equation(
  $ P(A^"data"_i | T, l, theta) = sum_x pi_x L_(u)(x) = sum_x pi_x product_v ( sum_y L_(v)(y) dot.c p_(x y)(l_v) ) $,
  <llh2>,
)
Trong đó:
- $pi_x$ là tần số ổn định của ký tự $x$,
- $L_(v)(y)$ là xác suất tại nút $v$ giả định ký tự $y$ tại nút đó,
- $p_(x y)(l_v)$ là xác suất chuyển từ ký tự $x$ sang $y$ dọc theo nhánh có độ dài $l_v$.

Phương pháp này giúp tìm ra các tham số cây tiến hóa sao cho xác suất đúng với quan sát dữ liệu là
cao nhất.

==== Tiêu chuẩn Maximum Parsimony

Tiêu chí Tiết kiệm Tối đa (Maximum Parsimony - MP) sử dụng điểm MP để đánh giá mức độ phù
hợp của một cấu trúc cây $T$ trong việc giải thích sắp xếp trình tự $A^"data"$. Điểm MP
của $T$ là chi phí tối thiểu của các thay đổi ký tự cần thiết để giải thích các trình tự
quan sát tại các nút lá, dựa trên tổ tiên chung gần nhất của chúng. Điểm MP cho toàn bộ
sắp hàng được tính theo công thức @mp:

#numbered_equation($ "MP"(T | A^"data") = sum_(i=1)^m "MP"(T | D_i) $, <mp>)

Ở đây, $"MP"(T | D_i)$ là điểm MP của cây $T$ cho cột $D_i$. Điểm MP cho một cột được tính
bằng thuật toán Fitch @fitch1971toward (cho các thay đổi có chi phí đồng nhất) hoặc thuật
toán Sankoff @sankoff1975minimal (cho các thay đổi có chi phí không đồng nhất).

Mục tiêu khi xây dựng cây tiến hóa là tìm cây có điểm MP nhỏ nhất mô tả $A^"data"$, gọi
là cây MP.

#figure(
  image("/images/mp-score.png", width: 90%),
  caption: [Ví dụ đơn giản về tiêu chí MP],
)

=== Các kĩ thuật biến đổi cây thông dụng

Khi xây dựng cây tiến hóa, một trong những thách thức lớn là tìm ra cấu trúc cây tối ưu
nhất phù hợp với dữ liệu sinh học. Do không gian cây tiến hóa rất rộng lớn (hàm giai thừa
của $n$ với cây có $n$ lá), các phương pháp đơn giản như so sánh trực tiếp giữa tất cả các
cấu trúc cây có thể không thực tế do chi phí tính toán quá lớn. Vì vậy, các chiến lược
heuristics để tìm kiếm cây đủ tốt thường được áp dụng @lemey2009phylogenetic. Từ đây, các
kỹ thuật biến đổi cây đã được phát triển để cải thiện hiệu quả tìm kiếm và tối ưu hóa cây
tiến hóa.

Các kỹ thuật biến đổi cây giúp thay đổi cấu trúc của cây hiện tại thông qua các phép toán
chỉnh sửa cây, nhằm khám phá các cấu trúc cây khác có thể phù hợp hơn với dữ liệu. Những
phép toán này giúp tối ưu hóa cây tiến hóa bằng cách điều chỉnh các nhánh và cấu trúc của
cây mà không cần phải xây dựng lại cây từ đầu. Trong đó, các kỹ thuật như nearest-neighbor
interchange (NNI), subtree pruning and regrafting (SPR), và tree bisection and
reconnection (TBR) là những phương pháp biến đổi cây thông dụng trong phân tích tiến hóa.

#figure(
  image("/images/3-operations.png", width: 95%),
  caption: [Minh họa các phép biến đổi cây],
)

==== Nearest Neighbor Interchange (NNI)

Nearest Neighbor Interchange (NNI) (xem @nni-example) là một trong những phép biến đổi cây đơn giản và phổ biến
nhất trong phân tích phát sinh loài. Cụ thể, NNI thực hiện trên một cặp nhánh kề nhau, thay thế chúng bằng
hai cấu trúc cây thay thế. Phép toán này có phạm vi hạn chế vì chỉ cho phép thay đổi giữa
hai nút liền kề, nghĩa là không khám phá tất cả các khả năng sắp xếp cây. Tuy nhiên,
sự đơn giản và chi phí tính toán tương đối thấp khiến NNI trở thành phương pháp phổ biến để
tối ưu hóa cây.

NNI đặc biệt hữu ích trong việc khám phá nhanh chóng các thay đổi nhỏ trong một phần cây,
làm cho nó hiệu quả trong việc cải thiện khả năng (likelihood) hoặc điểm tính toán
parsimony của cây mà không cần thay đổi cấu trúc lớn. Phép biến đổi này cũng dễ tính toán và cài đặt, vì
chỉ thay đổi cấu trúc của một phần nhỏ trong cây.

#figure(image("/images/NNI.png"), caption: [Minh họa phép biến đổi cây NNI]) <nni-example>

==== Subtree pruning and regrafting (SPR)

Subtree Pruning and Regrafting (SPR) (xem @spr-example) là một phép toán cây phức tạp hơn so với NNI. Nó bao
gồm hai bước chính:

- Cắt bỏ một nhánh con (prune) khỏi cây (loại bỏ một nhóm các nút và các cạnh nối với
  chúng).
- Nối lại nhánh con đã cắt vào một nhánh khác trong cây gốc.

SPR cho phép thực hiện các thay đổi lớn hơn trong cấu trúc cây so với NNI vì nó có thể di
chuyển nhánh con qua các phần lớn hơn của cây. Phép toán này mở ra một phạm vi rộng hơn
các thay đổi cấu trúc cây, có thể dẫn đến các giải pháp tốt hơn về khả năng (likelihood)
hoặc điểm parsimony.

Mặc dù tốn kém về mặt tính toán hơn NNI, SPR có thể cung cấp những cái nhìn sâu hơn về các
mối quan hệ phát sinh loài giữa các taxon. SPR đặc biệt hữu ích trong các trường hợp cây có
thể có các mối quan hệ phát sinh loài phức tạp, yêu cầu các thay đổi phức tạp hơn để tìm kiếm một cách hiệu quả.

#figure(image("/images/SPR.png"), caption: [Minh họa phép biến đổi cây SPR]) <spr-example>

==== Tree bisection and reconnection (TBR)

Tree Bisection and Reconnection (TBR) (xem @tbr-example1) là một trong những phép toán cây mạnh mẽ nhất trong
phân tích phát sinh loài, cho phép thực hiện các thay đổi lớn nhất về cấu trúc cây. TBR
hoạt động bằng cách chia đôi cây thành hai phần, thường là cắt một cạnh, sau đó kết nối
lại hai phần này theo một cấu trúc mới. Phép toán này có thể được thực hiện theo nhiều
cách khác nhau, cung cấp một số lượng lớn các khả năng tái kết nối để khám phá.

TBR rất linh hoạt và có khả năng khám phá không gian cây toàn diện hơn so với NNI hoặc
SPR. Điều này làm cho nó trở thành phương pháp mạnh mẽ để tối ưu hóa cây phát sinh loài,
vì nó có thể tìm ra các cấu trúc cây chính xác hơn, phù hợp với dữ liệu tốt hơn. Tuy
nhiên, vì độ phức tạp của nó, TBR tốn kém về mặt tính toán và có thể yêu cầu nhiều tài
nguyên và thời gian hơn để thực hiện. Dù vậy, TBR thường được sử dụng trong các trường hợp
mà các phương pháp tìm kiếm cây phức tạp hơn là cần thiết để bao quát hết sự đa dạng của
các cấu trúc cây có thể có.

#figure(image("/images/TBR.png"), caption: [Minh họa phép biến đổi cây TBR]) <tbr-example1>

=== Các công trình liên quan
==== Các công trình sử dụng phương pháp bootstrap chuẩn

Phương pháp bootstrap chuẩn xây dựng tập cây $cal(B)$ thông qua $B$ lần chạy thuật toán
tìm kiếm cây độc lập với mỗi $A_b$. Các công trình sử dụng phương pháp này bao gồm TNT
@goloboff2023tnt, PAUP\* @swofford2003phylogeny, MEGA @tamura2007mega4. Vì phương pháp
bootstrap chuẩn có xu hướng đánh giá thấp khả năng đúng của một phân hoạch nhị phân
@hillis1993empirical@minh2013ultrafast, nên quy tắc thực hành phổ biến là coi các cạnh có
giá trị hỗ trợ bootstrap hơn 70% là đáng tin cậy.

==== Phương pháp MPBoot

Phương pháp MPBoot sử dụng tiêu chuẩn maximum parsimony (với ưu điểm là tính đơn giản, dễ
cài đặt và hiệu quả trong thiết kế cấu trúc dữ liệu) cùng với phương pháp xấp xỉ bootstrap
để giải quyết bài toán xây dựng cây bootstrap tiến hóa. Phương pháp xấp xỉ bootstrap trong
MPBoot xác định tập hợp $cal(B)$ bằng cách thực hiện một lần tìm kiếm cây trong không gian
cây biểu diễn sắp hàng gốc $A^"data"$ (xem @approx-boot).

#figure(
  image("/images/approx-boot.png", width: 85%),
  caption: [Phương pháp xấp xỉ bootstrap],
) <approx-boot>

Đối với một cây $T$ gặp phải trong quá trình tìm kiếm leo đồi SPR, MPBoot tính toán điểm
số của cây này trên từng sắp hàng bootstrap $b$ ($A^"data"_b$), sau đó cập nhật cây
bootstrap cho $A^"data"_b$ nếu $T$ có điểm số MP tốt hơn. Vì quy trình này tiêu tốn nhiều
thời gian nên cần phải tính toán hiệu quả điểm MP của $T$ trên $A^"data"_b$. Để tối ưu hóa
công đoạn này, MPBoot sử dụng Resampling parsimony score (REPS) @hoang2018mpboot cho từng
sắp hàng bootstrap (xem @reps).

Đối với một cây $T$ và điểm MP tại các cột $D_i$ ($"MP"(T | D_i)$) được tính từ $A^"data"$,
điểm MP cho $A^"data"_b$ được tính nhanh chóng dưới dạng tổng điểm MP tại các cột tương
ứng được sử dụng trong sắp hàng bootstrap $b$:

$ "MP"(T | A^"data"_b) = sum_(i=1)^k "MP"(T | D_i) dot.c d^b_i $
trong đó $d^b_i$ là tần suất xuất hiện của cột $D_i$ trong $A^"data"_b$. Nhờ vậy, không
cần phải tính lại điểm tiết kiệm cho từng cột, từng lần lặp bootstrap và từng cây.

#figure(
  image("/images/reps.png", width: 70%),
  caption: [Minh họa sử dụng kĩ thuật REPS để tính điểm MP của sắp hàng bootstrap],
) <reps>

Với phương pháp bootstrap xấp xỉ trên, một cạnh được coi là đáng tin cậy nếu giá trị hỗ
trợ bootstrap theo MPBoot của cạnh đó cao hơn 95% @hoang2018mpboot. MPBoot hiện tại cài
đặt hai kỹ thuật biến đổi cây bao gồm NNI và SPR, trong đó SPR được sử dụng chủ đạo trong
suốt quá trình tìm kiếm của MPBoot.

== Giải thuật tối ưu đàn kiến

Giải thuật tối ưu đàn kiến (Ant Colony Optimization - ACO) là một kỹ thuật tối ưu hóa dựa
trên hành vi tìm đường của đàn kiến trong tự nhiên. Đây là một trong những giải thuật
thuộc nhóm trí tuệ bầy đàn (Swarm Intelligence), được đề xuất bởi Marco Dorigo vào năm
1992 @colorni1991distributed.

=== Tổng quan

Trong tự nhiên, các cá thể kiến di chuyển ngẫu nhiên và khi tìm thấy thức ăn, chúng quay
trở về tổ, đồng thời để lại dấu vết pheromone. Nếu các con kiến khác tìm thấy con đường
này, chúng sẽ có xu hướng ngừng di chuyển ngẫu nhiên và thay vào đó đi theo dấu vết
pheromone, đồng thời quay lại và củng cố dấu vết đó nếu cuối cùng chúng tìm được thức ăn.

Tuy nhiên, theo thời gian, dấu vết pheromone bắt đầu bay hơi, làm giảm "sức hút" của đường
đi đó. Với một con đường dài, thời gian kiến cần để di chuyển tìm kiếm thức ăn và quay lại
sẽ càng lâu, dẫn đến các vết mùi pheromone càng bị bay hơi lâu hơn. Ngược lại, một con
đường ngắn sẽ được di chuyển thường xuyên hơn, dẫn đến mật độ pheromone trên con đường
ngắn cao hơn so với các con đường dài. Sự bay hơi pheromone cũng có lợi thế là tránh hội
tụ vào một giải pháp tối ưu cục bộ. Nếu không có sự bay hơi, các con đường được chọn bởi
những con kiến đầu tiên sẽ trở nên quá hấp dẫn đối với các con kiến tiếp theo, làm hạn chế
việc khám phá không gian giải pháp. Mặc dù tác động của sự bay hơi pheromone trong hệ
thống tự nhiên chưa rõ ràng, nhưng trong các hệ thống nhân tạo, sự bay hơi này đóng vai
trò rất quan trọng.

Kết quả chung là khi một con kiến tìm thấy một con đường tốt (ví dụ như ngắn) từ tổ đến
nguồn thức ăn, các con kiến khác có nhiều khả năng đi theo con đường đó, và phản hồi tích
cực sẽ dẫn đến nhiều con kiến cùng theo một con đường duy nhất. Ý tưởng của thuật toán bầy
kiến là mô phỏng hành vi này bằng cách sử dụng "kiến mô phỏng" di chuyển trên đồ thị đại
diện cho bài toán cần giải quyết.

=== Cấu trúc thuật toán

Trong các giải thuật tối ưu đàn kiến (ant colony optimization), một con kiến nhân tạo là
một "agent" tính toán đơn giản, tìm kiếm các giải pháp tốt cho một bài toán tối ưu hóa
nhất định. Để áp dụng thuật toán đàn kiến, bài toán tối ưu hóa cần được chuyển đổi thành
bài toán tìm đường đi ngắn nhất trên một đồ thị có trọng số.

#[]
Giải thuật ACO hoạt động theo các bước chính sau:

- Khởi tạo các tham số và lượng pheromone ban đầu.
- Xây dựng giải pháp: Mỗi con kiến xây dựng một giải pháp hoàn chỉnh dựa trên xác suất lựa
  chọn được tính từ ma trận pheromone và thông tin heuristic.
- Cập nhật pheromone: Sau khi tất cả kiến hoàn thành tour của mình, lượng pheromone được cập
  nhật. Đường đi tốt sẽ được tăng cường pheromone, trong khi các đường kém sẽ bị bay hơi
  dần.
- Lặp lại quá trình cho đến khi đạt điều kiện dừng.

==== Xây dựng giải pháp

Mỗi con kiến cần xây dựng một giải pháp để di chuyển qua đồ thị. Để chọn cạnh tiếp theo
trong hành trình của mình, một con kiến sẽ xem xét độ dài của mỗi cạnh có sẵn từ vị trí
hiện tại, cũng như mức độ pheromone tương ứng. Ở mỗi bước của thuật toán, mỗi con kiến di
chuyển từ trạng thái $x$ đến trạng thái $y$, tương ứng với một giải pháp trung gian đầy đủ
hơn. Do đó, mỗi con kiến $k$ tính toán một tập $A_k(x)$ các mở rộng khả thi đối với trạng
thái hiện tại của nó trong mỗi vòng lặp và di chuyển đến một trong các mở rộng này với xác
suất. Đối với con kiến $k$, xác suất $p_(x y)^k$ di chuyển từ trạng thái $x$ đến trạng
thái $y$ phụ thuộc vào sự kết hợp của hai giá trị, sự hấp dẫn $eta_(x y)$ của bước di
chuyển, được tính toán bằng một số chiến lược heuristic chỉ ra mức độ ưu tiên đối với bước
di chuyển đó và mức độ pheromone $tau_(x y)$ của bước di chuyển, chỉ ra mức độ hiệu quả
của bước di chuyển đó trong quá khứ. Mức độ pheromone đại diện cho sự chỉ dẫn dựa trên
kinh nghiệm về mức độ mong muốn của bước di chuyển đó.

Thông thường, con kiến $k$ di chuyển từ trạng thái $x$ đến trạng thái $y$ với xác suất:

$ p_(x y)^k = ((tau_(x y)^alpha) (eta_(x y)^cal(B))) / (sum_(z in "allowed"_y) (tau_(x z)^alpha) (eta_(x z)^cal(B))) $
trong đó $tau_(x y)$ là lượng pheromone được để lại khi chuyển từ trạng thái $x$ đến trạng
thái $y$, $alpha gt.eq 0$ là tham số điều khiển ảnh hưởng của $tau_(x y)$, $eta_(x y)$ là
mức độ "hấp dẫn" khi chuyển trạng thái từ $x$ đến $y$ (thường được gọi là thông tin
heuristic) và $cal(B) gt.eq 1$ là tham số điều khiển ảnh hưởng của $eta_(x y)$. $tau_(x z)$ và $eta_(x z)$ đại
diện cho mức độ pheromone và sự hấp dẫn đối với các cách chuyển trạng thái khác có thể có.

==== Cập nhật pheromone

Các dấu vết thường được cập nhật khi tất cả các con kiến đã hoàn thành giải pháp của
chúng, tăng hoặc giảm mức độ pheromone của các giải pháp tương ứng với giải pháp đó "tốt" hay "xấu". Một ví dụ về quy tắc cập nhật pheromone toàn cục là:
$ tau_(x y) arrow.l.long (1-rho)tau_(x y) + sum_k^m Delta tau_(x y)^k $
trong đó $tau_(x y)$ là lượng pheromone được để lại khi chuyển trạng thái từ $x$ đến $y$, $rho$ là
hệ số bay hơi pheromone, $m$ là số lượng con kiến và $Delta tau_(x y)^k$ là lượng
pheromone được thả ra bởi con kiến $k$, thường được cho theo công thức:

$ Delta tau_(x y)^k := cases(Q \/ L_k &" nếu kiến" k "sử dụng cạnh" x y "trong lời giải", 0 &" nếu không") $
trong đó $L_k$ là chi phí của hành trình của con kiến $k$ (thường là chiều dài) và $Q$ là
một hằng số.

=== Các biến thể của giải thuật tối ưu đàn kiến

Thuật toán được đề cập ở trên là thuật toán ACO đầu tiên, có tên gọi là thuật toán Ant
System (AS) @colorni1991distributed.

==== Thuật toán Ant Colony System (ACS)
Trong thuật toán ACS, hệ thống kiến gốc đã được chỉnh sửa ở ba khía cạnh:

- Việc chọn cạnh nghiêng về khai thác (tức là ưu tiên chọn các cạnh ngắn nhất có lượng
  pheromone lớn);
- Trong quá trình xây dựng giải pháp, các con kiến thay đổi mức độ pheromone của các cạnh mà
  chúng đang chọn bằng cách áp dụng một quy tắc cập nhật pheromone cục bộ;
- Vào cuối mỗi vòng lặp, chỉ có con kiến tốt nhất mới được phép cập nhật các dấu vết bằng
  cách áp dụng một quy tắc cập nhật pheromone toàn cục đã được sửa đổi.

==== Thuật toán Elitist ant system (EAS)

Trong thuật toán này, giải pháp tốt nhất toàn cục sẽ để lại pheromone trên dấu vết của nó
sau mỗi vòng lặp (ngay cả khi dấu vết này không được quay lại), cùng với tất cả các con
kiến khác. Chiến lược ưu tú có mục tiêu chỉ đạo quá trình tìm kiếm của tất cả các con kiến
để xây dựng một giải pháp chứa các liên kết của tuyến đường tốt nhất hiện tại.

==== Thuật toán Max–Min Ant System (MMAS)

Thuật toán này kiểm soát lượng pheromone tối đa và tối thiểu trên mỗi dấu vết. Chỉ có
chuyến đi tốt nhất toàn cục hoặc chuyến đi tốt nhất trong vòng lặp mới được phép thêm
pheromone vào dấu vết của nó. Để tránh sự trì trệ trong thuật toán tìm kiếm, phạm vi lượng
pheromone có thể có trên mỗi dấu vết bị giới hạn trong một khoảng $[tau_"min",tau_"max"]$.
Tất cả các cạnh đều được khởi tạo với $tau_"max"$ để thúc đẩy việc khám phá các giải pháp
cao hơn. Các dấu vết sẽ được khởi tạo lại với $tau_"max"$ khi gần đến mức trì trệ.

==== Thuật toán Rank-based ant system (ASrank)

Tất cả các giải pháp đều được xếp hạng theo chiều dài của chúng. Chỉ có một số lượng con
kiến tốt nhất trong vòng lặp này mới được phép cập nhật dấu vết của chúng. Lượng pheromone
được lưu lại sẽ được cân nhắc cho từng giải pháp, sao cho các giải pháp có đường đi ngắn
hơn sẽ lưu lại nhiều pheromone hơn các giải pháp có đường đi dài hơn.

==== Thuật toán đàn kiến song song (PACO)

Do các cá thể kiến trong thuật toán rất độc lập với nhau nên các cá thể kiến có thể được
chia thành các nhóm và chạy đồng thời trên các bộ xử lý khác nhau. Điều này giúp tăng hiệu
suất của thuật toán, tuy nhiên cần có các phương pháp trao đổi thông tin vết mùi pheromone
giữa các nhóm một cách hiệu quả. Có một số phương pháp trao đổi vết mùi thông dụng như
all-to-all, directed/undirected ring, hypercube, random,...

==== Thuật toán Max-Min trơn (SMMAS)

Một cải tiến so với giải thuật đàn kiến gốc là giải thuật đàn kiến Max-Min (MMAS) (đặt thêm
giới hạn trên và dưới cho các giá trị mùi nhằm thúc đẩy việc khám phá và tránh sự hội tụ
sớm). Xây dựng trên MMAS, giải thuật đàn kiến Max-Min trơn (SMMA) @do2008pheromone tích hợp
một cơ chế làm mượt điều chỉnh vào quy tắc cập nhật mùi nhân tạo. Yếu tố làm mượt này giúp
điều chỉnh tốc độ thay đổi của mùi nhân tạo, chuyển từ việc tập trung vào việc khám phá
vào giai đoạn đầu của tìm kiếm đến việc khai thác mạnh mẽ hơn khi thuật toán hội tụ.

#pagebreak()
