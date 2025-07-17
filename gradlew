#!/usr/bin/env sh

#
# Copyright 2015 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# @author Vladislav Zablotsky
#

# Attempt to find JAVA_HOME. We don't need it to run this script but we need
# it to run the command installed by the script.
if [ -z "$JAVA_HOME" ] ; then
  # On macOS, we can use this helper to find the correct JAVA_HOME
  if [ -x "/usr/libexec/java_home" ] ; then
    JAVA_HOME=`/usr/libexec/java_home`
  fi
fi

# We need java to be on the path to be able to run the command that this script
# downloads and installs.
if ! command -v java >/dev/null 2>&1 ; then
  # Abort if java is not on the path
  echo "java is not on the path"
  exit 1
fi

# We need to be able to write to this directory to store the downloaded wrapper
# and other files.
if [ ! -w . ] ; then
  echo "Cannot write to current directory"
  exit 1
fi

# The version of the wrapper to download
WRAPPER_VERSION=7.4

# The base URL to download the wrapper from
DOWNLOAD_URL="https://services.gradle.org/distributions"

# The name of the wrapper jar file
WRAPPER_JAR="gradle-wrapper.jar"

# The path to the wrapper jar file
WRAPPER_JAR_PATH=".gradle/wrapper/$WRAPPER_JAR"

# The path to the wrapper properties file
WRAPPER_PROPS_PATH=".gradle/wrapper/gradle-wrapper.properties"

# The path to the temporary wrapper jar file
TMP_WRAPPER_JAR_PATH="$WRAPPER_JAR_PATH.tmp"

# The command to run to download the wrapper
DOWNLOAD_CMD=""

if command -v curl >/dev/null 2>&1 ; then
  DOWNLOAD_CMD="curl -f -L"
elif command -v wget >/dev/null 2>&1 ; then
  DOWNLOAD_CMD="wget -q -O"
else
  echo "curl or wget is required"
  exit 1
fi

# If the wrapper jar doesn't exist, download it
if [ ! -f "$WRAPPER_JAR_PATH" ] ; then
  # Create the wrapper directory
  mkdir -p .gradle/wrapper

  # Download the wrapper
  echo "Downloading $DOWNLOAD_URL/gradle-$WRAPPER_VERSION-bin.zip"
  $DOWNLOAD_CMD "$DOWNLOAD_URL/gradle-$WRAPPER_VERSION-bin.zip" > "$TMP_WRAPPER_JAR_PATH"

  # Unzip the wrapper
  unzip -q -d .gradle/wrapper "$TMP_WRAPPER_JAR_PATH"
  rm "$TMP_WRAPPER_JAR_PATH"

  # Move the wrapper to the correct location
  mv .gradle/wrapper/gradle-$WRAPPER_VERSION/lib/gradle-wrapper-$WRAPPER_VERSION.jar "$WRAPPER_JAR_PATH"
fi

# Run the wrapper
exec java -jar "$WRAPPER_JAR_PATH" "$@"
