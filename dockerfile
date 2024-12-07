FROM public.ecr.aws/lambda/nodejs:20.2024.11.06.17

# see https://docs.aws.amazon.com/lambda/latest/dg/nodejs-image.html#nodejs-image-instructions
COPY handler.js ${LAMBDA_TASK_ROOT}

CMD [ "handler.handler" ]