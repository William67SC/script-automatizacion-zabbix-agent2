#! /bin/bash
# author william soliz castillo 02/11/2024

LOG_FILE="$HOME/log_file.txt"

#read -p "COLOQUE LA IP DEL ZABBIX_SERVER:", ZABBIX_SERVER_IP
#echo "la ip del server zabbix es", $ZABBIX_SERVER_IP

opcion=0

install_zabbix_agent2 () {
  echo "Instalando Zabbix Agent..."

  read -p "COLOQUE LA IP DEL ZABBIX_SERVER:", ZABBIX_SERVER_IP
  echo "la ip del server zabbix es", $ZABBIX_SERVER_IP

  # Validación de la IP
    if ! [[ $ZABBIX_SERVER_IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "La IP ingresada no es válida. Debe ser una dirección IPv4."
        return 1
    fi

  read -p "¿Desea usar el hostname actual ('$(hostname)')? [s/N]: " respuesta
    if [[ "$respuesta" =~ ^(s|S|si|SI)$ ]]; then
        HOSTNAME=$(hostname)
  else
    read -p "Ingrese el hostname que desea usar: " HOSTNAME
  fi

  echo "Usando hostname: $HOSTNAME para la configuración de Zabbix."



  # Descargar y agregar el repositorio de Zabbix
  wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest+ubuntu22.04_all.deb
  dpkg -i zabbix-release_latest+ubuntu22.04_all.deb
  apt update

  # Instalar Zabbix Agent
  apt install zabbix-agent2 zabbix-agent2-plugin-* -y

  # Configurar Zabbix Agent
  sed -i "s/^Server=.*/Server=$ZABBIX_SERVER_IP/" /etc/zabbix/zabbix_agent2.conf
  sed -i "s/^Hostname=.*/Hostname=$HOSTNAME/" /etc/zabbix/zabbix_agent2.conf

  # Iniciar y habilitar Zabbix Agent
  systemctl restart zabbix-agent2
  systemctl enable zabbix-agent2
  echo "Zabbix Agent instalado y configurado correctamente."
}

remove_zabbix_agent2() {
        echo "Desinstalando zabbix_agent2...."
        systemctl stop zabbix-agent2
        apt remove zabbix-agent2 -y
        apt purge zabbix-agent2 -y
}


while :

do
        # LIMPIAR LA PANTALL
        clear
        # DESPLEGAR MENU DE OPCIONES
        echo "-----------------------------------------------------"
        echo "PROGRAMA DE UTILIDADES AGENTE PROXY"
        echo "-----------------------------------------------------"
        echo "           MENU PRINCIPAL                            "
        echo "-----------------------------------------------------"
        echo "1. INSTALAR ZABBIX AGENT2"
        echo "2. DESINTALAR ZABBIX AGENT2"
        echo "3. SALIR "
        echo "-----------------------------------------------------"

        # LEER LOS DATOS DEL USUARIO PARA CAPTURAR INFORMACION
        read -n1 -p "ingrese una opcion [1-4]" opcion
        # VALIDAR LA OPCION INGRESADA
        case $opcion in
                1)
                        install_zabbix_agent2
                        sleep 3
                        ;;
                2)
                        remove_zabbix_agent2
                        sleep 3
                        ;;
                3)
                        echo "SALIR DEL PROGRAMA "
                        exit 0
                        ;;
                esac
                read -p "presiona enter para continuar"

        done

# fin del script
# mi primer cambio porque puedo

