#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -X -t --no-align -c"

echo -e "\n~~~~~ SALON APPOINTMENTS ~~~~~\n"
while true
do
  echo "Welcome! Which service would you like?"
  while IFS='|' read -r SERVICE_ID SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done < <($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  read SERVICE_ID_SELECTED || exit 0
  if [[ $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]; then
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    [[ -n $SERVICE_NAME ]] && break
  fi
  echo -e "\nPlease select one of the listed services."
done

echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE || exit 0
PHONE_SQL=${CUSTOMER_PHONE//\'/\'\'}
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$PHONE_SQL'")
if [[ -z $CUSTOMER_ID ]]; then
  echo -e "\nWhat's your name?"
  read CUSTOMER_NAME || exit 0
  NAME_SQL=${CUSTOMER_NAME//\'/\'\'}
  CUSTOMER_ID=$($PSQL "INSERT INTO customers(phone, name) VALUES ('$PHONE_SQL', '$NAME_SQL') RETURNING customer_id" | head -n 1)
else
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id = $CUSTOMER_ID")
fi
echo -e "\nWhat time would you like your $SERVICE_NAME?"
read SERVICE_TIME || exit 0
TIME_SQL=${SERVICE_TIME//\'/\'\'}
if $PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$TIME_SQL')" >/dev/null; then
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
fi
