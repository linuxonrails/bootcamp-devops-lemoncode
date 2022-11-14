#!/bin/bash

URL=https://raw.githubusercontent.com/Lemoncode/bootcamp-devops-lemoncode/master/00-fundamentos-linux/README.md
TEMP_FILENAME="urlcontent.html"

# Nos traemos el fichero de la URL solicitada:
curl -so $TEMP_FILENAME $URL

WORD=$1
# Buscamos la palabra en el fichero (y cuantas veces ocurre):
OCCURRENCES_OF_THE_WORD=`grep -no $WORD $TEMP_FILENAME | wc -l`

if [[ $OCCURRENCES_OF_THE_WORD -eq 0 ]]; then 
  echo "No se ha encontrado la palabra \"$WORD\""
else 
  echo "La palabra \"$WORD\" aparece $OCCURRENCES_OF_THE_WORD veces"
  FIRST_OCCURRENCY=`grep -no $WORD $TEMP_FILENAME | head -1 | cut -f1 -d:`
  echo "Aparece por primera vez en la linea $FIRST_OCCURRENCY"
fi

# Borramos el fichero temporal
rm $TEMP_FILENAME
