# gitmulti-clone

SSH 키를 사용한 `git clone` 시 URL 및 config 설정을 자동화하는 스크립트

[![My Skills](https://skillicons.dev/icons?i=bash,git)](https://skillicons.dev)

## Description

SSH 키를 사용해 여러 Github 계정을 사용할 경우 URL 및 리포지토리 config 각각 설정해야 합니다.

따라서 위의 과정에 필요한 정보를 미리 저장해두고 쉘 스크립트를 사용하여 설정을 자동화합니다.

## Project setup

> [!NOTE]
> 쉘 스크립트 작성 및 테스트 환경은 다음과 같습니다. 참고해주세요.
> 
> `OS` : macOS Sonoma 14
> 
> `Script type` : bash
> 
> `Version` : GNU bash, version 3.2.57(1)-release (arm64-apple-darwin23)

> [!WARNING]
>
> 쉘 스크립트에서 `Git` 명령어를 사용하므로 사전에 설치가 필요합니다.

### 쉘 스크립트 위치 설정

사용하실 워크스페이스 안에 쉘 스크립트 및 설정 파일을 다음과 같이 배치해주세요.

```
worksapce/
│
├── users.sh
├── gitclone.sh
├── check.sh
└── users-config.txt

```

쉘 스크립트를 사용하여 `git clone`을 진행할 경우 아래와 같이 워크스페이스 안에 리포지토리가 생성됩니다.

```
worksapce/
│
├── clone-repository/
│   ├── ...
│
├── users.sh
├── gitclone.sh
├── check.sh
└── users-config.txt

```

## Usage

### 1. 유저 설정

`users.sh` : `users-config.txt`에 host, Github ID, Email 등의 필요한 정보를 저장합니다.

```shell
# 실행 권한 설정
chmod +x users.sh

# 스크립트 실행
bash ./users.sh
```

<img width="600" alt="image" src="https://github.com/user-attachments/assets/f3cde102-0bca-4937-945e-7a8045f5359f">

- `Tag` : 유저 설정을 구분하기 위한 이름
- `Host` : github.com을 대체할 host
- `User` : Github ID
- `Email` : Github Email

> [!IMPORTANT]
> 유저 설정 시 `.ssh/config` 설정과 동일하게 설정해주세요.
> ```
> Host github.com-hello
>     HostName github.com
>     User hello
>     IdentityFile ~/.ssh/id_rsa_hello
> ```

> [!WARNING]
>
> 유저 설정 시 별도의 중복 확인 및 수정 기능을 제공하지 않습니다.
>
> `users-config.txt` 파일을 수정해서 사용해주세요.

### 2. Git clone

`gitclone.sh` : Github에서 제공하는 기본 URL을 입력받아 자동으로 프로젝트 셋팅을 진행합니다.

```shell
# 실행 권한 설정
chmod +x gitclone.sh

# 스크립트 실행
bash ./gitclone.sh
```

<img width="900" alt="image" src="https://github.com/user-attachments/assets/a7bb86ab-22f6-4c7b-88d1-ed187d2ce881">  


### 3. 리포지토리 유저 설정 확인

`gitclone.sh` : 선택한 리포지토리의 `.git/config` 파일을 확인하여 유저 설정이 정상적으로 되었는지 확인합니다.

```shell
# 실행 권한 설정
chmod +x check.sh

# 스크립트 실행
bash ./check.sh
```

<img width="750" alt="image" src="https://github.com/user-attachments/assets/4c62b9ce-aac6-4911-a9c1-4185f5b0531a">

