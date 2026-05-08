# Metrovania - Technical Showcase

## 🎮 Gameplay Preview
<div align="center">
  <video src="images/Metrovania.mp4" width="100%" controls autoplay muted loop>
    Trình duyệt không hỗ trợ xem video.
  </video>
</div>

---

## 🛠 Technical Deep Dive

### 1. Level Design & Environment
Sử dụng các hệ thống ánh sáng (Light Occlusion) và khu vực kích hoạt (Trigger Zones) để tạo ra môi trường công nghiệp đầy thử thách.
![Industrial Level Design](images/Metro1.jpg)

### 2. Collision & Physics Auditing
Hình ảnh dưới đây minh họa các đường kẻ Hitbox và Collision Shapes trong chế độ Debug, đảm bảo sự nhất quán 100% trong tương tác vật lý giữa nhân vật và môi trường.
![Physics Debug Mode](images/Metro3.jpg)

### 3. Boss Encounter Logic
Thiết kế cơ chế tấn công (Attack Patterns) cho Boss "Giant Claw", bao gồm việc tính toán vùng nguy hiểm và phản hồi của người chơi.
![Boss Fight Mechanics](images/Metro2.jpg)

## 🛠 Key Technical Features

### 1. Advanced Character Controller
* **C# Implementation:** Xử lý đầu vào chính xác theo từng khung hình (frame-perfect input).
* **State Transitions:** Chuyển đổi trạng thái mượt mà giữa di chuyển, nhảy tường (wall-jump) và lướt (dash).

### 2. State Machine Architecture (FSM)
* Sử dụng cấu trúc **Finite State Machine** để quản lý hành vi nhân vật.
* Giúp giảm thiểu xung đột logic và tăng khả năng bảo trì mã nguồn (code maintainability).

### 3. Systematic Interaction Logic
* **Decoupled Systems:** Thiết kế các hệ thống tách biệt cho việc đổi vũ khí và tương tác môi trường.
* Đảm bảo tính mô-đun (modularity) và khả năng mở rộng (scalability) cho dự án.

### 4. Collision & Physics Auditing
* Phát triển các giải pháp tùy chỉnh để giải quyết các vấn đề phát hiện va chạm phức tạp.
* Đảm bảo sự nhất quán 100% trong các tương tác vật lý.

---

## 🧠 Core Competencies Demonstrated
* **Logic Auditing:** Rà soát kỹ lưỡng các script C# để tìm và khắc phục lỗi edge-case trong vòng lặp chiến đấu.
* **Performance Optimization:** Tối ưu hóa vòng lặp gameplay để duy trì độ ổn định cao ngay cả trong kịch bản tải nặng.
* **Data Integrity:** Triển khai luồng dữ liệu cấu trúc cho thuộc tính nhân vật và hệ thống kho đồ để ngăn lỗi trạng thái.

---

## 📂 Project Structure
* `/Scripts`: Core C# logic (controllers, managers, system auditors).
* `/Docs`: Tài liệu kỹ thuật và sơ đồ logic (flowcharts) được sử dụng trong quá trình phát triển.

---

## 🔗 Links
* **Portfolio:** [https://cuong-nguyen-quoc-portfolio.netlify.app/](https://cuong-nguyen-quoc-portfolio.netlify.app/)
* **Contact:** cuongnguyenquoc003@gmail.com
