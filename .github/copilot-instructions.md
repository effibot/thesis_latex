# Copilot Instructions for LaTeX Thesis Project

## Project Overview
This is an Italian-language Master's thesis for Università degli Studi di Roma Tor Vergata about designing an autonomous mobile robot for industrial environments using CANopen communication protocol. The thesis covers robotics, control systems, and industrial automation.

## Document Structure

### Main Entry Point
- [main.tex](../main.tex) is the root document that orchestrates all chapters
- Chapters are stored in `chapters/` and included via `\input{filename}` (no `.tex` extension)
- Images are in `img/` organized by chapter number (`img/1/`, `img/2/`, etc.)
- Bibliography is in [bibliography.bib](../bibliography.bib) using BibTeX format

### Chapter Organization
1. **frontespizio.tex** - Title page with university branding and author info
2. **1-introduzione.tex** - Introduction to Daikin Applied Europe and thesis objectives
3. **2-robot-mobili.tex** - Literature review on mobile robots, navigation algorithms (A*, SLAM, FAST-LIO 2), and industrial protocols (CAN, CANopen)
4. **3-requirements.tex** - Requirements analysis and component selection
5. **4-modello-cinematico.tex** - Kinematic model and control algorithms (currently in progress)

## Key Conventions

### LaTeX Practices
- **Language**: All content is in Italian; use proper Italian technical terminology
- **Font system**: Uses TeX Gyre Adventor (sans-serif) for body text and Arev for math
- **Custom environments**: Defined in [thesisenvs.sty](../thesisenvs.sty) - use `\begin{note}`, `\begin{theorem}`, `\begin{definition}`, etc. for callouts
- **References**: Use `\cref{label}` (from cleveref package) instead of `\ref` for automatic "Figura", "Capitolo" prefixes
- **Citations**: Use `\cite{key}` with BibTeX entries from bibliography.bib
- **Units**: Use `\SI{}{}` and `\unit{}` from siunitx package for consistent formatting

### Image Management
- Store images in `img/{chapter_number}/` directories
- Use `\includegraphics[width=\textwidth]{chapter/filename.pdf}` (no `img/` prefix, it's auto-added)
- Always include `\caption{}` and `\label{fig:meaningful_name}` for figures
- Prefer vector formats (PDF) over raster images when possible

### File Paths Configuration
```latex
\graphicspath{{img/}}           % Images auto-resolved from img/
\def\input@path{{chapters/}}    % Chapters auto-resolved from chapters/
```

## Build System

### Development Container
The project uses a devcontainer with Ubuntu 24.04 and full TeXLive installation:
- Dockerfile: [.devcontainer/Dockerfile](../.devcontainer/Dockerfile)
- Includes: texlive-latex-extra, texlive-science, texlive-lang-italian, latexmk, biber
- VS Code extension: LaTeX Workshop pre-configured

### Build Commands
```bash
# Primary build method (via latexmk)
latexmk -pdf -synctex=1 -interaction=nonstopmode -file-line-error -outdir=build main.tex

# Word count (requires Docker image built via build_image.sh)
./scripts/texcount.sh main.tex

# Build Docker image for utilities
./build_image.sh
```

### Output Location
- All build artifacts go to `build/` directory (configured in devcontainer.json)
- PDF output: `build/main.pdf`
- Auxiliary files: `build/main.aux`, `build/main.bbl`, etc.

## Content Guidelines

### Technical Writing
- Use formal academic Italian (avoid contractions, use passive voice appropriately)
- Define acronyms on first use: "Autonomous Mobile Robot (AMR)"
- Reference figures and sections using `\cref{}` for automatic formatting
- Use custom environments from thesisenvs.sty for important notes and definitions

### Mathematical Notation
- Use `equation` environment for numbered equations
- Use `aligned` within equations for multi-line derivations
- Math symbols: wrap in `$...$` for inline, `\[...\]` or `equation` for display

### Bibliography
- All references are in [bibliography.bib](../bibliography.bib)
- Entry types: @article, @inproceedings, @techreport, @manual
- Key naming: `lastname+year+keyword` (e.g., `xu2022fastlio2`, `hart1968astar`)

## Common Tasks

### Adding a New Chapter
1. Create `chapters/N-chapter-name.tex`
2. Add `\input{N-chapter-name}` to [main.tex](../main.tex) before `\bibliography`
3. Create `img/N/` directory for chapter images
4. Start with `\chapter{Title}` and organize with `\section{}`, `\subsection{}`

### Adding Figures
```latex
\begin{figure}[htbp]
    \centering
    \includegraphics[width=0.9\textwidth]{chapter_num/image_name.pdf}
    \caption{Descriptive caption in Italian.}
    \label{fig:meaningful_label}
\end{figure}
```

### Using Custom Environments
```latex
\begin{note}
    Important information for readers in a highlighted box.
\end{note}

\begin{theorem}[Optional Name]
    Formal theorem statement with automatic numbering.
\end{theorem}
```

### Cross-References
```latex
\label{sec:section_name}          % Define label
Come visto nella \cref{sec:section_name}  % Reference (auto-formats as "Sezione 3.2")
```

## Project-Specific Context

### Domain Knowledge
- **Target application**: Industrial material handling at Daikin Applied Europe factory
- **Robot architecture**: Differential drive mobile robot with LiDAR, IMU sensors
- **Communication**: CANopen protocol over CAN bus for motor control
- **Navigation**: FAST-LIO 2 algorithm for SLAM and localization
- **Control**: Kinematic model for differential drive vehicles

### Key Algorithms Referenced
- Path planning: A*, Dijkstra, RRT
- Obstacle avoidance: VFH, DWA, Potential Fields
- SLAM: FAST-LIO 2 (LiDAR-Inertial Odometry)

## Troubleshooting

### Common LaTeX Issues
- **Font warnings**: Shape substitutions for qag (Adventor) are intentional, see [main.tex](../main.tex) `\DeclareFontShape` commands
- **Missing references**: Run build twice for cross-references and TOC to resolve
- **Bibliography not showing**: Ensure bibtex/biber runs after first LaTeX pass (latexmk handles this)

### VS Code LaTeX Workshop
- PDF viewer opens in tab (configured in devcontainer.json)
- SyncTeX enabled for bidirectional navigation between source and PDF
- Output directory set to `build/` to keep root clean
