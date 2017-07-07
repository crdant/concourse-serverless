'use strict';

module.exports.sendMessage = (event, context, callback) => {

  var client = require('twilio')(
    process.env.TWILIO_ACCOUNT_SID,
    process.env.TWILIO_AUTH_TOKEN
  );

  client.messages.create({
    from: process.env.TWILIO_PHONE_NUMBER,
    to: process.env.CELL_PHONE_NUMBER,
    body: "You just sent an SMS from Node.js using Twilio and Lambda!"
  }, function(err, message) {
    if(err) {
      console.error(err.message);
    }
  });

  const response = {
    statusCode: 200,
    body: JSON.stringify({
      message: 'Go Serverless v1.0! Your function executed successfully!',
      input: event,
    }),
  };

  callback(null, response);

  // Use this code if you don't use the http event with the LAMBDA-PROXY integration
  // callback(null, { message: 'Go Serverless v1.0! Your function executed successfully!', event });
};
