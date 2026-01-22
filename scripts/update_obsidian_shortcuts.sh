# Script to copy hotkeys and snippets to other vault folders

# ===== CONFIGURATION =====
MAIN_VAULT_PATH="/home/nathan/Obsidian-Vaults/"
HOTKEYS_RELATIVE_PATH=".obsidian/hotkeys.json"
SNIPPETS_RELATIVE_PATH="snippets.ts"
PREFIXES=("CSE" "MTH" "PHY" "STT" "MUS" "ISS")
# =========================

# Check if source files exist
if [ ! -f "$MAIN_VAULT_PATH$HOTKEYS_RELATIVE_PATH" ]; then
    echo "Error: Source file '$MAIN_VAULT_PATH$HOTKEYS_RELATIVE_PATH' does not exist"
    exit 1
fi

if [ ! -f "$MAIN_VAULT_PATH$SNIPPETS_RELATIVE_PATH" ]; then
    echo "Error: Source file '$MAIN_VAULT_PATH$SNIPPETS_RELATIVE_PATH' does not exist"
    exit 1
fi

# Confirm the user wishes to copy these files
echo "Copying hotkeys and snippets found here:"
echo "$MAIN_VAULT_PATH$HOTKEYS_RELATIVE_PATH"
echo "$MAIN_VAULT_PATH$SNIPPETS_RELATIVE_PATH"
read -p "Do you wish to copy hotkeys and snippets to all matching vaults? (Y/n) " confirm
if [[ ! "$confirm" =~ ^([Yy]|)$ ]]; then
    echo "Aborting."
    exit 0
fi

echo "-----------------------------------------------------------------"

# Counter for successful copies
success_count=0

# Copy to each destination matching the prefix patterns
for prefix in "${PREFIXES[@]}"; do
    # Find all directories that start with the prefix
    matching_dirs=( "$MAIN_VAULT_PATH$prefix"* )

    for dir in "${matching_dirs[@]}"; do
        # Skip if not a directory
        if [ ! -d "$dir" ]; then
            continue
        fi

        # Copy the files
        cp $MAIN_VAULT_PATH$HOTKEYS_RELATIVE_PATH "$dir/$HOTKEYS_RELATIVE_PATH"
        cp $MAIN_VAULT_PATH$SNIPPETS_RELATIVE_PATH "$dir/$SNIPPETS_RELATIVE_PATH"

        if [ $? -eq 0 ]; then
            echo "  ✓ $dir/"
            ((success_count++))
        else
            echo "  ✗ $dir/"
        fi
    done
done

echo "-----------------------------------------------------------------"
echo "Hotkeys and snippets successfully copied to $success_count vaults."
