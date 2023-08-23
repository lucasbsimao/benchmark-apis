import { Module } from '@nestjs/common';
import { BenchmarkModule } from './domain/benchmark.module';

@Module({
  imports: [BenchmarkModule]
})
export class AppModule {}
