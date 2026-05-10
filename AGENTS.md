# Repository Guidelines

## Project Structure & Module Organization

This repository is currently a clean Git scaffold with no application source committed yet. As code is added, keep the layout predictable:

- `src/` for production source code.
- `tests/` for automated tests that mirror `src/` structure.
- `assets/` for static media, fixtures, or sample data.
- `docs/` for design notes, architecture decisions, and user-facing documentation.
- Root manifests such as `package.json`, `pyproject.toml`, or `Makefile`.

Avoid committing generated output, local editor settings, dependency folders, or secrets.

## Build, Test, and Development Commands

No build system is configured yet. When adding one, document canonical commands here and prefer a root-level entry point such as `Makefile` or package scripts.

Examples to add once applicable:

- `npm run dev`: start the local development server.
- `npm test`: run the automated test suite.
- `npm run lint`: run formatting and static checks.

Keep command names stable so contributors and automation can rely on them.

## Coding Style & Naming Conventions

Follow the conventions of the language or framework introduced into the repository. Until tooling is added, use consistent indentation, descriptive names, and small modules.

Recommended defaults:

- Use 2 spaces for JavaScript, TypeScript, JSON, YAML, and Markdown.
- Use 4 spaces for Python.
- Use `kebab-case` for directories and static asset names.
- Use `camelCase` for JavaScript variables/functions and `PascalCase` for components/classes.
- Use `snake_case` for Python modules, variables, and functions.

Add formatter and linter configuration with the first language stack.

## Testing Guidelines

Place tests in `tests/` or beside source files using the framework's standard pattern. Name tests after the behavior under test, for example `user-service.test.ts` or `test_user_service.py`.

New functionality should include focused tests for expected behavior and relevant edge cases. Bug fixes should include a regression test when practical.

## Commit & Pull Request Guidelines

There is no existing commit history to infer a project-specific convention. Use concise, imperative commit messages, such as `Add project scaffold` or `Fix login validation`.

Pull requests should include:

- A short description of the change.
- Test results, including commands run.
- Screenshots or recordings for user-facing UI changes.
- Notes about migrations, configuration, or follow-up work.

Repository:
- https://github.com/dongdongju96/trial_backup.git

## Security & Configuration Tips

Do not commit secrets, API keys, certificates, or machine-specific configuration. Use ignored local environment files such as `.env.local`, and commit a documented example file like `.env.example` when configuration is required.
