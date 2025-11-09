import puppeteer from "puppeteer";
import fs from "fs";
import path from "path";
import { emailDb, useDB, auditDb } from "../utils/db/index.js";
import { start } from "repl";

export default defineEventHandler(async (event) => {
  const query = getQuery(event);
  const device_id = query.id;
  const start_date = query.start_date;
  const end_date = query.end_date;
  if (device_id === "" && start_date === "" && end_date === "") {
    return {
      success: false,
      message: "Please provide all the required fields",
    };
  }
  console.log("Generating PDF for Device ID:", query);
  const db = auditDb();
  const [result] = await db.query(
    "select * from devices_audit_report where device_id=? AND date_time BETWEEN ? AND DATE_ADD(?, INTERVAL 1 DAY)",
    [device_id, start_date, end_date]
  );

  const data = {
    make: "VEGA",
    model: "Model X100",
    deviceModel: "Cold Storage Logger",
    deviceName: "Temp Logger",
    instrumentId: "INS-2025",
    serialNo: "SN-ABC1234",
    tempResolution: "0.1°C",
    tempAccuracy: "±0.2°C",
    startDate: "2025-11-06 12:00",
    endDate: "2025-11-07 12:00",
    recordInterval: "10 min",
    sendingInterval: "30 min",
    minSetTemp: "2°C",
    maxSetTemp: "8°C",
    minTemp: "2.3°C",
    maxTemp: "7.8°C",
    mkt: "5.1°C",
    avgTemp: "4.8°C",
    year: new Date().getFullYear(),
    generatedAt: new Date().toLocaleString(),
    auditData: result,
  };

  // Load template
  const templatePath = path.resolve("./server/templates/device-report.html");
  let html = fs.readFileSync(templatePath, "utf-8");

  // Generate table rows dynamically
  const auditTableRows = data.auditData
    .map((row, index) => {
      const dateObj = new Date(row.date_time);
      const day = String(dateObj.getDate()).padStart(2, "0");
      const month = String(dateObj.getMonth() + 1).padStart(2, "0");
      const year = dateObj.getFullYear();
      const formattedDate = `${day}-${month}-${year}`;

      let hour = dateObj.getHours();
      const minute = String(dateObj.getMinutes()).padStart(2, "0");
      const ampm = hour >= 12 ? "PM" : "AM";
      hour = hour % 12;
      hour = hour ? hour : 12;
      const formattedTime = `${hour}:${minute} ${ampm}`;
      return `
  <tr>
          <td>${index + 1 ?? "N/A"}</td>
          <td class="date-time">${
            `${formattedDate} <br>${formattedTime}` ?? "N/A"
          }</td>
          <td>${row.module ?? "N/A"}</td>
          <td>${row.action ?? "N/A"}</td>

          <td>${row.description ?? "N/A"}</td>

          <td>${row.user_id ?? "N/A"}</td>


  </tr>
`;
    })
    .join("");

  // Replace placeholders
  for (const [key, value] of Object.entries(data)) {
    if (typeof value !== "object") {
      html = html.replaceAll(`{{${key}}}`, String(value ?? ""));
    }
  }

  // Replace audit table rows last
  html = html.replace("{{auditTableRows}}", auditTableRows);

  // Launch Puppeteer
  const browser = await puppeteer.launch({ headless: true });
  const page = await browser.newPage();
  await page.setContent(html, { waitUntil: "networkidle0" });

  // Generate PDF
  const pdfBuffer = await page.pdf({
    format: "A4",
    printBackground: true,
    margin: { top: 30, bottom: 30, left: 20, right: 20 },
  });

  await browser.close();

  // Return inline PDF
  event.node.res.setHeader("Content-Type", "application/pdf");
  event.node.res.setHeader(
    "Content-Disposition",
    'inline; filename="device-report.pdf"'
  );

  return pdfBuffer;
});
