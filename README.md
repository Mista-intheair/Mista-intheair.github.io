# Personal Research Website (Quarto + GitHub Pages)

This project is a personal website with four sections:

- Home
- Daily Reports (PDF viewer)
- Projects
- CV (LaTeX-style web resume)

## Why this architecture

- Authoring language: Markdown (`.qmd`) with native support for:
  - Python code chunks
  - LaTeX math formulas
- Hosting platform: GitHub Pages (free, stable, and integrated with code repositories)

## Local preview

1. Install Quarto: https://quarto.org/docs/get-started/
2. In this folder, run with environment variable to use the project venv:

```bash
QUARTO_PYTHON=.venv/bin/python quarto preview
```

Or activate the venv first:
```bash
source .venv/bin/activate
quarto preview
```

## Build static site (both Chinese and English)

For convenience, use the build script which renders both versions:

```bash
./build.sh
```

Or manually build each version:

**Chinese version (中文):**
```bash
QUARTO_PYTHON=.venv/bin/python quarto render
```

**English version (English):**
```bash
cd en
QUARTO_PYTHON=../.venv/bin/python quarto render
cd ..
```

Both versions render into `docs/`:
- Chinese: `docs/index.html`
- English: `docs/en/index.html`

## Multi-language support

This site supports both Chinese and English:
- **Chinese (中文):** Root directory pages (index.qmd, etc.)
- **English:** `en/` subdirectory with mirror structure
- **Language switcher:** Use the 🌍 globe icon in the navbar to switch languages
- **Direct page links:** Each page has a footer link to the alternate language version

## GitHub Pages setup

### Option A: Deploy from `main` branch `/docs` folder

1. Push this repository to GitHub.
2. Go to **Settings -> Pages**.
3. Set **Source** to `Deploy from a branch`.
4. Choose `main` branch and `/docs` folder.

### Option B: Deploy by GitHub Actions

Use the included workflow in `.github/workflows/deploy.yml`.

1. In GitHub repository settings, set Pages source to **GitHub Actions**.
2. Push to `main` branch; workflow will build and deploy automatically.

## PDF reports

Put your latest daily report at:

- `assets/reports/daily-report-latest.pdf`

The page `daily-reports.qmd` embeds this file as an iframe.
