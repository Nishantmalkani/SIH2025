# 🌾 AgroSmart: Implementation of Smart Agriculture for Efficient Cultivation in Hilly Regions

## Project Details

| Detail | Information |
| :--- | :--- |
| **Problem Statement ID** | **SIH 25062** |
| **Organization** | Government of Sikkim |
| **Department** | Department of Higher & Technical Education |
| **Theme** | Agriculture, FoodTech & Rural Development |
| **Category** | Hardware |
| **Team Name** | CODE-TIVATORS |

## Project Overview

**AgroSmart** is a low-cost, smart irrigation and crop advisory solution designed to combat water scarcity and climate variability in the challenging mountainous terrain of **Sikkim, India**. By integrating real-time environmental sensors with predictive intelligence and crucial farmer-centric data services, AgroSmart aims to maximize crop yield while minimizing water and energy usage.

---

## 💡 Background

The agricultural region of **Jorethang in South Sikkim** experiences harsh, rainless summers and frequent water scarcity, making traditional irrigation unreliable and inefficient. Farmers struggle to provide adequate water to crops, often leading to reduced yields and wasted resources. With climate change intensifying these issues, there's a pressing need for a **sustainable, smart irrigation approach** that maximizes water efficiency and crop productivity. Integrating rainwater harvesting, sensor-based monitoring, and crop-specific intelligence offers a forward-thinking solution to these regional challenges.

### Proposed Solution

**AgroSmart: A Sensor-Based Smart Irrigation System with Crop Intelligence and Rainwater Harvesting.**

This system aims to provide affordable, automated irrigation tailored to each crop’s needs using soil moisture and environmental sensors. It integrates a rainwater harvesting unit with real-time water level monitoring, ensuring efficient water use even during dry periods.

**Key Components of the Solution:**
* Soil moisture and temperature sensors to monitor field conditions.
* A crop database that determines optimal watering levels.
* Automated valve control through microcontrollers (Arduino/ESP32).
* Rainwater harvesting with level sensors to track available water.
* A mobile/web dashboard for farmers to monitor data and control irrigation remotely.
* Alerts and updates via SMS or app to keep farmers informed.

### Impact

AgroSmart **conserves water**, **improves crop yields**, **minimizes manual labour**, and helps farmers in Jorethang **adapt to climate variability** with a smart, self-sustaining irrigation system.

---

## ✨ Full Features List

AgroSmart provides a comprehensive solution for the modern organic farmer:

### 1. Precision Irrigation & Monitoring (Hardware Core)
* **Real-Time Data Collection:** Monitors key environmental parameters including **Soil Moisture**, **Temperature**, **Humidity (via DHT11/DHT22)**, and **Water Tank Level (via Ultrasonic Sensor)**.
* **Smart Automation:** Controls irrigation valves (**RELAY**) automatically based on sensor data and crop-specific optimal moisture levels.
* **Sustainable Power:** Uses **Solar Power + Battery Backup** to ensure continuous, off-grid operation and overcome power supply challenges in remote areas.

### 2. Intelligent Advisory & Digital Tools (The App)
* **ML-Driven Irrigation:** Utilizes **Machine Learning** models to predict *when* irrigation is precisely needed.
* **AI-Powered Health Check:** Allows farmers to upload a photo of a leaf to get a diagnosis, a full disease report, and general farm advisory using the **Gemini API**.
* **Crop Live Price Tracker:** Displays real-time prices (Mandi/Export) for key crops using the **E-nam API**.
* **Government Schemes Portal:** Provides localized information and an eligibility checker for Central and **Sikkim Govt. Schemes**.
* **Community & News Hub:** Delivers agricultural updates and fosters peer-to-peer engagement in **regional languages**.

---

## 💻 Technical Stack

| Component | Technology / Protocol | Function |
| :--- | :--- | :--- |
| **Microcontroller** | **ESP32** (for low cost & integrated Wi-Fi) | Gathers sensor data, processes local logic, and controls actuators. |
| **Communication** | **Wi-Fi / MQTT Protocol** | Sends data from the field to the Cloud in real-time. |
| **Cloud Database** | **Firebase** | Securely stores sensor data, manages user authentication, and hosts the crop database. |
| **Mobile Application** | **Flutter (Dart)** | Cross-platform (Android/iOS) frontend for remote control and data visualization. |
| **AI/Intelligence** | **Gemini API** | Visual analysis for crop health and natural language report generation. |

### Future Scope / Scalability
To overcome limitations of Wi-Fi range and power consumption for large, remote fields, the system is designed to be scalable by adopting **LoRaWAN / LTE-M** communication protocols in later phases.

---

## 📊 Competitive Analysis

AgroSmart’s key advantage is its low hardware cost and dedicated **localized features** tailored for the smallholder farmer in Sikkim.

| Feature | Our Solution (AgroSmart) | FASAL (Direct IoT Platform) | AgroStar (Digital Advisory) |
| :--- | :--- | :--- | :--- |
| **Sensor-Based Smart Irrigation** | ✅ | ✅ | ❌ |
| **Affordable, Low-Cost Hardware** | ✅ | ❌ | ❌ |
| **Real-Time Price Tracker (E-nam)** | ✅ | ❌ | ✅ |
| **Govt. Scheme Checker (Localized)** | ✅ | ❌ | ❌ |
| **Community/Peer-to-Peer Hub** | ✅ | ❌ | ✅ |

---



## 👥 Team (CODE-TIVATORS)

* **Bhavin Umatiya**
* **Nishant Malkani**
* **Anubhav Bhavsar**
* **Suhani Chaplot**
* **Aditya Lalchandani**
* **Shubham Prajapati**

---

