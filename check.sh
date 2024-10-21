#!/bin/bash
BLUE="\033[34m"
GREEN="\033[32m"
ORANGE="\033[38;5;214m"
RESET="\033[0m"

# 사용자 입력을 처리하는 함수 - default yes
process_input_default_yes() {
    local input="$1"
    input=$(echo "${input}" | tr '[:upper:]' '[:lower:]')

    if [[ "${input}" != "y" && "${input}" != "yes" && -n "${input}" ]]; then
        echo -e "${ORANGE}Reject process. Exit process.${RESET}"
        exit 0
    fi
}

# 디렉토리 확인
echo -e "${BLUE}[Repository list]\n$(ls -d */)${RESET}"

echo -e "Repository to check user config: \c"
read repository

cmd="cat './${repository}/.git/config' | grep '\[user\]\|\s*name\s*=\|\s*email\s*='"

# 커맨드 실행 확인
echo -e "Run: ${GREEN}${cmd}${RESET}"

echo -e "Run commands? (Y/n): \c"
read user_input
process_input_default_yes "${user_input}"

# 커맨드 실행
echo -e "${BLUE}$(eval ${cmd})${RESET}"