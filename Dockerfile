FROM mcr.microsoft.com/windows/servercore:ltsc2022 AS build

# Links for installed downloads.
ARG PYTHON_LINK=https://www.python.org/ftp/python/3.10.6/python-3.10.6-amd64.exe
ARG GIT_LINK=https://github.com/git-for-windows/git/releases/download/v2.37.2.windows.2/Git-2.37.2.2-64-bit.exe
ARG VS2019_LINK=https://aka.ms/vs/16/release/vs_buildtools.exe
ARG NASM_VERSION=2.16.01
ARG NASM_LINK=https://www.nasm.us/pub/nasm/releasebuilds/2.16.01/win64/nasm-2.16.01-win64.zip
ARG IASL_VERSION=20230331
ARG IASL_LINK=https://acpica.org/sites/acpica/files/iasl-win-20230331.zip

# Setup CMD as default shell.
SHELL ["cmd", "/S", "/C"]

# Download and Uncompress IASL
RUN curl -SL --output iasl-win-%IASL_VERSION%.zip %IASL_LINK%
RUN powershell -Command "expand-archive -Path 'c:\iasl-win-%IASL_VERSION%.zip' -DestinationPath 'c:\ASL'"
RUN del /q c:\iasl-win-%IASL_VERSION%.zip

# Download and Uncompress NASM
RUN curl -SL --output nasm-%NASM_VERSION%-win64.zip %NASM_LINK%
RUN powershell -Command "expand-archive -Path 'c:\nasm-%NASM_VERSION%-win64.zip' -DestinationPath 'c:\'"
RUN move nasm-%NASM_VERSION% nasm
RUN del /q nasm-%NASM_VERSION%-win64.zip

# Install Python3
RUN curl -SL --output python_install.exe %PYTHON_LINK%
RUN python_install.exe /quiet InstallAllUsers=1 PrependPath=1 Include_test=0
RUN del /q python_install.exe

# Install Git
RUN curl -SL --output git_install.exe %GIT_LINK%
RUN git_install.exe /verysilent /norestart /nocancel /simple
RUN del /q git_install.exe

# Install VS2019
RUN curl -SL --output vs_buildtools.exe %VS2019_LINK%
RUN vs_buildtools.exe --quiet --wait --norestart --nocache --installPath C:\BuildTools --add Microsoft.VisualStudio.Component.VC.CoreBuildTools --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows11SDK.22000
RUN del /q vs_buildtools.exe
