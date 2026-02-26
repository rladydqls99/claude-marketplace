## 포함된 플러그인

| 플러그인 | 설명 |
|---------|------|
| `dev-team-plugin` | 백엔드/풀스택 개발팀용 에이전트 모음 |
| `frontend-develop` | 프론트엔드 기획·개발·리뷰 에이전트 모음 |

---

## 설치 방법

### 방법 1: GitHub 원격 설치

Claude Code에서 아래 명령어를 실행합니다.

```
/plugin marketplace add https://github.com/rladydqls99/claude-marketplace.git
```

마켓플레이스 등록 후 원하는 플러그인을 설치합니다.

또는 `/plugin` → **Marketplaces** 탭에서 UI로 선택해 설치할 수 있습니다.

```
1. Add Marketplace 클릭
2. https://github.com/rladydqls99/claude-marketplace.git 입력
3. 설치하고자 하는 플러그인 설치
```

### 방법 2: 로컬 설치

```bash
# 1. 저장소 클론
git clone https://github.com/rladydqls99/claude-marketplace.git

# 2. Claude Code에서 로컬 마켓플레이스 등록
/plugin marketplace add ./claude-marketplace/dev-marketplace
```

