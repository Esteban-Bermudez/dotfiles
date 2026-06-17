function _prompt_version_trim {
  local value="$1"

  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"

  printf '%s' "$value"
}

function _prompt_version_file {
  local file="$1"
  local value

  [[ -f "$file" ]] || return 1

  value="$(<"$file")"
  value="${value%%$'\n'*}"
  value="$(_prompt_version_trim "$value")"
  [[ -n "$value" ]] || return 1

  printf '%s' "$value"
}

function _prompt_mise_assignment_value {
  local line="$1"
  local value

  value="${line#*=}"
  value="$(_prompt_version_trim "$value")"
  value="${value#\[}"
  value="${value%\]}"
  value="${value%%,*}"
  value="$(_prompt_version_trim "$value")"
  value="${value#\"}"
  value="${value%\"}"
  value="${value#\'}"
  value="${value%\'}"
  value="$(_prompt_version_trim "$value")"
  [[ -n "$value" ]] || return 1

  printf '%s' "$value"
}

function _prompt_mise_env_value {
  local config="$1"
  local env_var="$2"
  local line value in_env

  [[ -f "$config" ]] || return 1
  in_env=0

  while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line%%#*}"
    line="$(_prompt_version_trim "$line")"
    [[ -n "$line" ]] || continue

    if [[ "$line" == \[*\] ]]; then
      [[ "$line" == "[env]" ]] && in_env=1 || in_env=0
      continue
    fi

    (( in_env )) || continue
    [[ "$line" =~ '^"?'"$env_var"'"?[[:space:]]*=' ]] || continue

    value="$(_prompt_mise_assignment_value "$line")" || return 1
    printf '%s' "$value"
    return 0
  done < "$config"

  return 1
}

function _prompt_mise_resolve_value {
  local value="$1"
  local config="$2"
  local env_var

  if [[ "$value" =~ '^\{\{[[:space:]]*env\.([A-Za-z_][A-Za-z0-9_]*)[[:space:]]*\}\}$' ]]; then
    env_var="${match[1]}"
    value="${(P)env_var}"
    [[ -n "$value" ]] || value="$(_prompt_mise_env_value "$config" "$env_var")"
    value="$(_prompt_version_trim "$value")"
  fi

  [[ -n "$value" ]] || return 1

  printf '%s' "$value"
}

function _prompt_mise_tool_version {
  local tool="$1"
  local config line value in_tools

  for config in mise.toml .mise.toml; do
    [[ -f "$config" ]] || continue
    in_tools=0

    while IFS= read -r line || [[ -n "$line" ]]; do
      line="${line%%#*}"
      line="$(_prompt_version_trim "$line")"
      [[ -n "$line" ]] || continue

      if [[ "$line" == \[*\] ]]; then
        [[ "$line" == "[tools]" ]] && in_tools=1 || in_tools=0
        continue
      fi

      (( in_tools )) || continue
      [[ "$line" =~ '^"?'"$tool"'"?[[:space:]]*=' ]] || continue

      value="$(_prompt_mise_assignment_value "$line")" || return 1
      value="$(_prompt_mise_resolve_value "$value" "$config")" || return 1

      printf '%s' "$value"
      return 0
    done < "$config"
  done

  return 1
}

function _prompt_package_json_node_version {
  local line value in_engines

  [[ -f package.json ]] || return 1
  in_engines=0

  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ "$line" =~ '"engines"[[:space:]]*:' ]]; then
      in_engines=1
    fi

    (( in_engines )) || continue

    if [[ "$line" =~ '"node"[[:space:]]*:[[:space:]]*"([^"]+)"' ]]; then
      value="${match[1]}"
      value="$(_prompt_version_trim "$value")"
      [[ -n "$value" ]] || return 1

      printf '%s' "$value"
      return 0
    fi

    [[ "$line" == *'}'* ]] && in_engines=0
  done < package.json

  return 1
}

function _prompt_version_segment {
  local color="$1"
  local icon="$2"
  local version="$3"

  [[ -n "$version" ]] || return 0

  printf ' %%F{%s}%s %s%%f' "$color" "$icon" "$version"
}

function prompt_versions {
  local ruby_version node_version python_version go_version
  local ruby_prompt node_prompt python_prompt go_prompt

  ruby_version="$(_prompt_mise_tool_version ruby)"
  [[ -n "$ruby_version" ]] || ruby_version="$(_prompt_version_file .ruby-version)"
  ruby_prompt="$(_prompt_version_segment red '' "$ruby_version")"

  node_version="$(_prompt_mise_tool_version node)"
  [[ -n "$node_version" ]] || node_version="$(_prompt_version_file .node-version)"
  [[ -n "$node_version" ]] || node_version="$(_prompt_version_file .nvmrc)"
  [[ -n "$node_version" ]] || node_version="$(_prompt_package_json_node_version)"
  node_prompt="$(_prompt_version_segment green '󰎙' "$node_version")"

  if [[ -n "$VIRTUAL_ENV" ]]; then
    python_version="$(python3 --version 2>/dev/null)"
    python_version="${python_version#Python }"
    python_version="$(_prompt_version_trim "$python_version") (${VIRTUAL_ENV##*/})"
  else
    python_version="$(_prompt_mise_tool_version python)"
  fi
  python_prompt="$(_prompt_version_segment blue '' "$python_version")"

  go_version="$(_prompt_mise_tool_version go)"
  [[ -n "$go_version" ]] || go_version="$(_prompt_version_file .go-version)"
  go_prompt="$(_prompt_version_segment cyan '' "$go_version")"

  VERSION_PROMPT="$ruby_prompt$node_prompt$python_prompt$go_prompt"
}
