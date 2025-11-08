import { useDB } from '../utils/db/index.js';

export default defineEventHandler(async (event) => {
  const body = await readBody(event);

  // ✅ Check if required fields are present
  if (
    !body.data.deviceId ||
    !body.data.name ||
    !body.data.type ||
    !body.data.minTempInternal ||
    !body.data.maxTempInternal ||
    !body.data.minWarnInternal ||
    !body.data.maxWarnInternal ||
    !body.data.minTempProbe ||
    !body.data.maxTempProbe ||
    !body.data.minWarnProbe ||
    !body.data.maxWarnProbe ||
    !body.data.loggingInterval ||
    !body.data.sendingInterval
  ) {
    return { success: false, message: 'Missing values!!' };
  }

  const db = useDB();

  try {
    const [result] = await db.query(
      `UPDATE device_config
       SET 
         device_name = ?,
         device_type = ?,
         min_temp = ?,
         max_temp = ?,
         min_temp_warning = ?,
         max_temp_warning = ?,
         min_temp_probe = ?,
         max_temp_probe = ?,
         min_temp_warn_prob = ?,
         max_temp_warn_prob = ?,
         logging_interval = ?,
         sending_interval = ?,
         updated_by = ?
       WHERE device_id = ?`,
      [
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
        "yash",
        body.data.deviceId
      ]
    );

    if (result.affectedRows === 0) {
      return { success: false, message: "Device not found or not updated" };
    }

    return { success: true, message: "Device configuration updated successfully" };
  } catch (err) {
    console.error(err);
    return { success: false, message: "Database error", error: err };
  }
});
