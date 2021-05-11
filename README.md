# Projeto Bônus - [Iugu for devs](https://github.com/iugu-for-devs)

Esse projeto é um complemento dos projetos [CodePlay](https://github.com/iugu-for-devs/codeplay) e [Iugu-Lite](https://github.com/iugu-for-devs/iugu-lite).

Juntos eles formam o projeto final proposto no treinamento da [Campus Code](https://campuscode.com.br/), onde a CodePlay seria uma plataforma de cursos online, e a Iugu-Lite de pagamentos, já esse projeto bônus o que efetivaria os pagamentos.

Levando em consideração que sua maquina já esteja previamente configurada para rodar uma aplicação ruby e com o redis funcionado.

## Para executar:

 - `bin/start` isso iniciará o Sidekiq

 - Abra uma nova aba do seu terminal dessa forma poderá digitar os comandos seguintes

 - `irb -r ./job/worker.rb` o irb será executado pronto para interagir com o Sidekiq

 - `OurWorker.perform_async("create")` cria os arquivos de faturas não pagas

 - `OurWorker.perform_async("pay")` atualiza os arquivos para pagos