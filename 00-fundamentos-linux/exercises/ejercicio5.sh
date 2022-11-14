#!/bin/bash

URL=$1
WORD=$2
TEMP_FILENAME="urlcontent.html"

if [[ $# -ne 2 ]]; then 
  echo "Se necesitan únicamente dos parámetros para ejecutar este script"
  exit 1
fi

# Nos traemos el fichero de la URL solicitada:
curl -so $TEMP_FILENAME $URL

# Buscamos la palabra en el fichero (y cuantas veces ocurre):
OCCURRENCES_OF_THE_WORD=`grep -no $WORD $TEMP_FILENAME | wc -l`

get_first_occurency(){
  echo `grep -no $WORD $TEMP_FILENAME | head -1 | cut -f1 -d:`
}

if [[ $OCCURRENCES_OF_THE_WORD -eq 0 ]]; then 
  echo "No se ha encontrado la palabra \"$WORD\""
elif [[ $OCCURRENCES_OF_THE_WORD -eq 1 ]]; then 
  echo "La palabra \"$WORD\" aparece 1 vez"
  FIRST_OCCURRENCY=`grep -no $WORD $TEMP_FILENAME | head -1 | cut -f1 -d:`
  echo "Aparece únicamente en la linea $FIRST_OCCURRENCY"
else
  echo "La palabra \"$WORD\" aparece $OCCURRENCES_OF_THE_WORD veces"
  FIRST_OCCURRENCY=`grep -no $WORD $TEMP_FILENAME | head -1 | cut -f1 -d:`
  echo "Aparece por primera vez en la linea $FIRST_OCCURRENCY"
fi

# Borramos el fichero temporal
rm $TEMP_FILENAME
