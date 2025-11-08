import { auditDb } from '../utils/db/index.js';

export default defineEventHandler(async (event) => {
const query=getQuery(event)
console.log("hello",query.id)
    // Insert into database
    const db = auditDb();
    const [result] = await db.query(
      'select * from devices'
    );
    
    return { success: true, result };
 
});