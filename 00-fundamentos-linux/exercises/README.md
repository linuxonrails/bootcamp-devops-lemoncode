# Ejercicios

## Ejercicios CLI

### 1. Crea mediante comandos de bash la siguiente jerarquía de ficheros y directorios

```bash
foo/
├─ dummy/
│  ├─ file1.txt
│  ├─ file2.txt
├─ empty/
```

Donde `file1.txt` debe contener el siguiente texto:

```bash
Me encanta la bash!!
```

Y `file2.txt` debe permanecer vacío.

#### Solución

```bash
mkdir -p foo/dummy
echo 'Me encanta la bash!!' > foo/dummy/file1.txt
touch foo/dummy/file2.txt
mkdir -p foo/empty
```  

Podemos comprobarlo ejecutando la siguiente linea:

```bash
tree foo ; echo ; echo "Contenido de foo/dummy/file1.txt:" ; cat foo/dummy/file1.txt ; echo "Contenido de foo/dummy/file2.txt:" ; cat foo/dummy/file2.txt
```

...que nos debería devolver el siguiente resultado:

```
foo
├── dummy
│   ├── file1.txt
│   └── file2.txt
└── empty

2 directories, 2 files

Contenido de foo/dummy/file1.txt:
Me encanta la bash!!
Contenido de foo/dummy/file2.txt:
```

### 2. Mediante comandos de bash, vuelca el contenido de file1.txt a file2.txt y mueve file2.txt a la carpeta empty

El resultado de los comandos ejecutados sobre la jerarquía anterior deben dar el siguiente resultado.

```bash
foo/
├─ dummy/
│  ├─ file1.txt
├─ empty/
  ├─ file2.txt
```

Donde `file1.txt` y `file2.txt` deben contener el siguiente texto:

```bash
Me encanta la bash!!
```

#### Solución

```bash
cat foo/dummy/file1.txt > foo/dummy/file2.txt
mv foo/dummy/file2.txt foo/empty/
```

Podemos comprobarlo ejecutando la siguiente linea:

```bash
tree foo ; echo "Contenido de file1.txt:" ; echo ; find -name file1.txt -exec cat {} \; ; echo "Contenido de file2.txt:" ; find -name file2.txt -exec cat {} \;
```

...que nos debería devolver el siguiente resultado:

```bash
foo
├── dummy
│   └── file1.txt
└── empty
    └── file2.txt

2 directories, 2 files
Contenido de file1.txt:
Me encanta la bash!!
Contenido de file2.txt:
Me encanta la bash!!
```

### 3. Crear un script de bash que agrupe los pasos de los ejercicios anteriores y además permita establecer el texto de file1.txt alimentándose como parámetro al invocarlo

Si se le pasa un texto vacío al invocar el script, el texto de los ficheros, el texto por defecto será:

```bash
Que me gusta la bash!!!!
```

#### Solución 

Creamos el fichero ejercicio3.sh con el siguiente contenido:

```bash
#!/bin/bash

TEXT_FOR_EMPTY_VALUE='Que me gusta la bash!!!!'
read -p "Texto: " TEXT

if [[ -z "$TEXT" ]]; then
  TEXT=$TEXT_FOR_EMPTY_VALUE
fi

# Paso 1
mkdir -p foo/dummy
echo $TEXT > foo/dummy/file1.txt
touch foo/dummy/file2.txt
mkdir -p foo/empty

# Paso 2
cat foo/dummy/file1.txt > foo/dummy/file2.txt
mv foo/dummy/file2.txt foo/empty/
```

Podemos comprobarlo el primer caso (cualquier texto excepto un texto vacío) ejecutando la siguiente linea:

```bash
sh ./ejercicio3.sh
```

...cumplimentando con el texto `Lore ipsum dolor est`. 

Y comprobar el resultado con la siguiente linea:

```bash
tree foo ; echo ; echo "Contenido de file1.txt:" ; find -name file1.txt -exec cat {} \; ; echo "Contenido de file2.txt:" ; find -name file2.txt -exec cat {} \;
```

...que nos debería devolver el siguiente resultado:

