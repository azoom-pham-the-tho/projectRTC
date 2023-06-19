import { INestApplication } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { ExpressAdapter } from '@nestjs/platform-express';
import { APIGatewayProxyHandler } from 'aws-lambda';
import { createServer, proxy } from 'aws-serverless-express';
import express from 'express';
import { Server } from 'http';

import { AppModule } from './src/app.module';

let cachedServer: Server;
const bootstrapServer = async (): Promise<{
  server: Server;
  app: INestApplication;
}> => {
  const expressApp = express();
  const adapter = new ExpressAdapter(expressApp);
  const app = await NestFactory.create(AppModule, adapter);
  // app.setGlobalPrefix('api');
  // app.use('/api/webhook/stripe/*', raw({ type: 'application/json' }));
  // app.enableCors({
  //   methods: '*',
  //   allowedHeaders: '*',
  //   origin: '*',
  // });
  await app.init();
  return { server: createServer(expressApp, undefined, ['images/png']), app };
};

async function handleQueue() {
  // const app = await NestFactory.create(SQSModule);
  // const service = app.get(SQSPool);
  // await service.handleQueue(false);
}

export const handler: APIGatewayProxyHandler = async (event, context) => {
  console.log('Nhảy vào check Event!!!!!');
  console.log(event);

  if ('Records' in event) {
    await handleQueue();
  } else if (!cachedServer) {
    const { server } = await bootstrapServer();
    cachedServer = server;
  }
  return proxy(cachedServer, event, context, 'PROMISE').promise;
};
