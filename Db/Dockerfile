FROM mcr.microsoft.com/mssql/server:2019-CU14-ubuntu-20.04
ENV MSSQL_SA_PASSWORD="yourStrong(!)Password"
COPY init.sql /opt/mssql-scripts/
RUN ( /opt/mssql/bin/sqlservr --accept-eula & ) | grep -q "Service Broker manager has started" \
    && /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 'yourStrong(!)Password' -i "/opt/mssql-scripts/init.sql" \
    && pkill sqlservr
EXPOSE 1433

# docker build -t="school/projet_ti_bd:1" .
# docker run --name projetTiDbBeHealth -p 1433:1433 school/projet_ti_bd:1