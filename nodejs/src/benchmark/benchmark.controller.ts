import { Body, Controller, Post } from '@nestjs/common';
import { CreateUserDTO } from './createUser.dto';

@Controller('benchmark')
export class BenchmarkController {

    @Post()
    createUser(@Body() createUserDto: CreateUserDTO) {

    }

}
