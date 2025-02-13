#!/bin/bash

## ANSI escape codes

RED='\033[0;31m'

GREEN='\033[0;32m'

YELLOW='\033[0;33m'

BLUE='\033[0;34m'

NC='\033[0m' # No Color




## check internet

check_network(){
        ping -c1 -w3 google.com &> /dev/null
        if [ $? -ne 0 ]; then
                echo -e "${RED}You should have an active internet connection.${NC}"

        exit 1
        fi
}


## check jq

check_jq(){
        if ! command -v jq &> /dev/null; then
                echo -e "${RED}jq not installed. Please install jq to run this script.${NC}"
        exit 1
        fi
}


## check curl

check_curl(){
        if ! command -v curl &> /dev/null; then
                echo -e "${RED}curl needs to installed.${NC}"
        exit 1
        fi
}




## usage error

if_error(){

        echo -e "${YELLOW}Usage: $0 <coin_name>${NC}"
        echo -e "${YELLOW}Example: $0 bitcoin${NC}"
        exit 1

}

check_network
check_jq
check_curl

coin=$1

if [ -z $coin ]; then
        echo "Coin name not provided"
        if_error


fi

## Display loading message

echo "Fetching price details for $coin.... "


## Fetching Price

PRICE_DATA=$(curl -s "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=${coin}")

## Check if data is retrieved

if [ -z "$PRICE_DATA" ]; then
    echo -e "${RED}No data retrieved. Please check the coin name and try again.${NC}"
    exit 1
fi

## Fetching time

btc_price=$(echo $PRICE_DATA | jq -r '.[0].current_price')

market_cap=$(echo "$PRICE_DATA" | jq -r '.[0].market_cap')

volume=$(echo "$PRICE_DATA" | jq -r '.[0].total_volume')

price_change=$(echo "$PRICE_DATA" | jq -r '.[0].price_change_percentage_24h')

high_24h=$(echo "$PRICE_DATA" | jq -r '.[0].high_24h')

low_24h=$(echo "$PRICE_DATA" | jq -r '.[0].low_24h')

ath=$(echo "$PRICE_DATA" | jq -r '.[0].ath')

atl=$(echo "$PRICE_DATA" | jq -r '.[0].atl')

# Display the price details


echo -e "${BLUE}========================================"

echo -e "            PRICE REPORT"

echo -e "========================================${NC}"

echo -e "${GREEN}Current price of $coin: $btc_price USD${NC}"

echo -e "${GREEN}Market Cap: $market_cap USD${NC}"

echo -e "${GREEN}24h Trading Volume: $volume USD${NC}"

echo -e "${GREEN}Price Change (24h): $price_change%${NC}"

echo -e "${GREEN}24h High: $high_24h USD${NC}"

echo -e "${GREEN}24h Low: $low_24h USD${NC}"

echo -e "${GREEN}All-Time High (ATH): $ath USD${NC}"

echo -e "${GREEN}All-Time Low (ATL): $atl USD${NC}"

echo -e "${BLUE}========================================${NC}"




# Suggest viewing the full report
echo -e "${YELLOW}For more details, visit: https://www.coingecko.com/en/coins/${coin}.${NC}"
