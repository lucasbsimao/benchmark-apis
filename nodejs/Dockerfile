FROM alpine:3.18.3

RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
RUN echo '. "$HOME/.asdf/asdf.sh"' >> ~/.bashrc
RUN echo '. "$HOME/.asdf/completions/asdf.bash"' >> ~/.bashrc
RUN source ~/.bashrc

RUN asdf plugin add rust
RUN asdf install rust 1.71.1
RUN asdf global rust 1.71.1

WORKDIR /app

COPY . .

RUN npm i
RUN npm run build

CMD npm run start:prod