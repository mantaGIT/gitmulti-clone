#!/bin/bash
BLUE="\033[34m"
GREEN="\033[32m"
ORANGE="\033[38;5;214m"
RESET="\033[0m"

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
CURRENT_DIR="$(pwd)"
CONFIG_FILE="${CURRENT_DIR}/users-config.txt"
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

  # 배열에 데이터 저장
  tags[${index}]="${tag}"
  hosts[${index}]="${host}"
  users[${index}]="${user}"
  emails[${index}]="${email}"

  index=$((index + 1))
done < ${CONFIG_FILE}

# 저장된 유저 설정 옵션으로 제시
PS3="Choose a user tag number: "
echo -e "${BLUE}\c" # set color
select opt in "${tags[@]}"; do
  if [[ -n "${opt}" ]]; then
      break
  else
    echo -e "${ORANGE}Invalid option. Exit process.${RESET}"
    exit 0
  fi
done
echo -e "${RESET}\c" # set color

# 선택된 유저 정보 가져오기
index=$((${REPLY}-1))
host=${hosts[${index}]}
user=${users[${index}]}
email=${emails[${index}]}

# 원본 호스트 이름
HOSTNAME='github.com'

# URL 입력 받기
echo -e "origin: ${GREEN}$ git clone (SSH-URL)${RESET}\c"
read origin_url

# 문자열 대체
modified_url="${origin_url//${HOSTNAME}/${host}}" 
echo -e "Modify: ${BLUE}${origin_url} -> ${modified_url}${RESET}"

# URL에서 리포지토리 추출하기
repo_name=$(basename "${modified_url}" .git)

# 커맨드 정리
commands=("git clone ${modified_url}" 
        "cd ${repo_name}" 
        "git config user.name ${user}"
        "git config user.email ${email}")

# 커맨드 실행 확인
for cmd in "${commands[@]}"
do
  echo -e "Run: ${GREEN}${cmd}${RESET}"
done

echo -e "Run commands? (y/N): \c"
read user_input
process_input_default_no "${user_input}"

# 커맨드 실행
for cmd in "${commands[@]}"
do
  if [ $? -ne 0 ]; then # 에러 발생 시 멈춤
    echo -e "${ORANGE}Command error. Exit process.${RESET}"
    break
  fi
  echo -e "Run: ${GREEN}${cmd}${RESET}"
  eval "${cmd}"
done