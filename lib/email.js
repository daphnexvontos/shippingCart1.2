// import { Moment } from "moment";
// import nodemailer from "nodemailer";

// const MAIL_SETTINGS = {
//   host: "smtp.gmail.com",
//   auth: {
//     user: "test@gmail.com",
//     access_token: String(process.env.ACCESS_TOKEN_GOOGLE_MAILER),
//     refresh_token: "<your-key-here>",
//     type: "OAuth2",
//     client_id: "<your-key-here>",
//     client_secret: "<your-key-here>",
//   },
//   port: 465,
//   secure: true,
// };

// let transporter = nodemailer.createTransport({
//   host: "smtp.gmail.com",
//   port: 465,
//   secure: true,
//   auth: {
//     type: "OAuth2",
//     user: "test@gmail.com",
//     clientId: "<your-key-here>",
//     clientSecret: "<your-key-here>",
//     refreshToken: "<your-key-here>",
//     accessToken: String(process.env.ACCESS_TOKEN_GOOGLE_MAILER)
//   },
// });

// export const verifyAdminEmail = async (emailTo: string, link: string) => {
//   try {
//     let info = await transporter.sendMail({
//       from: MAIL_SETTINGS.auth.user,
//       to: emailTo,
//       subject: `Title`,
//       html: `
//                             <!DOCTYPE html>
//                 <html lang="en">

//                     <head>
//                         <meta charset="UTF-8">
//                         <meta http-equiv="X-UA-Compatible" content="IE=edge">
//                         <meta name="viewport" content="width=device-width, initial-scale=1.0">
//                         <title>Email</title>
//                     <style>
//                         * {
//                             margin: 0;
//                             padding: 0;
//                             box-sizing: border-box;
//                         }

//                         body {
//                             background-color: #F5F5F5;
//                             width: 100vw;
//                             height: 100vh;
//                         }

//                         #container {
//                             text-align: center;
//                             height: 100%;
//                             width: 100%;
//                         }

//                         #main-content {
//                             margin-top: 20px;
//                             padding-top: 4%;
//                             padding-bottom: 7%;
//                             display: inline-block;
//                             background-color: #fff;
//                             height: 60%;
//                             width: 50%;
//                         }

//                         button {
//                             display: inline-block;
//                             background-color: #24B6F2;
//                             border-radius: 6px;
//                             height: 59px;
//                             width: 254px;
//                             font-family: 'Poppins', sans-serif;
//                             font-style: normal;
//                             font-weight: 500;
//                             font-size: 16px;
//                             line-height: 24px;
//                             color: #FFFFFF;
//                             border-color: #24B6F2;
//                         }

//                         #additional-content {
//                             margin-top: 40px;
//                             text-align: center;
//                             height: 30%;
//                             width: 100%;
//                             font-family: 'Poppins', sans-serif;
//                             font-style: normal;
//                             font-weight: 400;
//                             font-size: 14px;
//                             line-height: 21px;
//                             text-align: center;
//                             color: #465153;
//                         }

//                         #additional-content span {
//                             color: #24B6F2;
//                         }

//                         .welcome {
//                             font-family: 'Roboto', sans-serif;
//                             font-style: normal;
//                             font-weight: 500;
//                             font-size: 30px;
//                             line-height: 35px;
//                             text-align: center;
//                             color: #24B6F2;
//                         }

//                         .notice {
//                             display: inline-block;
//                             font-family: 'Roboto', sans-serif;
//                             font-style: normal;
//                             font-weight: 300;
//                             font-size: 18px;
//                             line-height: 27px;
//                             text-align: center;
//                             color: #333333;
//                             width: 45%;
//                             height: 13%;
//                         }

//                         .content-spacing {
//                             margin-top: 5px;
//                             margin-bottom: 5px;
//                         }

//                         .additional-info {
//                             display: inline-block;
//                             width: 50%;
//                         }

//                     </style>
//                     <link rel="preconnect" href="https://fonts.googleapis.com">
//                     <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
//                     <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500&family=Roboto:wght@300;500&display=swap" rel="stylesheet">
//                     </head>
//                     <body>
//                         <section id="container">
//                             <section id="main-content">
//                                 <img class="content-spacing" src="" alt="xtendly">
//                                 <h1 class="content-spacing welcome">Welcome to Title</h1>
//                                 <div>
//                                     <p class="content-spacing notice">Before proceeding, please register your account on this link.</p>
//                                 </div>
//                                 <a href=${link}><button style="margin-top: 20px;" >Verify your account</button></a>
//                             </section>
//                             <section id="additional-content">
//                                 <p class="content-spacing additional-info">This message was sent by <span>Company</span></p>
//                                 <p class="content-spacing additional-info">Address here</p>
//                                 <p class="content-spacing additional-info">© 2022 Company. All Rights Reserved.</p>
//                             </section>
//                         </section>
//                     </body>
//                 </html>
//                             `,
//     });
//     return info;
//   } catch (error) {
//     return false;
//   }
// };

// export const verifyMemberMail = async (emailTo: string, link: string) => {
//   try {
//     let info = await transporter.sendMail({
//       from: MAIL_SETTINGS.auth.user,
//       to: emailTo,
//       subject: "Title",
//       html: `<h1>Title test from dev</h1><br><a href="${link}">Click to verify your email</a>`,
//     });

//     return info;
//   } catch (error) {
//     return false;
//   }
// };