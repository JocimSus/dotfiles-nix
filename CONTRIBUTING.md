# Contributing Guidelines

Thank you for your interest in contributing to my NixOS .dotfiles repository. 

To maintain a clean and readable project, please adhere to the following guidelines regarding code style, testing, and commit messages.

## Code Style
* **Formatter:** All `.nix` files must be formatted using `nixfmt` (use `nixfmt-tree` to format multiple files).
* **Modularity:** Keep configurations modular. Device specific quirks should stay in host directories (`hosts/`), while reusable services should go in `modules/`.

## Formatting and Testing Your Changes
Before committing and pushing changes, ensure that your configurations evaluate correctly:
1. Run this formatting command in the directory of your changes  
    ```bash
    nix-shell -p nixfmt-tree --run "treefmt ."
    ```
2. Run a syntax check on modified files:
    ```bash
    nix-instantiate --parse /path/to/file.nix
    ```
3. Run a full flake check to ensure no outputs are broken:
    ```bash
    nix flake check
    ```

## Commit Message Convention
This repository follows a commit message format loosely based on Conventional Commits, with some extras tailored for my NixOS configuration.

**Format:**
```
type(scope): description
```
*(The `scope` is optional but highly recommended to specify what host, module, or package was affected).*

### Allowed Types
* **`hosts`**: Changes specific to a host's main configuration files (e.g., separating files, enabling an app).
* **`modules`**: Changes or additions to shared, reusable modules (e.g., `modules/services/authentik`).
* **`pkgs`**: Creation, updates, or fixes for custom packages located in the `pkgs/` directory (e.g., `gtnh-server`).
* **`services`**: Enabling, disabling, or modifying a specific service/container.
* **`flakes`**: Updates to `flake.nix` or bumping the `flake.lock` file.
* **`docs`**: Updates to READMEs or inline documentation.
* **`refactor`**: Code cleanup, formatting, or restructuring that doesn't change functionality.
* **`fix`**: Fixing a bug or correcting a broken configuration.
* **`chore`**: Commits that represent tasks like initial commit, modifying .gitignore, ...
* **`ci`**: Changes to GitHub Actions or CI/CD pipelines.
* **`style`**: Commits that address code style (e.g., white-space, formatting, missing semi-colons) and do not affect application behavior

### Allowed Scopes
The scope should point to the exact host, package, or component being modified:
* **Hosts**: `(msi-laptop)`, `(server)`
* **Packages/Modules**: `(gtnh)`, `(gtnh-server)`, `(waydroid)`, `(authentik)`, etc
* **Flakes**: `(lock)`, or empty
* **General Contexts**: `(scripts)`, `(github)`, `(gitignore)`

### Examples
* `hosts(msi-laptop): separated configurations for ease of reading/editing`
* `flakes(lock): updated, added workaround for openldap`
* `pkgs(gtnh-server): renamed pkg, playable, version update logic WIP`
* `refactor(server): cleanup, formatted, removed unused`
* `docs(msi-laptop): added some docs`
* `fix(authentik): move data directories to /var/lib`
