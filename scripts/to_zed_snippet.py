import sys


def read_input():
    if not sys.stdin.isatty():
        # If input is piped in
        return sys.stdin.read()
    elif len(sys.argv) > 1:
        # If input is passed as an argument
        return sys.argv[1]
    else:
        # Prompt user to paste text
        print("Paste your multiline text. Press Ctrl+D when done.")
        return sys.stdin.read()


input_text = read_input()

output_lines = []
for line in input_text.splitlines():
    # Count leading spaces
    num_spaces = 0
    for char in line:
        if char == " ":
            num_spaces += 1
        else:
            break

    # Convert spaces to tabs
    num_tabs = num_spaces // 2  # Assuming 2 spaces per tab for Nix
    no_indent_line = line[num_spaces:]
    new_line = "\\t" * num_tabs + no_indent_line

    # Escape special characters
    new_line = new_line.replace('"', '\\"')  # Escape quotes (\")
    new_line = new_line.replace("$", "\\\\$")  # Escape dollar signs (\\$)

    # Create the final line with quotes and a comma
    output_lines.append(f'"{new_line.strip()}",')

# Ensure the first line is not an empty string
if output_lines[0] == '"",':
    output_lines = output_lines[1:]

# Ensure the last line is an empty string
if output_lines[-1] != '"",':
    output_lines.append('"",')

print("-" * 80)
for line in output_lines:
    print(line)
