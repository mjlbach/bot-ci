# Helper functions & environment variable defaults for build dependencies on Travis.

require_environment_variable BUILD_DIR "${BASH_SOURCE[0]}" ${LINENO}

DOXYGEN_VERSION=${DOXYGEN_VERSION:-1.8.7}
CLANG_VERSION=${CLANG_VERSION:-3.4}

# Define directories where dependencies are installed to
DEPS_INSTALL_DIR=${DEPS_INSTALL_DIR:-${BUILD_DIR}/build/.deps}
DEPS_BIN_DIR=${DEPS_BIN_DIR:-${DEPS_INSTALL_DIR}/bin}
export PATH="${DEPS_BIN_DIR}:${PATH}"

install_doxygen() {
  mkdir -p ${DEPS_INSTALL_DIR} ${DEPS_BIN_DIR}

  echo "Installing Doxygen ${DOXYGEN_VERSION}..."
  mkdir -p ${DEPS_INSTALL_DIR}/doxygen
  wget -q -O - http://ftp.stack.nl/pub/users/dimitri/doxygen-${DOXYGEN_VERSION}.linux.bin.tar.gz \
    | tar xzf - --strip-components=1 -C ${DEPS_INSTALL_DIR}/doxygen
  ln -fs ${DEPS_INSTALL_DIR}/doxygen/bin/doxygen ${DEPS_BIN_DIR}
}

install_clang() {
  mkdir -p ${DEPS_BIN_DIR}

  echo "Installing Clang ${CLANG_VERSION}..."
  sudo add-apt-repository 'deb http://llvm.org/apt/precise/ llvm-toolchain-precise main'
  wget -q -O - http://llvm.org/apt/llvm-snapshot.gpg.key | sudo apt-key add -
  sudo apt-get update -qq
  sudo apt-get install -y -q clang-${CLANG_VERSION}

  ln -fs /usr/bin/clang ${DEPS_BIN_DIR}
  ln -fs /usr/bin/scan-build ${DEPS_BIN_DIR}
}

# For info on jq, see https://stedolan.github.io/jq
install_jq() {
  mkdir -p ${DEPS_BIN_DIR}

  echo "Installing jq..."
  sudo apt-get update -qq
  sudo apt-get install -y -q jq

  ln -fs /usr/bin/jq ${DEPS_BIN_DIR}
}

install_gcc_multilib() {
  mkdir -p ${DEPS_BIN_DIR}

  echo "Installing multilib GCC/G++."
  sudo apt-get update -qq
  sudo apt-get install -y -q gcc-multilib g++-multilib

  ln -fs /usr/bin/gcc ${DEPS_BIN_DIR}
  ln -fs /usr/bin/g++ ${DEPS_BIN_DIR}
  ln -fs ${DEPS_BIN_DIR}/gcc ${DEPS_BIN_DIR}/cc
  ln -fs ${DEPS_BIN_DIR}/g++ ${DEPS_BIN_DIR}/c++
}