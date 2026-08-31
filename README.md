# ⚡ Roblox Farm Tracker & Automation Hub

แดชบอร์ดติดตามสถานะการฟาร์มแบบเรียลไทม์ (Real-Time Multi-Account Farm Monitor) และสคริปต์ Automation UI Hub สำหรับเกม Roblox

---

## 🌟 ฟีเจอร์หลัก (Features)

### 1. 🌐 Web Dashboard (`index.html`)
- **Top Stats Summary**: สรุปยอดเงินรวม (Total Cash), อัตราผลิตรวม (Total Rate), ความเร็วเฉลี่ย (Avg Speed), และจำนวนบอทที่ออนไลน์
- **Multi-Account Cards**: แสดงการทำงานรายไอดีพร้อม Badge สเตตัส (Cash, Speed, House Lv/Slots, Main Pets, Sub Eggs)
- **Real-time Filter & Search**: ค้นหาไอดีและจัดเรียงตามเงิน, อัตราผลิต, ความเร็ว หรือชื่อไอดี
- **CRUD Operations**: เพิ่ม/แก้ไข/ลบไอดีผ่าน Modal ได้ทันที
- **Live Simulation Mode**: ระบบจำลองสถิติเพิ่มขึ้นแบบสดๆ สำหรับทดสอบหน้าเว็บ

### 2. ⚡ Backend Server (`server.js`)
- **REST API (`POST /api/update`)**: รับข้อมูลสเตตัสจากเกม Roblox และอัปเดตแบบไดนามิก
- **WebSocket Broadcast**: ส่งข้อมูลอัปเดตกระจายไปยังหน้าเว็บทุกแท็บทันทีแบบ Real-time โดยไม่ต้องรีเฟรช
- **Express Static Web Server**: ให้บริการบนพอร์ต `3000`

### 3. 🤖 Roblox Auto Sender (`roblox_sender.lua`)
- ดึงข้อมูลจาก `LocalPlayer` และ `leaderstats` ส่งกลับมาที่ Dashboard Server อัตโนมัติทุกๆ 5 วินาที
- รองรับ Executor ทุกตัว (`request`, `http_request`, `syn.request`)

### 4. 🎮 Roblox Rayfield UI Hub (`complete_hub_template.lua`)
- **🎯 แท็บระบบหลัก (Main Features)**:
  - สวิตช์เปิด/ปิด Auto Farm & Steal ไข่อัตโนมัติ
  - ดรอปดาวน์เลือกโซนเป้าหมาย (Cherry Blossom, Lava Volcano, Cosmic ฯลฯ)
  - ดรอปดาวน์เลือกระดับความหายากขั้นต่ำ (Common -> Secret)
  - แถบสไลด์ปรับ Player WalkSpeed (16 - 500)
- **🛠️ แท็บเครื่องมือเสริม (Utilities)**:
  - Infinite Jump (กระโดดกลางอากาศได้ไม่จำกัด)
  - Anti-AFK (กันหลุด 20 นาทีด้วย VirtualUser)
  - Server Hop (ย้ายเซิร์ฟเวอร์ใหม่) & Rejoin (เข้าห้องเดิม)
- **📊 แท็บ Dashboard Sync**: สวิตช์เปิด/ปิดส่งข้อมูลสดไปยัง Dashboard (Port 3000)
- **⚙️ แท็บตั้งค่า (Settings)**: ปรับแต่งปุ่มลัดเปิด/ปิด UI (Default: `Right Control`) และทำลาย UI

---

## 🚀 วิธีการติดตั้งและใช้งาน (Getting Started)

### 1. รัน Dashboard Server
```bash
# 1. ติดตั้ง Dependencies
npm install

# 2. เริ่มต้น Server
node server.js
```
เปิดบราวเซอร์ไปที่: `http://localhost:3000`

### 2. รันสคริปต์ใน Roblox
นำโค้ดในไฟล์ `roblox_sender.lua` หรือ `complete_hub_template.lua` ไปรันใน Roblox Executor ของคุณ (เช่น Synapse, Wave, Fluxus, Delta, Solara ฯลฯ) ข้อมูลจะถูกส่งมาแสดงผลบน Dashboard ทันที!

---

## 📁 โครงสร้างโปรเจกต์ (Project Structure)
```
├── complete_hub_template.lua  # สคริปต์ Rayfield GUI Hub ฉบับเต็ม
├── roblox_sender.lua          # สคริปต์ส่งข้อมูลสถิติจากเกมเข้า Dashboard
├── server.js                  # Node.js Server & WebSocket Backend
├── index.html                 # หน้าเว็บ Real-Time Farm Dashboard
├── package.json               # การตั้งค่า Dependencies ของ Node.js
└── README.md                  # เอกสารประกอบการใช้งาน
```

---

## 📜 License
MIT License
