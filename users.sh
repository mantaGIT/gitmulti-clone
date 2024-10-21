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

# 사용자 입력을 처리하는 함수 - default no
process_input_default_no() {
    local input="$1"
    input=$(echo "${input}" | tr '[:upper:]' '[:lower:]')

    if [[ "${input}" == "n" || "${input}" == "no" || -z "${input}" ]]; then
        echo -e "${ORANGE}Reject process. Exit process.${RESET}"
        exit 0
    fi
}

# 파일에서 데이터를 읽어오기
CONFIG_FILE="./users-config.txt"
index=0

# 마지막 줄에 개행 문자가 없으면 추가
if [ -n "$(tail -c 1 "${CONFIG_FILE}")" ]; then
    echo >> "${CONFIG_FILE}"
fi

while read -r line; do
    # 주석이 있는 줄 또는 비어있는 줄은 무시
    if [[ -z "${line}" || "${line}" =~ ^# ]]; then
        continue
    fi

    # 공백으로 구분된 데이터 추출
    read -r tag host user email <<< "${line}"

    # 배열에 태그 저장
    tags[${index}]="${tag}"

    index=$((index + 1))
done < ${CONFIG_FILE}

# 전체 태그 출력
echo -e "${BLUE}[Tag List] ${tags[*]}${RESET}"

# 새로운 유저 설정 생성 질의
echo -e "Create new user config? (Y/n): \c"
read user_input
process_input_default_yes "${user_input}"

echo -e "Create new user config - tag: \c"
read tag

echo -e "Create new user config - host: \c"
read host

echo -e "Create new user config - user: \c"
read user

echo -e "Create new user config - email: \c"
read email

# 생성된 설정 데이터 확인
echo -e "${BLUE}[New user config]${RESET}"
echo -e "${BLUE}Tag: ${tag}${RESET}"
echo -e "${BLUE}Host: ${host}${RESET}"
echo -e "${BLUE}User: ${user}${RESET}"
echo -e "${BLUE}Email: ${email}${RESET}"

echo -e "Create new user config with the above data? (y/N): \c"
read user_input
process_input_default_no "${user_input}"

# 설정 저장 - 중복 확인 X
echo -e "Run: ${GREEN}echo '${tag} ${host} ${user} ${email}' >> '${CONFIG_FILE}'${RESET}"
echo "${tag} ${host} ${user} ${email}" >> "${CONFIG_FILE}"