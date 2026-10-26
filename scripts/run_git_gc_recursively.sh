fd -t d -H -I '^\.git$' . --exec sh -c '
  repo="$(dirname "$1")"
  echo "=== Scanning $repo ==="
  cd "$repo" && git gc
' _ {}
