brew bundle --file=./Brewfile

# Authenticate with GitHub CLI only if not already logged in
if ! gh auth status &>/dev/null; then
  echo "🔐 GitHub CLI not logged in. Launching auth..."
  gh auth login
else
  echo "✅ GitHub CLI already authenticated."
fi

npm install -g @anthropic-ai/claude-code

defaults write com.apple.dock autohide -bool true && killall Dock



# Setup Fish shell
echo "Setting Fish as default shell..."
FISHPATH="$(which fish)"

if ! grep -q "$FISHPATH" /etc/shells; then
  echo "$FISHPATH" | sudo tee -a /etc/shells
fi

chsh -s "$FISHPATH"

# Create Fish config
FISH_CONFIG="$HOME/.config/fish/config.fish"
mkdir -p "$(dirname "$FISH_CONFIG")"

cat > "$FISH_CONFIG" <<EOF
# Fish shell config

# Path additions
set -gx PATH \$PATH (npm bin -g)

# Aliases
alias pip="uv pip"
alias pip3="uv pip"
alias gs="git status"
alias ga="git add ."
alias gc="git commit -m"
alias gp="git push"
alias claudechat="claude -p"

# Useful prompt option (optional):
set fish_greeting "Welcome, Conrad. Let's build something."
EOF

echo "✅ Fish shell configured at $FISH_CONFIG"





# Create Arduino CLI config dir
mkdir -p "$HOME/.arduino15"

# Initialize config (only runs if no config exists)
arduino-cli config init

# Add ESP8266 and ESP32 board manager URLs
arduino-cli config add board_manager.additional_urls https://arduino.esp8266.com/stable/package_esp8266com_index.json
arduino-cli config add board_manager.additional_urls https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json

# Update board indexes
arduino-cli core update-index

# Install both cores
arduino-cli core install esp8266:esp8266
export GODEBUG=http2client=0
export ARDUINOCLI_HTTP_TIMEOUT=300s
arduino-cli core install esp32:esp32