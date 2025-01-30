# Add user's local bin directory to PATH
export PATH="$PATH:$HOME/.local/bin"

# Go configuration
export GOPATH="$HOME/.local/share/go"
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:/usr/local/go/bin"

# Add user's scripts directory to PATH
export PATH="$HOME/.config/scripts:$PATH"

# Swift configuration (adjust version as needed)
export PATH="$HOME/opt/swift-6.0.3-RELEASE-ubuntu24.04/usr/bin:$PATH"

# Clang/LLVM configuration (adjust version as needed)
export PATH="$HOME/opt/clang+llvm-17.0.6-x86_64-linux-gnu-ubuntu-22.04/bin:$PATH"

# Cargo (Rust) configuration
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Ruby gem
export GEM_HOME=$HOME/.local/bin/gem
export GEM_PATH=$HOME/.local/bin/gem
export PATH="$HOME/.local/bin/gem/bin:$PATH"
