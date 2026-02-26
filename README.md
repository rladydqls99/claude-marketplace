# Dev Marketplace

React 기반 FSD 프론트엔드 개발을 위한 Claude 플러그인 마켓플레이스입니다.

## 포함된 플러그인

| 플러그인 | 설명 |
|---------|------|
| `dev-team-plugin` | 백엔드/풀스택 개발팀용 에이전트 모음 |
| `frontend-develop` | 프론트엔드 기획·개발·리뷰 에이전트 모음 |

---

## 설치 방법

### 방법 1: GitHub 원격 설치 (권장)

Claude Code에서 아래 명령어를 실행합니다.

```
/plugin marketplace add rladydqls99/claude-marketplace
```

마켓플레이스 등록 후 원하는 플러그인을 설치합니다.

```
/plugin install dev-team-plugin@dev-market-place
/plugin install frontend-develop@dev-market-place
```

또는 `/plugin` → **Discover** 탭에서 UI로 선택해 설치할 수 있습니다.

### 방법 2: 로컬 설치

```bash
# 1. 저장소 클론
git clone https://github.com/rladydqls99/claude-marketplace.git

# 2. Claude Code에서 로컬 마켓플레이스 등록
/plugin marketplace add ./claude-marketplace/dev-marketplace
```

---

## 마켓플레이스 관리

```
/plugin marketplace list                        # 등록된 마켓플레이스 목록 확인
/plugin marketplace update dev-market-place     # 최신 플러그인 목록으로 갱신
/plugin marketplace remove dev-market-place     # 마켓플레이스 제거
```

## 플러그인 제거

```
/plugin uninstall frontend-develop
/plugin uninstall dev-team-plugin
```
