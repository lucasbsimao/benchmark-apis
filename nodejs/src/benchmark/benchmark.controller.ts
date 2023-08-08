import { Body, Controller, Post } from '@nestjs/common';
import { CreateUserRequestDto } from './createUserRequest.dto';
import * as crypto from 'crypto';
import { CreateUserResponseDto } from './createUserResponse.dto';

@Controller('benchmark')
export class BenchmarkController {

    @Post()
    createUser(@Body() createUserDto: CreateUserRequestDto) : CreateUserResponseDto {
        const hashed = crypto.createHash("sha256").update(createUserDto.name).digest("base64");

        return new CreateUserResponseDto(hashed);
    }

}
