export class CreateUserResponseDto {
    constructor(hash: string){
        this.hash = hash;
    }

    hash : string;
}