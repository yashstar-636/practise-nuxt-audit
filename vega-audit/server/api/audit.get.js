import { useDB } from '../utils/db/index.js';

export default defineEventHandler(async (event) => {

    // Insert into database
    const db = useDB();
    const [result] = await db.query(
      'select * from device_config'
    );
    
    return { success: true, result };
 
});