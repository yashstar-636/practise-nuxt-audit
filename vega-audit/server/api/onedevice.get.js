import { auditDb } from '../utils/db/index.js';

export default defineEventHandler(async (event) => {
const query=getQuery(event)
const device_id=query.id
if(device_id===""){
  return
}
    // Insert into database
    const db = auditDb();
    const [result] = await db.query(
     'SELECT * FROM devices WHERE device_id = ?',
  [device_id]
    );
    
    return { success: true, result };
 
});