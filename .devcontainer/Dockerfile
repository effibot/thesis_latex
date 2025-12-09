FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# Install LaTeX and related tools
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get full-upgrade -y \
    && apt-get -y install --no-install-recommends \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-science \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    texlive-bibtex-extra \
    texlive-extra-utils \
    texlive-lang-italian \
    latexmk \
    chktex \
    biber \
    tex-gyre \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*
