# DevSecOps Portfolio

[![Build Status](https://github.com/asadyare/my-portfolio/actions/workflows/ci.yaml/badge.svg)](https://github.com/asadyare/my-portfolio/actions/workflows/ci.yaml) [![Snyk Vulnerabilities](https://snyk.io/test/github/asadyare/my-portfolio/badge.svg)](https://snyk.io/test/github/asadyare/my-portfolio)

A personal portfolio built with **Node.js**, **React**, **Tailwind CSS**, and **Vite**, showcasing projects and DevSecOps skills.

## Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Quick Setup](#quick-setup)
- [CI/CD & Security](#cicd--security)
- [Contributing](#contributing)
- [Screenshots](#screenshots)
- [License](#license)

## Features

- Responsive portfolio with About, Projects, and Contact sections
- Custom branding and favicon
- Pre-commit hooks to prevent committing secrets

## Tech Stack

- Frontend: Node.js, React, Tailwind CSS, Vite
- CI/CD: GitHub Actions
- Security: Snyk, CodeQL, pre-commit hooks

## Quick Setup

```bash
git clone https://github.com/asadyare/my-portfolio.git
cd your-repo/frontend
npm ci
npm run dev


Open <http://localhost:5173>

 to view locally.

```

## Contributing

Fork the repository and create a branch for your feature/fix

Run lint before committing:

npm run lint

Commit your changes; pre-commit hooks will enforce security rules

Submit a pull request to the main branch

## CI/CD & Security

GitHub Actions runs automatically on push and PR

Includes linting, Snyk vulnerability scan, and CodeQL analysis

Pre-commit hooks prevent secrets from being committed

Badges

## Screenshots

Include screenshots of your portfolio site here if needed

## License

This project is licensed under the MIT License.
