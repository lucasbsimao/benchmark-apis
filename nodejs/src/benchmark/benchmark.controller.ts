import { Body, Controller, Get, Logger } from '@nestjs/common';

@Controller('benchmark')
export class BenchmarkController {
    private readonly logger = new Logger(BenchmarkController.name);

    @Get()
    async createUser() : Promise<String> {

        await this.sleep(30000);

        return "blz";
    }
    sleep = (ms: number) => new Promise((r) => setTimeout(r, ms));

}
