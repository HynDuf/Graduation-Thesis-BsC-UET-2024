#import "/template.typ" : *

#[
  #set heading(numbering: "Chương 1.1")
  = Giới thiệu <chuong1>
]
== Tổng quan

Tin sinh học (Bioinformatics) là một lĩnh vực liên ngành kết hợp giữa sinh học, công nghệ
thông tin và toán học nhằm thu thập, phân tích và giải thích dữ liệu sinh học quy mô lớn,
như DNA, RNA, protein và bộ gen. Mục tiêu của tin sinh học là hiểu và mô hình hóa các quá
trình sinh học phức tạp, phát triển các thuật toán và công cụ để phân tích dữ liệu, từ đó
khám phá kiến thức mới về gen, protein, hoặc các vùng chức năng quan trọng, đồng thời hỗ
trợ nghiên cứu y học và phát triển các liệu pháp điều trị bệnh. Lĩnh vực này được ứng dụng
rộng rãi trong y học và dược phẩm, bao gồm phát triển thuốc, y học cá nhân hóa, nghiên cứu
ung thư; trong hệ gen học (genomics) với việc giải mã bộ gen, phân tích biến thể di
truyền; và trong hệ protein học (proteomics) với việc dự đoán cấu trúc và chức năng
protein. Ngoài ra, tin sinh học còn hỗ trợ phân tích mạng lưới sinh học, nghiên cứu tiến
hóa, và xử lý dữ liệu sinh học lớn, đóng vai trò quan trọng trong việc phát triển khoa học
sự sống và công nghệ sinh học hiện đại.

Cây tiến hóa (phylogenetic tree) là một biểu diễn đồ họa dùng để mô tả mối quan hệ tiến
hóa giữa các loài sinh vật dựa trên nguồn gốc chung của chúng. Cây này minh họa cách các
loài hoặc nhóm sinh vật phân nhánh từ một tổ tiên chung qua thời gian, phản ánh quá trình
tiến hóa thông qua sự thay đổi di truyền và chọn lọc tự nhiên. Ý tưởng về cây tiến hóa lần
đầu tiên được Charles Darwin giới thiệu trong tác phẩm nổi tiếng The Origin of Species
(1859) @darwin1859origin, nơi ông sử dụng hình minh họa duy nhất trong cuốn sách để thể
hiện khái niệm về sự phân nhánh và đa dạng hóa các loài trong tự nhiên (xem @phytree).

#figure(
  image("/images/phylogenetic-tree.png", width: 55%),
  caption: [Hình minh họa cây tiến hóa trong quyển "The Origin of Species" của Charles Darwin],
) <phytree>

Cây tiến hóa thường được mô tả dưới dạng cây phả hệ - một biểu đồ phân nhánh biểu thị mối
quan hệ tiến hóa giữa các loài hoặc nhóm sinh vật, với mỗi đỉnh (node) và mỗi nhánh
(branch) mang ý nghĩa riêng biệt. Các đỉnh trong cây đại diện cho các đơn vị sinh học,
chẳng hạn như loài, quần thể, hoặc tổ tiên chung, trong đó các đỉnh lá (leaf nodes) thường
biểu thị các loài hiện tại hoặc nhóm sinh vật được nghiên cứu, còn các đỉnh bên trong
(internal nodes) thể hiện tổ tiên chung của các nhóm con cháu. Các nhánh trong cây kết nối
các đỉnh, mô tả quá trình tiến hóa từ tổ tiên đến con cháu.

Phân tích cây tiến hóa đã chứng tỏ vai trò thiết yếu trong phân loại học
@nayfach2021genomic@zheng2020taxonomic, hay gần đây nhất là việc nghiên cứu và kiểm soát
đại dịch SARS-CoV-2 (Covid 19), khi nó giúp các nhà khoa học theo dõi sự tiến hóa và lây
lan của virus trên toàn cầu @gonzalez2020introductions@hodcroft811want. Bằng cách xây dựng
cây tiến hóa dựa trên dữ liệu bộ gen của hàng triệu mẫu virus được thu thập từ các bệnh
nhân, các nhà nghiên cứu có thể xác định được mối quan hệ giữa các biến thể của
SARS-CoV-2, từ đó theo dõi nguồn gốc và sự xuất hiện của các biến thể mới như Alpha,
Delta, và Omicron. Cây tiến hóa cung cấp thông tin quan trọng để hiểu cách các đột biến di
truyền ảnh hưởng đến khả năng lây nhiễm, đặc tính của virus, và từ đó tối ưu hiệu quả của vaccine. Ngoài ra, cây tiến hóa cũng hỗ trợ việc phát triển các chiến lược y tế công cộng, như giám sát dịch tễ học và dự báo sự bùng phát dịch bệnh, nhằm ứng phó kịp thời và hiệu quả với các biến thể nguy hiểm. Phân
tích này không chỉ minh chứng cho sức mạnh của khoa học dữ liệu trong y học hiện đại mà
còn mở ra hướng đi mới trong việc kiểm soát các dịch bệnh tương lai.

