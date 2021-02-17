FROM radstudio/pa-radserver:10.3.3

ARG password=embtdocker
ARG ModuleName=MeuProjeto
ARG ModuleFile=bplProject1.so
#ARG dbhost=192.168.145.132
ARG dbhost=localhost
ARG dbport=3050
ENV PA_SERVER_PASSWORD=$password
ENV DB_HOST=$dbhost
ENV DB_PORT=$dbport

COPY $ModuleFile /etc/ems/$ModuleFile

#copiando as dependencias do firedac oracle para a imagem
COPY bplFireDACOracleDriver270.so /usr/lib/ems/bplFireDACOracleDriver270.so

RUN echo "#!/bin/bash" > ./emsscript.sh

#populate emsserver.ini with module data


ARG FindValue=:a;N;\$!ba;s#\\\[Server\\\.Packages\\\]
ARG ReplaceValue=#\\\[Server\\\.Packages\\\]
ARG ForwardSlash=/
ARG PoundG=#g
ARG EmsIni=/etc/ems/emsserver.ini
RUN echo -n "sed -i '" >> ./emsscript.sh
RUN echo -n "$FindValue" >> ./emsscript.sh
RUN echo -n "\\" >> ./emsscript.sh
RUN echo -n "n" >> ./emsscript.sh
RUN echo -n "$ReplaceValue" >> ./emsscript.sh
RUN echo -n "\\" >> ./emsscript.sh
RUN echo -n "n" >> ./emsscript.sh
RUN echo -n "/etc/ems/$ModuleFile=$ModuleName" >> ./emsscript.sh
RUN echo -n "$PoundG' " >> ./emsscript.sh
RUN echo -n "$EmsIni" >> ./emsscript.sh
RUN echo  "" >> ./emsscript.sh

RUN sed -i 's|/etc/ems/emsserver.ib|/lib/ems/emsserver.ib|g' /etc/ems/emsserver.ini

RUN sh ./emsscript.sh


