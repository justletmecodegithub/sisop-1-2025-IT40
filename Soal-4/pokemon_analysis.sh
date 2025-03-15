#!/bin/bash
if [ $# -lt 2 ]; then
echo "Error: Need more argument boys! use --help for option information."
exit 1
fi

FILE=$1
COMMAND=$2
OPTION=$3
if [ ! -f "$FILE" ]; then
 echo "Error: File '$FILE' file not found my lord!"
exit 1
fi

show_info() {
highest_usage=$(awk -F, 'NR > 1 { if ($2+0 > max_usage) { max_usage = $2+0; name=$1 } } END { print name, max_usage"%" }' "$FILE")
highest_raw=$(awk -F, 'NR > 1 { if ($3+0 > max_raw) { max_raw = $3+0; name=$1 } } END { print name, max_raw" uses" }' "$FILE")
    
echo "Summary of $FILE"
echo "Highest Adjusted Usage: $highest_usage"
echo "Highest Raw Usage: $highest_raw"
}

sort_data() { 
if [ -z "$OPTION" ]; then  
echo "Error: Plz spesialize column for sorting!"
exit 1
fi

case "$OPTION" in
name) column=1; sort_option="-f" ;; 
usage) column=2; sort_option="-nr" ;;
raw) column=3; sort_option="-nr" ;;
hp) column=6; sort_option="-nr" ;;
atk) column=7; sort_option="-nr" ;;
def) column=8; sort_option="-nr" ;;
spatk) column=9; sort_option="-nr" ;;
spdef) column=10; sort_option="-nr" ;;
speed) column=11; sort_option="-nr" ;;
*) 
echo "Error: column is not valid for sorting!."
exit 1
;;
esac

{
head -n 1 "$FILE"
awk -F, 'NR > 1 { print $0 }' "$FILE" | LC_ALL=C sort -t, -k"$column","$column" $sort_option
} > sorted_output.csv

cat sorted_output.csv
}

show_help() {
YELLOW='\e[33m'
RED='\e[31m'  # merah2
BLUE='\e[34m' # biru wlee
NC='\e[0m'    # reset 

echo -e "Usage: ./pokemon_analysis.sh <file.csv> <command> [options]"
echo -e "                                    WELCOME TO POKESUSS!!!"
cat suss.txt
echo -e "${YELLOW}Commands:${NC}"
echo -e "  ${RED}--help${NC}           ${BLUE}Display Help${NC}"
echo -e "  ${RED}--info${NC}           ${BLUE}Display highest adjusted and raw usage${NC}"
echo -e "  ${RED}--sort <column>${NC}  ${BLUE}Sort the data by specific column${NC}"
echo -e "     ${RED}name${NC}          ${BLUE}Sort by Pokemons name${NC}"
echo -e "     ${RED}usage${NC}         ${BLUE}Sort by adjusted usage${NC}"
echo -e "     ${RED}raw${NC}           ${BLUE}Sort by raw usage${NC}"
echo -e "     ${RED}hp${NC}            ${BLUE}Sort by HP${NC}"
echo -e "     ${RED}atk${NC}           ${BLUE}Sort by Attack${NC}"
echo -e "     ${RED}def${NC}           ${BLUE}Sort by Defense${NC}"
echo -e "     ${RED}spatk${NC}         ${BLUE}Sort by Special Attack${NC}"
echo -e "     ${RED}spdef${NC}         ${BLUE}Sort by Special Defense${NC}"
echo -e "     ${RED}speed${NC}         ${BLUE}Sort by Speed${NC}"
echo -e "  ${RED}--grep <name>${NC}    ${BLUE}Search Pokemons by name${NC}"
}

case "$COMMAND" in
--help) show_help ;;
--info) show_info ;;
--sort) sort_data ;;
--grep) search_pokemon ;;
--filter) search_pokemon ;;
*) echo "Error: unknown command ma boyss!" ; exit 1 ;;
esac
