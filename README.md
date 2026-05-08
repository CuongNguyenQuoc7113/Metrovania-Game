# Metrovania Action Platformer - Technical Showcase

![Gameplay Preview](images/Metrovania.mp4) ## 🎮 Project Overview
Dự án này là bản demo kỹ thuật tập trung vào các hệ thống tương tác phức tạp và logic nhân vật được xây dựng bằng **C#** trên **Godot Engine**. Đây không chỉ là một trò chơi, mà còn là môi trường để tôi thử nghiệm lập trình bất đối xứng (asynchronous programming), quản lý trạng thái (state management) và hệ thống debug bài bản.

---

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
