var AWS = require('aws-sdk');
var proxy = require('proxy-agent');

// you shouldn't hardcode your keys in production! See http://docs.aws.amazon.com/AWSJavaScriptSDK/guide/node-configuring.html
AWS.config.update({accessKeyId: process.env.AWS_ACCESS_KEY_ID, secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY, region: process.env.AWS_REGION});

if ( process.env.http_proxy ) {
  AWS.config.update({
    httpOptions: {
      agent: proxy(process.env.http_proxy);
    }
  });
}

var lambda = new AWS.Lambda();
var params = {
  FunctionName: process.env.service + "-" + process.env.stage + "-sendMessage" /* required */
};
lambda.invoke(params, function(err, data) {
  if (err) {
    console.log(err, err.stack);
    process.exit(-1);
  }  // an error occurred
  else     console.log(data);           // successful response
});
