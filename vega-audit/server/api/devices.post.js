import {auditDb } from '../utils/db/index.js';


export default defineEventHandler(async (event) => {

   const body = await readBody(event);
if(
  body.data.deviceId===""||
  body.data.name===""||
  body.data.type===""||
  body.data.minTempInternal===""||
  body.data.maxTempInternal===""||
  body.data.minWarnInternal===""||
  body.data.maxWarnInternal===""||
  body.data.minTempProbe===""||
  body.data.maxTempProbe===""||
  body.data.minWarnProbe===""||
  body.data.maxWarnProbe===""||
  body.data.loggingInterval===""||
  body.data.sendingInterval===""||
  body.data.user_id===""
) {
    return { success: false, message: 'Missing values!!' };
  }
    const db = auditDb();                                                                                                                 
   
 const [final] = await db.query(
      `insert into devices (device_id,device_name,device_type,min_temp,max_temp,min_temp_warning,max_temp_warning,min_temp_probe,max_temp_probe,min_temp_warn_prob,max_temp_warn_prob,logging_interval,sending_interval,user_id)VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [  
  body.data.deviceId,
  body.data.name,
  body.data.type,
  body.data.minTempInternal,
  body.data.maxTempInternal,
  body.data.minWarnInternal,
  body.data.maxWarnInternal,
  body.data.minTempProbe,
  body.data.maxTempProbe,
  body.data.minWarnProbe,
  body.data.maxWarnProbe,
  body.data.loggingInterval,
  body.data.sendingInterval,
  body.data.user_id
]);  




    return { success: true, final};                                                                                            
 
});
