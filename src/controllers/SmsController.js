const Logger = require('../utils/logs/Logger'); // Import the Logger utility for logging
const MySQL = require('../utils/db/Mysql'); // Import the MySQL
const tables = require('../config/tables');

/**
 * @class SmsController
 * @description Controller class for handling data-related operations such as fetching visits, bot visits, visitor OS, and bank balance.
 *              This class contains static methods that interact with the database and handle HTTP requests and responses.
 * @version 1.0.0
 * @date 2024-07-30
 * @author Jay Chauhan
 */
class SmsController {
    static async getSms(req, res) {
        const db = new MySQL(); // Create a new instance of the MySQL utility

        try {
            await db.connect(); // Connect to the database

            const smsData = await db.table(tables.TBL_SMS).select("*").get();

            var userMessage = {};
            smsData.forEach((sms) => {
                let userId = sms.smsType == 0 ? sms.smsFrom : sms.smsTo;
                const date = new Date(sms.smsTime);
                const options = {
                    hour: 'numeric',
                    minute: 'numeric',
                    hour12: true
                };
                const time = new Intl.DateTimeFormat('en-US', options).format(date);

                if (!userMessage[userId]) {
                    userMessage[userId] = {
                        userId: userId,
                        name: userId,
                        path: "/assets/images/auth/user.png",
                        time: time,
                        messages: [],
                        active: true
                    };
                }

                const message = {
                    fromUserId: sms.smsTo,
                    toUserId: sms.smsFrom,
                    text: sms.smsBody,
                    time: time,
                };
                if (!userMessage[userId].messages[time]) {
                    userMessage[userId] = {
                        [time]: []
                    }
                }
                userMessage[userId].messages[time].push(message);
            });

            res.status(200).json(userMessage); // Send the sms data as a JSON response
        } catch (error) {
            const logger = new Logger(); // Create a new instance of the Logger utility
            logger.write("Error in getting sms: " + error, "sms/error"); // Log the error
            res.status(500).json({ message: 'Oops! Something went wrong!' }); // Send an error response
        } finally {
            await db.disconnect(); // Disconnect from the database
        }
    }
}

module.exports = SmsController; // Export the SmsController class