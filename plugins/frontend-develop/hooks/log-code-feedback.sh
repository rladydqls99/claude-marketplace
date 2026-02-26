#!/bin/bash
# log-code-feedback.sh
# 사용자가 코드 구현 방식에 대한 재요청을 했을 때 로그를 기록합니다.
# 예: "useState 말고 useForm 사용해", "fetch 대신 ky 써줘"

# stdin에서 JSON 읽기
INPUT=$(cat)

# 사용자 메시지 추출
PROMPT=$(echo "$INPUT" | jq -r '.prompt // ""')

# 프로젝트 디렉토리 (Claude Code 실행 중인 프로젝트 루트)
PROJECT_DIR="$CLAUDE_PROJECT_DIR"

# 메시지가 비어있으면 종료
if [ -z "$PROMPT" ] || [ "$PROMPT" = "null" ]; then
  exit 0
fi

# 재요청 패턴 (부정/변경 지시어)
REJECTION_PATTERNS=(
  # 한국어 - 거부/변경
  "말고"
  "대신"
  "쓰지.*마"
  "쓰지마"
  "안.*쓰고"
  "안쓰고"
  "사용하지.*마"
  "바꿔"
  "변경해"
  "교체해"
  "하지.*말고"
  "그렇게.*말고"
  "그게.*아니라"
  "아니고"
  # 한국어 - 로그 요청
  "로그.*남겨"
  "log.*남겨"
  "기록.*남겨"
  "기록해.*줘"
  "메모.*해줘"
  # 영어 - 거부/변경
  "instead of"
  "don't use"
  "do not use"
  "rather than"
  "switch to"
  "change to"
  "replace with"
  "use .* instead"
  "not .* but"
  "stop using"
  "avoid using"
)

# 패턴 매칭 확인
has_rejection=false
matched_pattern=""

# 재요청 패턴 확인 (대소문자 무시)
for pattern in "${REJECTION_PATTERNS[@]}"; do
  if echo "$PROMPT" | grep -iE "$pattern" > /dev/null 2>&1; then
    has_rejection=true
    matched_pattern="$pattern"
    break
  fi
done

# 재요청 패턴이 있으면 로그 기록
if [ "$has_rejection" = true ]; then
  # docs 폴더 경로
  DOCS_DIR="$PROJECT_DIR/docs"
  LOG_FILE="$DOCS_DIR/code-feedback-log.md"

  # docs 폴더가 없으면 생성
  if [ ! -d "$DOCS_DIR" ]; then
    mkdir -p "$DOCS_DIR"
  fi

  # 로그 파일이 없으면 헤더 추가
  if [ ! -f "$LOG_FILE" ]; then
    cat > "$LOG_FILE" << 'HEADER'
# Code Feedback Log

이 파일은 AI 코딩 어시스턴트에게 제공된 코드 구현 방식에 대한 피드백을 기록합니다.
사용자가 특정 구현 방식 대신 다른 방식을 요청한 경우 자동으로 기록됩니다.

---

HEADER
  fi

  # 타임스탬프
  TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

  # 로그 항목 추가
  cat >> "$LOG_FILE" << EOF
## $TIMESTAMP

**요청 내용:**
\`\`\`
$PROMPT
\`\`\`

**감지된 패턴:** $matched_pattern

---

EOF

fi

# 항상 exit 0 (훅은 진행을 차단하지 않음)
exit 0