```bash
foo
├── dummy
│   └── file1.txt
└── empty
    └── file2.txt

2 directories, 2 files

Contenido de file1.txt:
Lore ipsum dolor est
Contenido de file2.txt:
Lore ipsum dolor est
```

Podemos comprobarlo el segundo caso (texto vacío con o sin espacios) ejecutando la siguiente linea:

```bash
sh ./ejercicio3.sh
```

...cumplimentando con el texto `  ` (cero o más espacios). 

Y comprobar el resultado con la siguiente linea:

```bash
tree foo ; echo ; echo "Contenido de file1.txt:" ; find -name file1.txt -exec cat {} \; ; echo "Contenido de file2.txt:" ; find -name file2.txt -exec cat {} \;
```

...que nos debería devolver el siguiente resultado:

```bash
foo
├── dummy
│   └── file1.txt
└── empty
    └── file2.txt

2 directories, 2 files

Contenido de file1.txt:
Que me gusta la bash!!!!
Contenido de file2.txt:
Que me gusta la bash!!!!
```

### 4. Crea un script de bash que descargue el contenido de una página web a un fichero y busque en dicho fichero una palabra dada como parámetro al invocar el script

La URL de dicha página web será una constante en el script.

Si tras buscar la palabra no aparece en el fichero, se mostrará el siguiente mensaje:

```bash
$ ejercicio4.sh patata
> No se ha encontrado la palabra "patata"
```

Si por el contrario la palabra aparece en la búsqueda, se mostrará el siguiente mensaje:

```bash
$ ejercicio4.sh patata
> La palabra "patata" aparece 3 veces
> Aparece por primera vez en la línea 27
```

#### Solución

Creamos el fichero ejercicio4.sh con el siguiente contenido:

```bash
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
```

Podemos comprobarlo ejecutando la siguiente linea:

```bash
./ejercicio4.sh Linux
```

..que nos debería devolver el siguiente resultado:

```bash
La palabra "Linux" aparece 13 veces
Aparece por primera vez en la linea 1
```

Si probamos con `Agenda`:

```bash
./ejercicio4.sh Agenda
```

```bash
La palabra "Agenda" aparece 1 veces
Aparece por primera vez en la linea 3
```

Si probamos con `Microsoft`:

```bash
./ejercicio4.sh Microsoft
```

```bash
No se ha encontrado la palabra "Microsoft"
```

### 5. OPCIONAL - Modifica el ejercicio anterior de forma que la URL de la página web se pase por parámetro y también verifique que la llamada al script sea correcta

Si al invocar el script este no recibe dos parámetros (URL y palabra a buscar), se deberá de mostrar el siguiente mensaje:

```bash
$ ejercicio5.sh https://lemoncode.net/ patata 27
> Se necesitan únicamente dos parámetros para ejecutar este script
```

Además, si la palabra sólo se encuentra una vez en el fichero, se mostrará el siguiente mensaje:

```bash
$ ejercicio5.sh https://lemoncode.net/ patata
> La palabra "patata" aparece 1 vez
> Aparece únicamente en la línea 27
```

#### Solución

Creamos el fichero ejercicio4.sh con el siguiente contenido:

```bash
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
```

Podemos comprobarlo ejecutando la siguiente linea:

```bash
./ejercicio5.sh https://raw.githubusercontent.com/Lemoncode/bootcamp-devops-lemoncode/master/00-fundamentos-linux/README.md Linux
```

..que nos debería devolver el siguiente resultado:

```bash
La palabra "Linux" aparece 13 veces
Aparece por primera vez en la linea 1
```

Si probamos con `Agenda`:

```bash
./ejercicio5.sh https://raw.githubusercontent.com/Lemoncode/bootcamp-devops-lemoncode/master/00-fundamentos-linux/README.md Agenda
```

```bash
La palabra "Agenda" aparece 1 vez
Aparece únicamente en la linea 3
```

Si probamos con `Microsoft`:

```bash
./ejercicio5.sh https://raw.githubusercontent.com/Lemoncode/bootcamp-devops-lemoncode/master/00-fundamentos-linux/README.md Microsoft
```

```bash
No se ha encontrado la palabra "Microsoft"
```

