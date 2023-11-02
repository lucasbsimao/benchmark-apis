import { Module } from '@nestjs/common';
import { BenchmarkModule } from './domain/benchmark.module';
import { InfraestructureModule } from './infra/infra.module';

@Module({
  imports: [BenchmarkModule, InfraestructureModule]
})
export class AppModule {}
