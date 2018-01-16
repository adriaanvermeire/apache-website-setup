#!/bin/bash
NAME=$1
TYPE=$2


if [ "$NAME" == "" ]; then
  echo "Please state an address for your website..."
  exit 1
fi
if [ "$TYPE" == "" ]; then
  echo "Please state a type of webserver..."
  echo "Possible types: "
  echo "  - Laravel:  -l"
  echo "  - HTML:     -h"
elif [ "$TYPE" == "-l" ]; then
  ROOT="${NAME}/public"
elif [ "$TYPE" == "-h" ]; then
  ROOT="${NAME}"
elif [[ "$TYPE" == "-r" ]]; then
  echo "Are you sure you want to remove ${NAME}?"
  read ANSWER
  if [[ "$ANSWER" == "y" ]] || [[ "$ANSWER" == 'yes' ]]; then
    # Begin removal
      cd /etc/apache2/sites-available
      sudo rm /etc/apache2/sites-available/${NAME}.conf
      sudo rm /etc/apache2/sites-enabled/${NAME}.conf
      exit 1
  else
    echo "Removal of ${NAME} canceled."
    exit 1
  fi

fi

if [[ "$ROOT" != "" ]]; then
  cd /etc/apache2/sites-available
  sudo cp webboiler.conf ${NAME}.conf
  cd /etc/apache2/sites-enabled
  sudo ln -s /etc/apache2/sites-available/${NAME}.conf ${NAME}.conf
  cd /etc/apache2/sites-available
  sudo sed -i -e s/sName/${NAME}/g ${NAME}.conf
  sudo sed -i -e s@sRoot@${ROOT}@g ${NAME}.conf #Choosing @ as delimiter, / was conflicting with slash in filename
  cd /var/www
  if [[ "$TYPE" == "-l" ]]; then
    laravel new ${NAME}
  else
    sudo mkdir /var/www/${NAME}
  fi
fi
