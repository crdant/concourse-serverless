var AWS = require('aws-sdk');

// you shouldn't hardcode your keys in production! See http://docs.aws.amazon.com/AWSJavaScriptSDK/guide/node-configuring.html
AWS.config.update({accessKeyId: process.env.AWS_ACCESS_KEY_ID, secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY, region: process.env.AWS_REGION});

console.log("credentials: " + process.env.AWS_ACCESS_KEY_ID + ":" + process.env.AWS_SECRET_ACCESS_KEY + ":" + process.env.AWS_REGION);

var lambda = new AWS.Lambda();
var params = {
  FunctionName: "concourse-serverless-" + process.env.stage + "-sendMessage" /* required */
};
lambda.invoke(params, function(err, data) {
  if (err) {
    console.log(err, err.stack);
    process.exit(-1);
  }  // an error occurred
  else     console.log(data);           // successful response
});
