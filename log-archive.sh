#!/bin/bash

BOLD="\033[1m";
RED="\033[1;31m"
YELLOW="\033[1;33m"
GREEN="\033[1;32m"
NC="\033[0m"

usage() {
    echo -e "$YELLOW------------------------------------ USAGE ------------------------------------$NC"
    echo -e "$GREEN$0 <log_directory> [archive_directory] [max_age_days] [retention_days]$NC"
    echo -e "$BOLD<log_directory>     : Required. Source directory containing logs to archive$NC"
    echo -e "$BOLD[archive_directory] : Optional. Destination for compressed archives$NC"
    echo -e "$BOLD[max_age_days]      : Optional. Days before archiving logs$NC"
    echo -e "$BOLD[retention_days]    : Optional. Days to keep archives$NC"
    echo -e "$YELLOW-------------------------------------------------------------------------------$NC"
    exit 1
}

if [[ $# -lt 1 ]]; then
    usage
fi

LOG_DIR="$1"
ARCHIVE_DIR="${2:-$LOG_DIR/archives}"
MAX_AGE_DAYS="${3:-7}"
RETENTION_DAYS="${4:-30}"

if [[ ! -d "$LOG_DIR" ]]; then
    echo -e "${RED}ERROR: Log directory '$LOG_DIR' doesn't exist.$NC"
    exit 1
fi

mkdir -p $ARCHIVE_DIR

ARCHIVE_NAME="logs_archive_$(date +"%Y-%m-%d_%H:%M:%S").tar.gz"

if [[ ! -w "$LOG_DIR" ]]; then
    echo -e "${RED}Error: No write permissions for log directory '$LOG_DIR'.$NC"
    exit 1
fi

if [[ ! -w "$ARCHIVE_DIR" ]]; then
    echo -e "${RED}Error: No write permissions for log directory '$ARCHIVE_DIR'.$NC"
    exit 1
fi

echo -e "${GREEN}Archiving logs from $LOG_DIR older than $MAX_AGE_DAYS days...$NC"
find $LOG_DIR -type f -mtime +"$MAX_AGE_DAYS" -not -path "*/archives/*" \
    -print0 | tar -czvf "$ARCHIVE_DIR/$ARCHIVE_NAME" --null -T -

echo -e "${GREEN}Removing archived logs from $LOG_DIR...$NC"
find $LOG_DIR -type f -mtime +"$MAX_AGE_DAYS" -not -path "*/archives/*" -delete

echo -e "${GREEN}Removing archives older than $RETENTION_DAYS days from $ARCHIVE_DIR...$NC"
find $ARCHIVE_DIR -type f -mtime +"$RETENTION_DAYS" -delete

LOG_FILE="$ARCHIVE_DIR/archive.log"
echo -e "[$(date "+%Y-%m-%d %H:%M:%S")] Log archiving completed: $ARCHIVE_NAME." >> "$LOG_FILE"

echo -e "${GREEN}Archiving complete:$NC"
echo -e "${YELLOW}- Source directory: $LOG_DIR$NC"
echo -e "${YELLOW}- Archive directory: $ARCHIVE_DIR$NC"
echo -e "${YELLOW}- Archive file: $ARCHIVE_NAME$NC"
echo -e "${YELLOW}- Log of operation: $LOG_FILE$NC"