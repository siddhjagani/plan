#!/bin/sh
set -eu

# These are public browser-side Supabase credentials (anon/publishable key),
# protected by the row-level security and stored functions in supabase/voting.sql.
json_escape() {
  printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g; s/[[:cntrl:]]//g'
}

SUPABASE_URL_ESCAPED="$(json_escape "${SUPABASE_URL:-}")"
SUPABASE_ANON_KEY_ESCAPED="$(json_escape "${SUPABASE_ANON_KEY:-}")"

cat > /usr/share/nginx/html/config.js <<CONFIG
window.PAWNA_CONFIG = {
  supabaseUrl: "${SUPABASE_URL_ESCAPED}",
  supabaseAnonKey: "${SUPABASE_ANON_KEY_ESCAPED}"
};
CONFIG

exec "$@"
