"use strict";

exports.handler = async (event, context) => {
    await new Promise(resolve => setTimeout(resolve, 1000)); // Simulate slow function
    return {
        statusCode: 200,
        body: JSON.stringify({
            message: "Hello World!",
            streamName: context.logStreamName,
            now: (new Date()).toISOString()
        })
    };
};