#figure(
  image("/images/covid-tree.png"),
  caption: [Cây tiến hóa mô tả các biến thể SARS-CoV-2 @wruck2021detailed],
)

Tiêu chí Maximum Parsimony (MP) được sử dụng để xây dựng cây tiến hóa bằng cách tối thiểu
hóa chi phí thay thế cần thiết để giải thích các chuỗi trong một sắp hàng đa chuỗi (Multiple Sequence Alignment - MSA).
Điểm MP của một cây được tính bằng cách cộng tổng điểm của từng vị trí (cột) trong MSA.

Bài toán xây dựng cây bootstrap tiến hóa (Phylogenetic Bootstrapping) (nguồn gốc từ phương
pháp bootstrap trong thống kê @efron1992bootstrap) liên quan đến việc tạo ra nhiều bản sao
bootstrap bằng cách lấy mẫu một số cột (có thể trùng nhau) của MSA gốc. Mục tiêu là xác định
cây tốt nhất cho cả MSA gốc và mỗi bản sao bootstrap, theo tiêu chí MP. Kết quả được tóm
tắt dưới dạng tần suất phân chia nhánh, được sử dụng để đánh giá giá trị hỗ trợ cho mỗi phân nhánh của cây. Xây dựng cây bootstrap tiến hóa theo tiêu
chuẩn Maximum Parsimony là bài toán tối ưu tổ hợp thuộc lớp NP-complete
@graham1982unlikelihood.

MPBoot @hoang2018mpboot là một công cụ phần mềm được thiết kế để thực hiện phân tích
bootstrap MP một cách hiệu quả. MPBoot sử dụng các phép thao tác biến đổi cây như
Nearest Neighbor Interchange (NNI) và Subtree Pruning and Regrafting (SPR) để tìm kiếm cây
tốt nhất. Tuy nhiên, MPBoot hiện tại chủ yếu dựa vào SPR. Điều này có thể hạn chế hiệu suất trong
việc khám phá không gian cây.

== Mục tiêu của đề tài

Xây dựng cây bootstrap tiến hóa theo tiêu chí maximum parsimony là một bài toán
NP-complete @graham1982unlikelihood, khiến thuật toán leo đồi trở thành lựa chọn phổ biến.
MPBoot hiện sử dụng leo đồi để cải thiện lời giải thông qua các kỹ thuật biến đổi cây như
Nearest Neighbor Interchange (NNI) và Subtree Pruning and Regrafting (SPR). Tuy nhiên,
phép biến đổi Tree Bisection and Reconnection (TBR), vốn mạnh mẽ hơn, vẫn chưa được tích
hợp vào MPBoot. Mục tiêu của khóa luận này là tích hợp TBR vào MPBoot, đồng thời phát
triển nhiều tính năng mới như checkpoint, hỗ trợ dữ liệu khác như morphology, binary, dữ
liệu lớn, và cải tiến các tính năng hiện có để phát triển phiên bản MPBoot2. Để khai thác
tối đa sức mạnh của các phép biến đổi, khóa luận còn phát triển MPBoot-RL, sử dụng giải
thuật đàn kiến (Ant Colony Optimization) để kết hợp linh hoạt các phép biến đổi, nhằm tối
ưu hóa cả điểm số và thời gian tính toán. Ngoài ra, khóa luận cũng thực hiện khảo sát liên quan giữa các thông số sử dụng các phép biến đổi cây với "độ khó" của tập dữ liệu.

// Đồng thời, khóa luận đề xuất một ánh xạ độ khó của dữ liệu dựa trên quá trình tối ưu của thuật toán.

== Cấu trúc của khóa luận
Phần còn lại của khóa luận này được trình bày như sau:
- @chuong2: Giới thiệu các khái niệm cơ sở về bài toán xây dựng cây bootstrap tiến hóa và
  giải thuật đàn kiến.

- @chuong3: Trình bày phương pháp tích hợp kĩ thuật biến đổi cây TBR vào MPBoot.
- @chuong4: Trình bày phiên bản MPBoot2.
- @chuong5: Trình bày phiên bản MPBoot-RL.
- @chuong6: Kết luận về các thuật toán đề xuất và kết quả thực nghiệm, đồng thời chỉ ra các
  định hướng cải tiến trong tương lai.
- #link(<phuluc>)[Phụ lục]: Trình bày phụ lục của khóa luận.
#pagebreak()
