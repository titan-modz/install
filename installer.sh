#!/usr/bin/env bash
set -euo pipefail

# ====== CONFIG ======
KEYS_FILE="keys.json"

# Remote URLs
PTERO_PANEL_URL="https://raw.githubusercontent.com/titan-modz/24-7/refs/heads/main/panel"
PTERO_WINGS_URL="https://raw.githubusercontent.com/titan-modz/24-7/refs/heads/main/wings"
UBUNTU_COCKPIT_URL="https://raw.githubusercontent.com/titan-modz/24-7/refs/heads/main/cockpit"
DOCKER_COCKPIT_URL="https://raw.githubusercontent.com/titan-modz/24-7/refs/heads/main/cockpit1"

# ====== COLORS ======
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
CYAN='\e[36m'
MAGENTA='\e[35m'
RESET='\e[0m'

# ====== WATERMARK ======
print_watermark() {
  echo -e "${CYAN}==============================================================${RESET}"
  echo -e "${GREEN} _______    _______     __    __    __    _______    _______ ${RESET}"
  echo -e "${YELLOW}|  ___  |  |_____  |   |  |  |   \\/   |  |  _____|  |  _____|${RESET}"
  echo -e "${MAGENTA}| |___| |       /  /   |  |  |  \\  /  |  | |____    | |____${RESET}"
  echo -e "${CYAN}| |___| |     /  /     |  |  |  |\\/|  |  |  ____|   |  ____|${RESET}"
  echo -e "${RED}| |   | |   /  /____   |  |  |  |  |  |  | |_____   | |_____${RESET}"
  echo -e "${CYAN}|_|   |_|  |________|  |__|  |__|  |__|  |_______|  |_______|${RESET}"
  echo
  echo -e "${MAGENTA}              POWERED BY AZIMEEE${RESET}"
  echo -e "${CYAN}==============================================================${RESET}"
}

# ====== VERIFY LICENSE KEY ======
verify_key() {
  clear
  print_watermark
  echo -e "${CYAN}=================== LICENSE VALIDATION ===================${RESET}"

  if [[ ! -f "$KEYS_FILE" ]]; then
    echo -e "${RED}❌ Missing keys.json file! Please place it in the same folder.${RESET}"
    exit 1
  fi

  echo
  read -rp "🔑 Enter The KEY: " input_key

  if grep -q "\"$input_key\"" "$KEYS_FILE"; then
    echo -e "${GREEN}✅ License key verified successfully!${RESET}"
    sleep 1
  else
    echo -e "${RED}❌ Invalid key! Access denied.${RESET}"
    exit 1
  fi
}

# ====== MENU SYSTEM ======
print_main_menu() {
  clear
  print_watermark
  cat <<'EOF'
===============================
     Auto Installer Menu
===============================
1) Pterodactyl
2) VPS PANEL
3) Exit
-------------------------------
Choose a category (1/2/3):
EOF
}

print_pterodactyl_menu() {
  cat <<'EOF'
===============================
        Pterodactyl
===============================
1) Install Panel
2) Install Wings
3) Back
-------------------------------
Choose an option (1/2/3):
EOF
}

print_vps_menu() {
  cat <<'EOF'
===============================
        VPS PANEL
===============================
1) Ubuntu Cockpit
2) Docker Cockpit
3) Back
-------------------------------
Choose an option (1-3):
EOF
}

confirm_and_run() {
  local url="$1"
  echo
  read -rp "⚠️  You're about to run a remote installer from: $url
Proceed? (y/N): " confirm
  if [[ "${confirm,,}" == "y" ]]; then
    echo "🚀 Running installer..."
    bash <(curl -fsSL "$url")
  else
    echo "❌ Aborted."
  fi
}

# ====== SCRIPT START ======
verify_key

while true; do
  print_main_menu
  read -r main_choice
  case "$main_choice" in
    1)
      while true; do
        print_pterodactyl_menu
        read -r ptero_choice
        case "$ptero_choice" in
          1) confirm_and_run "$PTERO_PANEL_URL" ;;
          2) confirm_and_run "$PTERO_WINGS_URL" ;;
          3) break ;;
          *) echo "Invalid choice. Please enter 1, 2 or 3." ;;
        esac
      done
      ;;
    2)
      while true; do
        print_vps_menu
        read -r vps_choice
        case "$vps_choice" in
          1) confirm_and_run "$UBUNTU_COCKPIT_URL" ;;
          2) confirm_and_run "$DOCKER_COCKPIT_URL" ;;
          3) break ;;
          *) echo "Invalid choice. Please enter 1-3." ;;
        esac
      done
      ;;
    3)
      echo -e "${YELLOW}Bye 👋${RESET}"
      exit 0
      ;;
    *)
      echo "Invalid choice. Please enter 1, 2 or 3."
      ;;
  esac
done
