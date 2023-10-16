# carnê-leão

A ferramenta em linha de comando __carne-leao__ calcula o quanto se deve pagar de imposto no carnê-leão de um determinado mês para os ganhos obtidos como mentor na plataforma codementor.io.

## Como usar?

Primeiro você precisa obter o arquivo csv referente ao mês trabalhado no codementor no menu _Account and Settings_ > _Account and Payouts_ > _Payout Information_ > _Completed Payouts_ > selecionar _From_ mês de interesse e _to_ mês de interesse.

Após obter o arquivo csv, existem duas formas de rodar o script:

### 1. R >= 4.0.3 instalado

Se você já tem uma versão do R > 4.0.3 instalada na sua máquina, siga as instruções abaixo.

Instale o jsonlite, único pacote necessário. De dentro do R, execute:

```{Rscript}
install.packages("jsonlite")
```

Da linha de comando, torne o script executável com:

```{bash}
chmod +x calculo_imposto_de_renda_codementor.R
```

Os comandos acima só precisam ser executados uma vez.

Por fim, execute o script com o seu arquivo csv do codementor:

```{bash}
./calculo_imposto_de_renda_codementor.R seu_arquivo_codementor.csv
```

### 2. Uso com docker

Caso você não tenha R instalado na sua máquina e queira rodar mais rapidamente, pode criar a imagem docker para rodar o script. A criação da imagem só precisa ser feita uma vez.

Para isso é necessário ter o __docker__ instalado. Caso não tenha, pode clicar no link https://docs.docker.com/engine/install/ e selecionar o seu sistema operacional para seguir as instruções adequadas de instalação da ferramenta.

A partir do diretório __Dockerfile__, execute:

```{bash}
docker build -t carne-leao .
```

Após criar sua imagem de nome _carne-leao_, entre no diretório que contém seu arquivo csv com os ganhos do codementor, e execute-a da seguinte maneira:

```{bash}
docker run -itv $(pwd):/work/ --rm carne-leao bash

# Dentro do contêiner docker:
cd /work/

./calculo_imposto_de_renda_codementor.R seu_arquivo_codementor.csv
```
Obs.: Para sair do contêiner docker, basta pressionar ctrl+D (ou command+D para Mac).

### Retorno esperado

O modelo de retorno obtido é:

> Seu ganho sem impostos foi de R$ 5040,48.

> Você deve pagar R$ 517,00 de imposto para o mês 10.

> Seu ganho real é de R$ 4523,48.

Você pode testar o script com o arquivo aqui disponibilizado como _Mock_Arc_Codementor_Payout_Histories_2022-10_2022-10.csv_.

