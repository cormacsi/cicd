#!/bin/bash

TIME="10"
TELEGRAM_BOT_TOKEN=$KEYTOKEN
TELEGRAM_CHAT_ID=$CHAT_ID

STATUS=$(if [ $CI_JOB_STATUS = "success" ]; then echo "success ✅"; else echo "failure 🚫"; fi)

URL="https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage"
TEXT="New commit by+$GITLAB_USER_NAME👩‍💻%0AProject:+$CI_PROJECT_NAME%0A\
%0AStage: ➡️+$CI_JOB_STAGE%0AStatus:+$STATUS%0ACommit title:+$CI_COMMIT_TITLE%0A\
Branch:+$CI_COMMIT_REF_SLUG%0AURL:+$CI_PROJECT_URL/pipelines/$CI_PIPELINE_ID/"

curl -s --max-time $TIME -d "chat_id=$TELEGRAM_CHAT_ID&disable_web_page_preview=1&text=$TEXT" $URL > /dev/null
