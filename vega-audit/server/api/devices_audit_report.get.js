import { auditDb } from '../utils/db/index.js';

export default defineEventHandler(async (event) => {

    // Insert into database
    const db = auditDb();
    const [result] = await db.query(
      'select * from devices_audit_report'
    );
    
    return { success: true, result };
 
});