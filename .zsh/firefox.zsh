add_history() {
  usage() {
    echo "Usage: $0 <url> <title>" >&2
    return 1
  }

  if [[ $# -ne 2 ]]; then
    usage
    return $?
  fi

  local url="$1"
  local title="$2"
  local profile_dir="$HOME/Library/Application Support/Firefox/Profiles"
  local profile
  local db
  local output

  if [[ ! -d "$profile_dir" ]]; then
    echo "Error: Firefox profiles directory not found: $profile_dir" >&2
    return 1
  fi

  profile=$(find "$profile_dir" \
    -maxdepth 1 \
    -type d \
    -name '*default-release*' \
    -print -quit)

  if [[ -z "$profile" ]]; then
    echo "Error: no Firefox default-release profile found." >&2
    return 1
  fi

  db="$profile/places.sqlite"

  if [[ ! -f "$db" ]]; then
    echo "Error: Firefox history database not found: $db" >&2
    return 1
  fi

  # Escape single quotes for SQLite string literals.
  local sql_url=${url//\'/\'\'}
  local sql_title=${title//\'/\'\'}

  if ! output=$(
    sqlite3 "$db" <<SQL
.timeout 1000

.parameter init
.parameter set :url "'$sql_url'"
.parameter set :title "'$sql_title'"

BEGIN TRANSACTION;

INSERT INTO moz_places (
    url,
    title,
    visit_count,
    last_visit_date
)
VALUES (
    :url,
    :title,
    1,
    strftime('%s', 'now') * 1000000
);

INSERT INTO moz_historyvisits (
    place_id,
    visit_date,
    visit_type
)
VALUES (
    last_insert_rowid(),
    strftime('%s', 'now') * 1000000,
    1
);

COMMIT;
SQL
  ) 2>&1; then
    if [[ "$output" == *"database is locked"* ]]; then
      echo "Error: Firefox history database is locked." >&2
      echo "Please close Firefox and try again." >&2
    else
      echo "Error: failed to update Firefox history." >&2
      [[ -n "$output" ]] && echo "$output" >&2
    fi
    return 1
  fi

  echo "Added: $title ($url)"
}
