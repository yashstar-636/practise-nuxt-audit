import mysql from 'mysql2/promise'

let pool
export const useDB = () => {
  if (!pool) {
    pool = mysql.createPool({
      host: process.env.DB_HOST || 'localhost',
      user: process.env.DB_USER || 'root',
      password: process.env.DB_PASS || 'Admin',
      database: process.env.DB_NAME || 'vega',
    })
  }
  return pool
}

let email

export const emailDb=()=>{
if (!email) {
    email = mysql.createPool({
      host: process.env.DB_HOST || 'localhost',
      user: process.env.DB_USER || 'root',
      password: process.env.DB_PASS || 'Admin',
      database: "email",
    })
  }
  return email
}

let audit

export const auditDb=()=>{
if (!audit) {
    audit = mysql.createPool({
      host: process.env.DB_HOST || 'localhost',
      user: process.env.DB_USER || 'root',
      password: process.env.DB_PASS || 'Admin',
      database: "auditdb",
    })
  }
  return audit
}
