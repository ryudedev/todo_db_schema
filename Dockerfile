FROM python:bookworm

RUN apt update && \
  apt install -y \
  bash-completion \
  jq \
  sudo \
  zip \
  unzip \
  less \
  vim \
  lsb-release \
  ca-certificates

ARG HOST_UID=1000
ARG HOST_GID=1000
ARG HOST_USER_NAME=developer

# Install poetry
RUN pip install poetry

#
# Remove existing users that might conflict
#
RUN if id "node" &>/dev/null; then userdel -r node 2>/dev/null || true; fi
RUN if getent group node &>/dev/null; then groupdel node 2>/dev/null || true; fi

#
# Create developer group and user
#
RUN groupadd -g ${HOST_GID} ${HOST_USER_NAME} 2>/dev/null || true \
  && useradd -m -s /bin/bash -u ${HOST_UID} -g ${HOST_GID} ${HOST_USER_NAME} 2>/dev/null || true \
  && echo "${HOST_USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/${HOST_USER_NAME} \
  && chmod 0440 /etc/sudoers.d/${HOST_USER_NAME}

#
# setup .bash_profile
#
RUN <<EOF
set -eu
cat <<'EOL'>>/home/${HOST_USER_NAME}/.bash_profile
if [ -f /etc/profile.d/bash_completion.sh ]; then
  . /etc/profile.d/bash_completion.sh
fi
EOL
EOF

#
# Add git completions shell
#
WORKDIR /etc/bash_completion.d
RUN <<EOF
set -eu
curl -O https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
curl -O https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
chmod a+x git*.*
EOF

#
# setup .bashrc
#
RUN <<EOF
set -eu
cat <<'EOL'>>/home/${HOST_USER_NAME}/.bashrc

if [ -f /etc/bash_completion ]; then
. /etc/bash_completion
fi

# Add prompt colors and aliases
export PS1="\[\033[01;32m\]\u@\h\[\033[01;33m\] \w \[\033[01;31m\]\$(__git_ps1 \"(%s)\") \\n\[\033[01;34m\]\\$ \[\033[00m\]"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias la='ls -a'
alias vi='vim'
EOL
EOF

#
# vim setting
#
RUN echo "set mouse-=a" >> /home/${HOST_USER_NAME}/.vimrc

#
# user directory permission
#
RUN chown -R ${HOST_UID}:${HOST_GID} /home/${HOST_USER_NAME}

# Install global npm packages as developer user
USER ${HOST_USER_NAME}

# Set the working directory to workspace
WORKDIR /workspace

# # Copy poetry configuration files
# COPY pyproject.toml poetry.lock* poetry.toml ./

# # Install Python dependencies
# RUN poetry install

# # Copy source code
# COPY src/ ./src/
