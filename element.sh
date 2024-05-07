#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    FIND_ELEMENT=$($PSQL "SELECT * FROM elements WHERE atomic_number=$1")
  else
    if [[ $1 =~ ^[a-zA-Z]{1,2}$ ]]
    then
    FIND_ELEMENT=$($PSQL "SELECT * FROM elements WHERE symbol='$1'")
    else
      if [[ $1 =~ ^[a-zA-Z]+$ ]]
      then
        FIND_ELEMENT=$($PSQL "SELECT * FROM elements WHERE name='$1'")
      fi
    fi
  fi
  if [[ -z $FIND_ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    echo $FIND_ELEMENT | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME
    do
      FIND_PROPERTIES=$($PSQL "SELECT atomic_mass,melting_point_celsius,boiling_point_celsius,type FROM properties LEFT JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")
      echo $FIND_PROPERTIES | while IFS="|" read ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE
        do
          echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
        done    
    done
  fi
fi


