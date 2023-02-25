#!/usr/bin/env bash
# sudofox/shell-daddy.sh

daddy() (
  daddy_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

  # SHELL_daddyS_LITTLE - what to call you~ (default: "girl")
  # SHELL_daddyS_PRONOUNS - what pronouns daddy will use for themself~ (default: "her")
  # SHELL_daddyS_ROLES - what role daddy will have~ (default "daddy")

  COLORS_LIGHT_PINK='\e[38;5;217m'
  COLORS_LIGHT_BLUE='\e[38;5;117m'
  COLORS_FAINT='\e[2m'
  COLORS_RESET='\e[0m'

  DEF_WORDS_LITTLE="girl"
  DEF_WORDS_PRONOUNS="her"
  DEF_WORDS_ROLES="daddy"
  DEF_daddy_COLOR="${COLORS_LIGHT_PINK}"
  DEF_ONLY_NEGATIVE="false"

  NEGATIVE_RESPONSES=(
    "do you need daddyS_ROLE's help~? ❤️"
    "Don't give up, my love~ ❤️"
    "Don't worry, daddyS_ROLE is here to help you~ ❤️"
    "I believe in you, my sweet AFFECTIONATE_TERM~ ❤️"
    "It's okay to make mistakes, my dear~ ❤️"
    "just a little further, sweetie~ ❤️"
    "Let's try again together, okay~? ❤️"
    "daddyS_ROLE believes in you, and knows you can overcome this~ ❤️"
    "daddyS_ROLE believes in you~ ❤️"
    "daddyS_ROLE is always here for you, no matter what~ ❤️"
    "daddyS_ROLE is here to help you through it~ ❤️"
    "daddyS_ROLE is proud of you for trying, no matter what the outcome~ ❤️"
    "daddyS_ROLE knows it's tough, but you can do it~ ❤️"
    "daddyS_ROLE knows daddyS_PRONOUN little AFFECTIONATE_TERM can do better~ ❤️"
    "daddyS_ROLE knows you can do it, even if it's tough~ ❤️"
    "daddyS_ROLE knows you're feeling down, but you'll get through it~ ❤️"
    "daddyS_ROLE knows you're trying your best~ ❤️"
    "daddyS_ROLE loves you, and is here to support you~ ❤️"
    "daddyS_ROLE still loves you no matter what~ ❤️"
    "You're doing your best, and that's all that matters to daddyS_ROLE~ ❤️"
    "daddyS_ROLE is always here to encourage you~ ❤️"
  )

  POSITIVE_RESPONSES=(
    "*pets your head*"
    "awe, what a good AFFECTIONATE_TERM~\ndaddyS_ROLE knew you could do it~ ❤️"
    "good AFFECTIONATE_TERM~\ndaddyS_ROLE's so proud of you~ ❤️"
    "Keep up the good work, my love~ ❤️"
    "daddyS_ROLE is proud of the progress you've made~ ❤️"
    "daddyS_ROLE is so grateful to have you as daddyS_PRONOUN little AFFECTIONATE_TERM~ ❤️"
    "I'm so proud of you, my love~ ❤️"
    "daddyS_ROLE is so proud of you~ ❤️"
    "daddyS_ROLE loves seeing daddyS_PRONOUN little AFFECTIONATE_TERM succeed~ ❤️"
    "daddyS_ROLE thinks daddyS_PRONOUN little AFFECTIONATE_TERM earned a big hug~ ❤️"
    "that's a good AFFECTIONATE_TERM~ ❤️"
    "you did an amazing job, my dear~ ❤️"
    "you're such a smart cookie~ ❤️"
  )

  # allow for overriding of default words (IF ANY SET)

  if [[ -n "${SHELL_daddyS_LITTLE:-}" ]]; then
    DEF_WORDS_LITTLE="${SHELL_daddyS_LITTLE}"
  fi
  if [[ -n "${SHELL_daddyS_PRONOUNS:-}" ]]; then
    DEF_WORDS_PRONOUNS="${SHELL_daddyS_PRONOUNS}"
  fi
  if [[ -n "${SHELL_daddyS_ROLES:-}" ]]; then
    DEF_WORDS_ROLES="${SHELL_daddyS_ROLES}"
  fi
  if [[ -n "${SHELL_daddyS_COLOR:-}" ]]; then
    DEF_daddy_COLOR="${SHELL_daddyS_COLOR}"
  fi
  # allow overriding to true
  if [[ "${SHELL_daddyS_ONLY_NEGATIVE:-}" == "true" ]]; then
    DEF_ONLY_NEGATIVE="true"
  fi
  # if the array is set for positive/negative responses, overwrite it
  if [[ -n "${SHELL_daddyS_POSITIVE_RESPONSES:-}" ]]; then
    POSITIVE_RESPONSES=("${SHELL_daddyS_POSITIVE_RESPONSES[@]}")
  fi
  if [[ -n "${SHELL_daddyS_NEGATIVE_RESPONSES:-}" ]]; then
    NEGATIVE_RESPONSES=("${SHELL_daddyS_NEGATIVE_RESPONSES[@]}")
  fi
  
  # split a string on forward slashes and return a random element
  pick_word() {
    IFS='/' read -ra words <<<"$1"
    index=$(($RANDOM % ${#words[@]}))
    echo "${words[$index]}"
  }

  pick_response() { # given a response type, pick an entry from the array

    if [[ "$1" == "positive" ]]; then
      index=$(($RANDOM % ${#POSITIVE_RESPONSES[@]}))
      element=${POSITIVE_RESPONSES[$index]}
    elif [[ "$1" == "negative" ]]; then
      index=$(($RANDOM % ${#NEGATIVE_RESPONSES[@]}))
      element=${NEGATIVE_RESPONSES[$index]}
    else
      echo "Invalid response type: $1"
      exit 1
    fi

    # Return the selected response
    echo "$element"

  }

  sub_terms() { # given a response, sub in the appropriate terms
    local response="$1"
    # pick_word for each term
    local affectionate_term="$(pick_word "${DEF_WORDS_LITTLE}")"
    local pronoun="$(pick_word "${DEF_WORDS_PRONOUNS}")"
    local role="$(pick_word "${DEF_WORDS_ROLES}")"
    # sub in the terms, store in variable
    local response="$(echo "${response//AFFECTIONATE_TERM/$affectionate_term}")"
    local response="$(echo "${response//daddyS_PRONOUN/$pronoun}")"
    local response="$(echo "${response//daddyS_ROLE/$role}")"
    # we have string literal newlines in the response, so we need to printf it out
    # print faint and colorcode
    echo -e "${DEF_daddy_COLOR}$response${COLORS_RESET}"
  }

  success() {
    (
      # if we're only supposed to show negative responses, return
      if [ "$DEF_ONLY_NEGATIVE" == "true" ]; then
        return 0
      fi
      # pick_response for the response type
      local response="$(pick_response "positive")"
      sub_terms "$response" >&2
    )
    return 0
  }
  failure() {
    local rc=$?
    if [[ $rc -eq 130 ]]
    then
        return 0
    fi
    (
      local response="$(pick_response "negative")"
      sub_terms "$response" >&2
    )
    return $rc
  }
  # eval is used here to allow for alias resolution

  # TODO: add a way to check if we're running from PROMPT_COMMAND to use the previous exit code instead of doing things this way
  eval "$@" && success || failure
  return $?
)
