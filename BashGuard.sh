#!/bin/bash

LOG_FILE="/var/log/auth.log"
REPORT_DIR="logs"
SYSTEM_LOG="system_monitor.log"
mkdir -p "$REPORT_DIR"

# ANSI COLORS
RED='[0;31m'
GREEN='[0;32m'
YELLOW='[1;33m'
BLUE='[0;34m'
CYAN='[0;36m'
NC='[0m'

# LOG SYSTEM
log_action() {
    echo "[$(date)] $1" >> "$SYSTEM_LOG"
}

# ASCII BANNER
banner() {
    clear
    echo -e "${CYAN}"
    echo "██████╗  █████╗ ███████╗██╗  ██╗"
    echo "██╔══██╗██╔══██╗██╔════╝██║  ██║"
    echo "██████╔╝███████║███████╗███████║"
    echo "██╔══██╗██╔══██║╚════██║██╔══██║"
    echo "██████╔╝██║  ██║███████║██║  ██║"
    echo "╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝"
    echo ""
    echo "        LOG ANALYZER"
    echo -e "${NC}"
}

# RAM ALERT
check_ram() {
    RAM=$(free | awk '/Mem:/ {printf("%.0f", $3/$2 * 100)}')

    echo -e "${BLUE}RAM Usage:${NC} ${RAM}%"

    if [ "$RAM" -ge 80 ]; then
        echo -e "${RED}[ALERT] HIGH RAM USAGE DETECTED${NC}"
        log_action "High RAM usage detected: ${RAM}%"
    fi
}

# SSH ATTACK DETECTION
ssh_attacks() {
    echo -e "${RED}===== SSH FAILED ATTEMPTS =====${NC}"
    grep "Failed password" "$LOG_FILE" | tail -20

    echo ""
    echo -e "${YELLOW}===== SUSPICIOUS IPS =====${NC}"

    grep "Failed password" "$LOG_FILE" | \
    awk '{print $(NF-3)}' | \
    sort | uniq -c | sort -nr | head
}

# ACTIVE SERVICES
active_services() {
    echo -e "${GREEN}===== ACTIVE SERVICES =====${NC}"
    systemctl list-units --type=service --state=running | head -20
}

# OPEN PORTS
open_ports() {
    echo -e "${CYAN}===== OPEN PORTS =====${NC}"
    ss -tuln
}

# ACTIVE CONNECTIONS
active_connections() {
    echo -e "${BLUE}===== ACTIVE CONNECTIONS =====${NC}"
    who
    echo ""
    w
}

# TOP PROCESSES
top_processes() {
    echo -e "${YELLOW}===== TOP MEMORY PROCESSES =====${NC}"
    ps aux --sort=-%mem | head
}

# REAL TIME MONITOR
realtime_monitor() {
    echo -e "${GREEN}Monitoring logs in real time...${NC}"
    tail -f "$LOG_FILE"
}

# FULL REPORT
full_report() {
    REPORT_FILE="$REPORT_DIR/report_$(date +%F_%H-%M-%S).txt"

    {
        echo "===== FULL SYSTEM REPORT ====="
        echo "Date: $(date)"
        echo ""

        echo "===== RAM ====="
        free -h
        echo ""

        echo "===== DISK ====="
        df -h
        echo ""

        echo "===== TOP PROCESSES ====="
        ps aux --sort=-%mem | head
        echo ""

        echo "===== SSH ATTACKS ====="
        grep "Failed password" "$LOG_FILE" | tail -20
        echo ""

        echo "===== OPEN PORTS ====="
        ss -tuln
        echo ""

        echo "===== ACTIVE SERVICES ====="
        systemctl list-units --type=service --state=running | head -20

    } >> "$REPORT_FILE"

    echo -e "${GREEN}Report saved:${NC} $REPORT_FILE"

    log_action "Full report generated"
}

# TUI MENU
while true
 do
    banner

    echo -e "${GREEN}+--------------------------------------+${NC}"
    printf "| %-36s |\n" "1 - Generate Full Report"
    printf "| %-36s |\n" "2 - Detect SSH Attacks"
    printf "| %-36s |\n" "3 - RAM Monitor"
    printf "| %-36s |\n" "4 - Active Services"
    printf "| %-36s |\n" "5 - Open Ports"
    printf "| %-36s |\n" "6 - Active Connections"
    printf "| %-36s |\n" "7 - Top Processes"
    printf "| %-36s |\n" "8 - Real Time Monitor"
    printf "| %-36s |\n" "9 - Exit"
    echo -e "${GREEN}+--------------------------------------+${NC}"

    read -p "Select an option: " option

    case $option in
        1)
            clear
            full_report
            ;;

        2)
            clear
            ssh_attacks
            ;;

        3)
            clear
            check_ram
            ;;

        4)
            clear
            active_services
            ;;

        5)
            clear
            open_ports
            ;;

        6)
            clear
            active_connections
            ;;

        7)
            clear
            top_processes
            ;;

        8)
            clear
            realtime_monitor
            ;;

        9)
            echo -e "${RED}Exiting...${NC}"
            log_action "Program terminated"
            break
            ;;

        *)
            echo -e "${RED}Invalid option!${NC}"
            ;;
    esac

    echo ""
    read -p "Press ENTER to continue..."
done
