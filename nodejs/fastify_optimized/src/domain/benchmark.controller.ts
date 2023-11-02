import { Controller, Get, Logger, Query } from '@nestjs/common';
import { promises as fsPromises } from 'fs';
import * as crypto from "crypto";

@Controller('benchmark')
export class BenchmarkController {
    private readonly logger = new Logger(BenchmarkController.name);

    @Get()
    async createUser(@Query('n') n: number) : Promise<string> {

        const file = "./txt";

        try {
            const contents = await fsPromises.readFile(file, 'utf-8');

            for(let i = 0; i < n; i++) {
                crypto.createHash('sha256').update(contents).digest();
            }
        
            return "OK";
        } catch (err) {
            console.log(err.stack);
            return 'Something went wrong';
        }
    }
}
