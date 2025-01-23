#!/usr/bin/env bash

rm -rf /var/tmp/frr/watchfrr*

# Lista de daemons do FRR
DAEMONS="bgpd ospfd ospf6d ripd ripngd isisd pimd pim6d ldpd nhrpd \
         eigrpd babeld sharpd pbrd bfdd fabricd vrrpd pathd"

for daemon in $DAEMONS; do
  # Para cada daemon, transformamos em maiúscula para bater com a variável de ambiente
  # Ex: "bgpd" -> "BGPD"
  VAR_NAME=$(echo "$daemon" | tr '[:lower:]' '[:upper:]')

  # Pega o valor da variável de ambiente, se definida
  # Ex: se BGPD="yes", val="yes"
  eval val=\$$VAR_NAME

  # Se não estiver definida ou vazia, deixa como "no"
  if [ -z "$val" ]; then
    val="no"
  fi

  # Ajusta a linha correspondente no /etc/frr/daemons
  sed -i "s/^$daemon=.*/$daemon=$val/" /etc/frr/daemons
done

# Você pode iniciar os serviços do FRR se quiser aqui (por exemplo, se não for
# usar systemd dentro do contêiner), ou simplesmente deixar o usuário decidir:
# service frr start   (depende do setup, mas normalmente dentro de container sem systemd
#                     é preciso outra abordagem para iniciar o FRR)

# Substitui o processo pelo comando original (CMD) passado no Dockerfile ou sobrescrito
service frr start

tail -f /dev/null

#exec "$@"
