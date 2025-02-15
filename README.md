
# Crypto Fetcher Bash

**Crypto Fetcher Bash** is a simple and lightweight Bash script that fetches real-time cryptocurrency data using the [CoinGecko API](https://www.coingecko.com/en/api). This script is designed to provide essential information about any cryptocurrency (e.g., Bitcoin, Ethereum) including the current price, market capitalization, 24-hour trading volume, price change, and more—directly from your terminal.

This script is ideal for anyone who wants to get cryptocurrency prices quickly without needing a browser or any complex software setup. It is lightweight, open-source, and easy to use.

---

## Table of Contents

1. [Features](#features)
2. [Prerequisites](#prerequisites)
3. [Installation](#installation)
4. [Usage](#usage)
    - [Command-Line Arguments](#command-line-arguments)
    - [Example Usage](#example-usage)
5. [Script Breakdown](#script-breakdown)
    - [Network Check](#network-check)
    - [Dependency Checks](#dependency-checks)
    - [Fetching Data](#fetching-data)
    - [Parsing Data](#parsing-data)
    - [Displaying Results](#displaying-results)
6. [Error Handling](#error-handling)
7. [License](#license)
8. [Acknowledgments](#acknowledgments)

---

## Features

- **Real-time Cryptocurrency Prices**: Fetches the most up-to-date price for any supported cryptocurrency.
- **Market Data**: Displays the market cap, 24-hour trading volume, price change percentage, 24-hour high/low, and more.
- **All-Time High (ATH) and All-Time Low (ATL)**: Provides historical high and low values for the cryptocurrency.
- **Easy-to-Read Output**: Uses color-coded formatting to make the terminal output easy to read and visually distinct.
- **Lightweight**: No external dependencies aside from `curl` and `jq`, both of which are widely used and easy to install.
- **Command-Line Tool**: Allows easy integration into automated systems, dashboards, or your own crypto tracking scripts.

---

## Prerequisites

Before you begin using this script, make sure that the following tools are installed on your system:

### Required Software:

1. **curl**: A command-line tool for transferring data with URLs.
   - To install `curl`, use:
     ```bash
     sudo apt-get install curl
     ```

2. **jq**: A lightweight and flexible command-line JSON processor.
   - To install `jq`, use:
     ```bash
     sudo apt-get install jq
     ```

3. **Internet Connection**: The script requires an active internet connection to interact with the CoinGecko API.

---

## Installation

To get started with **Crypto Fetcher Bash**, follow these steps:

1. **Clone the repository** to your local machine:
   ```bash
   git clone https://github.com/yourusername/Crypto_Fetcher_Bash.git
   ```

2. **Navigate to the project directory**:
   ```bash
   cd Crypto_Fetcher_Bash
   ```

3. **Make the script executable**:
   ```bash
   chmod +x crypto.sh
   ```

---

## Usage

To use the script, you need to provide the cryptocurrency name as an argument. The name should be in lowercase, such as `bitcoin`, `ethereum`, or `litecoin`.

### Command-Line Arguments

The script accepts the following command-line argument:

- `<coin_name>`: The name of the cryptocurrency for which you want to fetch data (e.g., `bitcoin`, `ethereum`).

**Usage**:
```bash
./crypto.sh <coin_name>
```

### Example Usage

To fetch real-time data for **Bitcoin**:

```bash
./crypto.sh bitcoin
```

Sample output:

```
Fetching price details for bitcoin.... 
========================================
            PRICE REPORT
========================================
Current price of bitcoin: 47900.12 USD
Market Cap: 890,000,000,000 USD
24h Trading Volume: 34,000,000,000 USD
Price Change (24h): 2.5%
24h High: 48500.00 USD
24h Low: 47000.00 USD
All-Time High (ATH): 69000.00 USD
All-Time Low (ATL): 65.00 USD
========================================
For more details, visit: https://www.coingecko.com/en/coins/bitcoin.
```

The script fetches the current price, market cap, trading volume, 24-hour high and low, and ATH/ATL, and formats the output in a clear and organized manner.

---

## Script Breakdown

### 1. **Network Check (`check_network`)**
The script first checks whether the system has an active internet connection by attempting to ping `google.com`. This ensures that the script can reach the CoinGecko API to fetch cryptocurrency data.

```bash
ping -c1 -w3 google.com &> /dev/null
```

If the system does not have internet access, the script will print an error message and exit.

### 2. **Dependency Checks (`check_jq` and `check_curl`)**
The script checks if `curl` and `jq` are installed on the system. Both tools are essential for fetching and processing JSON data from the API.

- `jq`: Used for parsing the JSON data returned by the CoinGecko API.
- `curl`: Used for making the HTTP requests to the API.

```bash
command -v jq &> /dev/null
command -v curl &> /dev/null
```

If either tool is missing, the script will print an error message and exit.

### 3. **Fetching Data**
Once the network and dependencies are confirmed, the script fetches the data for the specified cryptocurrency using the CoinGecko API.

```bash
PRICE_DATA=$(curl -s "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=${coin}")
```

Here, `coin` is the user-provided argument (e.g., `bitcoin`). The data is fetched in JSON format.

### 4. **Parsing Data (`jq`)**
The script uses `jq` to parse the JSON response and extract the relevant values. The following values are parsed:

- Current Price
- Market Cap
- 24h Trading Volume
- 24h Price Change Percentage
- 24h High and Low Prices
- All-Time High (ATH) and All-Time Low (ATL)

```bash
btc_price=$(echo $PRICE_DATA | jq -r '.[0].current_price')
market_cap=$(echo "$PRICE_DATA" | jq -r '.[0].market_cap')
volume=$(echo "$PRICE_DATA" | jq -r '.[0].total_volume')
price_change=$(echo "$PRICE_DATA" | jq -r '.[0].price_change_percentage_24h')
high_24h=$(echo "$PRICE_DATA" | jq -r '.[0].high_24h')
low_24h=$(echo "$PRICE_DATA" | jq -r '.[0].low_24h')
ath=$(echo "$PRICE_DATA" | jq -r '.[0].ath')
atl=$(echo "$PRICE_DATA" | jq -r '.[0].atl')
```

### 5. **Displaying Results**
Finally, the script displays the fetched information in a clean, readable format using color-coded output for better readability.

```bash
echo -e "${GREEN}Current price of $coin: $btc_price USD${NC}"
```

---

## Error Handling

The script has robust error handling for the following conditions:

1. **No Internet Connection**: If the system is not connected to the internet, the script displays an error message and exits.
2. **Missing Dependencies**: If `curl` or `jq` is not installed, the script prompts the user to install them and exits.
3. **Invalid or Missing Coin Name**: If no coin name is provided or if the coin name is invalid, the script provides a usage message and exits.
4. **No Data Retrieved**: If the API does not return any data (e.g., due to an incorrect coin name), the script informs the user and exits.

---

## License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for more details.

---

## Acknowledgments

- **CoinGecko API**: For providing free, reliable, and up-to-date cryptocurrency data.
- **jq**: A powerful and flexible tool for processing JSON data.
- **curl**: A popular command-line tool for making HTTP requests.

---
