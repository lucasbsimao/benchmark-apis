import { Module } from '@nestjs/common';
import { BenchmarkController } from './benchmark.controller';

@Module({
  controllers: [BenchmarkController],
})
export class BenchmarkModule {}
