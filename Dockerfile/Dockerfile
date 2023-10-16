FROM r-base:4.2.1

RUN apt-get update

RUN R -e 'install.packages("jsonlite")'

COPY calculo_imposto_de_renda_codementor.R .

RUN ["chmod", "+x", "./calculo_imposto_de_renda_codementor.R"]    

