<h1 align="center">🎵 SQL Music Store Analysis 🎶</h1>

<p align="center">
  <i>Exploring business insights from a digital music store using PostgreSQL & PgAdmin4</i><br>
  <b>By <a href="https://github.com/abinash16216">Abinash S.K. Sahoo</a></b>
</p>

---

## 📘 Overview  

The **SQL Music Store Analysis** project explores a digital music store database to derive **data-driven insights**.  
The goal is to answer real-world business questions such as:  

- Who are the best customers?  
- Which cities and countries generate the highest revenue?  
- What music genres and artists are most popular?  

This project demonstrates **data analysis using SQL (PostgreSQL)** with **PgAdmin4** — showcasing skills in joins, aggregations, subqueries, CTEs, and window functions.

---

## 🧩 Database & Schema  

### 🎼 Database  
Database file used in this analysis:  
📂 [**Music_Store_database.sql**](https://github.com/abinash16216/Music_store_analysis/blob/main/Music_Store_database.sql)

### 🗺️ Schema Diagram  

<p align="center">
  <img src="https://github.com/abinash16216/Music_store_analysis/blob/main/music_storedb_schema.png" alt="Music Store Database Schema" width="750"/>
</p>

**Key Tables:**

| Table | Description |
|--------|-------------|
| **Employee** | Employee information and hierarchy |
| **Customer** | Customer details |
| **Invoice** | Purchase and billing details |
| **Invoice_Line** | Line-item details for invoices |
| **Track** | Track info such as name, genre, duration |
| **Album** | Albums mapped to artists |
| **Artist** | Artist and band details |
| **Genre** | Classification of music styles |

---

## 🧠 SQL Queries & Analysis  

(Queries omitted here for brevity — will be available in full SQL script file)

---

## 📊 Key Insights  

| Insight | Observation |
|----------|--------------|
| **Top Country (Invoices)** | USA |
| **Highest Revenue City** | Prague |
| **Best Customer** | Identified by max total spent |
| **Most Popular Genre** | Rock (dominant globally) |
| **Top Artist (by Revenue)** | Calculated dynamically using CTE |

---

## 🧰 Tools & Technologies  

- 🗄️ **Database:** PostgreSQL  
- 🧑‍💻 **Tool:** PgAdmin4  
- 💬 **Language:** SQL (CTEs, joins, window functions, aggregations)  
- 📊 **Optional Visualization:** Power BI / Tableau  

---

## 🚀 Future Enhancements  

- Create a **Power BI / Tableau dashboard** using SQL output  
- Build **stored procedures** for recurring insights  
- Integrate **Python (Pandas + SQLAlchemy)** for deeper data analysis  

---

## 👨‍💻 Author  

**Abinash S.K. Sahoo**  
💼 Associate Consultant | Aspiring Technical Business Analyst  

📫 [LinkedIn](https://www.linkedin.com/in/abinash16216)  
💻 [GitHub](https://github.com/abinash16216)

---

<p align="center">
  ⭐ <b>If you found this project insightful, please give it a star!</b> ⭐  
</p>
