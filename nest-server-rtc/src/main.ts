import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import * as dotenv from 'dotenv';

dotenv.config();
async function bootstrap() {
  const app = await NestFactory.create(AppModule, {
    snapshot: true,
  });
  console.log("kkk");
  app.enableCors({
    origin: '*',
    methods: '*',
  });
  console.log('kaka');

  await app.listen(8001);
}
bootstrap();
