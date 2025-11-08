import { useDB } from '../utils/db/index.js';
import nodemailer from 'nodemailer';
import path from 'path';
import { fileURLToPath } from 'url';
import { CronJob } from 'cron'


export default defineEventHandler(async (event) => {
  const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename); 

 const { data: body } = await readBody(event);

    // Insert into database
    const db = useDB();
    const [result] = await db.query(
      'INSERT INTO emails (email,birth_time,user_name) VALUES (?, ?, ?)',
      [body.email, body.birthDate, body.message]
    );
    
    return { success: true, body };
 
});


 const job = new CronJob('* * * * * *', async() => {

    const db = useDB();
   
 const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename); 

const [result] = await db.query(
      'select * from emails '
    );

    console.log("Data base here:",result.map((item,indx)=>item.birth_time))
//   try {
//     // Read POST body
   

//     if (!process.env.ETHEREAL_USER || !process.env.ETHEREAL_PASS) {
//       throw new Error('SMTP credentials are missing. Check your .env and nuxt.config.js');
//     }

//     // Create Nodemailer transporter
//     const transporter = nodemailer.createTransport({
//       host: process.env.ETHEREAL_HOST,
//       port: process.env.ETHEREAL_PORT,
//       secure: false,
//       service:'gmail',
//       auth: {
//         user:process.env.ETHEREAL_USER,
//         pass: process.env.ETHEREAL_PASS,
//       },
//     });

//     // Send email
//     const info = await transporter.sendMail({
//       from: process.env.ETHEREAL_USER,
//       to: body.email,
//       subject: `Hello ${body.message}`,
//       text: 'dear',
//       html: `<html>
//     <body>
//         <div ><strong>Happy birthday dear ${body.message},<br>${body.birthDate}</strong></div>
//         <img src="cid:birthdayImage" image"/>
//     </body>
// </html>`,
// attachments: [
//       {
//         filename: 'birthday.png',
//         path:   path.resolve(process.cwd(), 'app/assets/images/birthday.png'),
//         cid: 'birthdayImage' 
//       }
//     ]
//     });

//     console.log('Message sent:', info);

//   } catch (err) {
//     console.error('Email API error:', err);
//     return createError({
//       statusCode: 500,
//       statusMessage: 'Server error sending email',
//       data: { message: err.message },
//     });
//   }


      // const response = await $fetch('/api/do-something')
      // console.log('API response:', response.message)
    
  })
  job.stop()
