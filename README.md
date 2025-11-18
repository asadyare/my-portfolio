# My DevSecOps Portfolio

[![Build Status](https://github.com/asadyare/my-portfolio/actions/workflows/main.yml/badge.svg)](https://github.com/asadyare/my-portfolio/actions)

[![Snyk Vulnerabilities](https://snyk.io/test/github/asadyare/my-portfolio/badge.svg)](https://snyk.io/test/github/asadyare/my-portfolio)

[![CodeQL](https://github.com/asadyare/my-portfolio/actions/workflows/codeql-analysis.yml/badge.svg)](https://github.com/asadyare/my-portfolio/security/code-scanning)

 . Build Status: Shows whether your GitHub Actions workflow passes

 . Snyk Vulnerabilities: Displays your repo’s vulnerability scan results

 . CodeQL: Shows the status of GitHub’s automated code scanning

## Overview

This is my personal portfolio built with **Node.js**, **Tailwind CSS**, and **Vite**.  
It showcases my projects, skills, and DevSecOps expertise with CI/CD integration using **GitHub Actions**, security scanning with **Snyk**, and code analysis using **CodeQL**.

## Features

- Responsive portfolio site with About, Projects, and Contact sections
- Custom branding and favicon
- CI/CD pipeline with automated linting, security, and code analysis
- Pre-commit hooks to prevent accidental secrets

## Tech Stack

- Frontend: Node.js, Vite, React, Tailwind CSS
- CI/CD: GitHub Actions
- Security: Snyk, CodeQL, pre-commit hooks
- Hosting (optional): AWS S3 + CloudFront / GitHub Pages

## Setup Instructions

1. Clone the repository:

   ```bash
   git clone https://github.com/asadyare/my-portfolio.git
   cd your-repo/frontend

2. Install dependencies:

npm ci
Run the development server:
npm run dev

Open <http://localhost:5173>

 to view locally.

## Contributing

Fork the repository and create a branch for your feature/fix

Run lint before committing:

npm run lint

Commit your changes; pre-commit hooks will enforce security rules

Submit a pull request to the main branch

Testing & CI/CD

GitHub Actions runs automatically on push and PR

Includes linting, Snyk vulnerability scan, and CodeQL analysis

Pre-commit hooks prevent secrets from being committed

Badges

## Screenshots

Include screenshots of your portfolio site here if needed

## License

This project is licensed under the MIT License.
