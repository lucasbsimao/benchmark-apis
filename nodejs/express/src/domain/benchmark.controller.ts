import { Controller, Get, Query, Res } from '@nestjs/common';
import { Response } from 'express'
@Controller('benchmark')
export class BenchmarkController {
    compute(n: number): number {
        let result = 0;
        const temp = new Array(n);

        for (let i = 0; i < n; i++) {
          temp[i] = Math.sqrt(i * i + i);
          result += temp[i];
        }

        return result;
    }

    @Get()
    async createUser(@Query('n') n: number, @Res({ passthrough: true }) res: Response) : Promise<string> {
        const result = this.compute(n);

        res.header('X-Benchmark-Result', result.toString());
    
        return "OK";
    }
}
