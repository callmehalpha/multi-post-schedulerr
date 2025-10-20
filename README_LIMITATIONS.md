# Operations Blocked in the Codex Sandbox

The Codex execution environment proxies all outbound HTTPS traffic and currently rejects tunnels to common package registries.
As a result, the following operations cannot be executed from within this workspace:

1. **Composer install / update**  
   * `composer install`, `composer update`, and `composer create-project` all fail with `CONNECT tunnel failed, response 403` when reaching `repo.packagist.org` or GitHub.

2. **Node package installation**  
   * Any `npm`, `yarn`, or `pnpm` commands that require network access fail for the same proxy reason. Front-end asset builds depending on remote registries cannot run.

3. **Docker builds requiring external downloads**  
   * Building container images that fetch system packages or Composer dependencies from the internet will error unless the required archives are pre-cached inside the project.

4. **API integrations or webhook simulations**  
   * Outbound HTTP calls to third-party APIs (social networks, OAuth providers, etc.) are blocked unless the proxy explicitly whitelists those hosts.

## Suggested Local Follow-up

To continue development locally:

1. Pull the latest code.
2. Run the blocked commands on a network with access to Packagist, npm, and any other registries you need.
3. Commit the resulting vendor/node modules (or at least the updated lock files) back into the repository so the remaining tasks can proceed in this sandbox without fresh downloads.

Documenting these gaps should help coordinate what needs to be executed off-box before further automation happens here.
