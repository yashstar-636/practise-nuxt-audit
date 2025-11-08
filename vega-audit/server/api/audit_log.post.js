import {emailDb } from '../utils/db/index.js';


export default defineEventHandler(async (event) => {

   const body = await readBody(event);
   console.log("sjhs",body.data)
if(
  body.data.device_id===""||
  body.data.action===""||
  body.data.user_id===""||
  body.data.description===""||
  body.data.device_id===""
) {
    return { success: false, message: 'Missing values!!' };
  }
    // Insert into database
    const db = emailDb();                                                                                                                 
   
 
const [final] = await db.query(
      `insert into vega_audit (module,action,user_id,description,device_id)VALUES ( ?, ?, ?, ?,?)`,
      [  
  body.data.module,
  body.data.action,
  body.data.user_id,
  body.data.description,
  body.data.device_id
]);  


    return { success: true, final};                                                                                            
 
});
