import { Body, Controller, Logger, Post } from '@nestjs/common';
import { CreateUserRequestDto } from './createUserRequest.dto';
import * as crypto from 'crypto';
import { CreateUserResponseDto } from './createUserResponse.dto';

@Controller('benchmark')
export class BenchmarkController {
    private readonly logger = new Logger(BenchmarkController.name);

    @Post()
    async createUser(@Body() createUserDto: CreateUserRequestDto) : Promise<CreateUserResponseDto> {

        

        return await this.test(createUserDto);
    }

    async test(createUserDto: CreateUserRequestDto) : Promise<CreateUserResponseDto> {
        let hashed = crypto.createHash("sha256").update(createUserDto.name).digest("base64");
        for (let i = 0; i < 100000; i++){

            hashed = crypto.createHash("sha256").update(hashed).digest("base64");
        }

        return new CreateUserResponseDto(hashed);
    }

}
