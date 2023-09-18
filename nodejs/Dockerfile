FROM alpine:3.18.3

RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
RUN echo '. "$HOME/.asdf/asdf.sh"' >> ~/.bashrc
RUN echo '. "$HOME/.asdf/completions/asdf.bash"' >> ~/.bashrc
RUN source ~/.bashrc

RUN asdf plugin add node
RUN asdf install node 18.17.0
RUN asdf global node 18.17.0

WORKDIR /app

COPY . .

RUN npm i
RUN npm run build

CMD npm run start:prod