# Releasing

Releases publish to RubyGems through `.github/workflows/release.yml` when a
`v*` tag is pushed. The workflow verifies that the tag matches the gem version,
runs tests and builds on Ruby 3.3, 3.4 and 4.0, then checks the published OpenAPI
contract and publishes the gem using Trusted Publishing.

## One-time setup

Configure RubyGems' trusted publisher with:

- Gem: `fiscalrail`
- Repository owner: `fiscalrail`
- Repository: `fiscalrail-ruby`
- Workflow filename: `release.yml`
- GitHub environment: `release`

For the first push, create a pending trusted publisher under the maintainer's
RubyGems account. It becomes the gem's publisher after the first successful
release. The GitHub repository must have the matching `release` environment.
No RubyGems API key needs to be stored in GitHub secrets.

## Release a version

1. Update `lib/fiscalrail/version.rb` and `CHANGELOG.md`. Keep the planned release
   version aligned with the Python SDK.
2. Run `bundle exec rake generate` against the published contract and review the
   generated diff. Update handwritten resources and tests for changed operations.
3. Run `bundle exec rake test check_generated build`. For changes affecting invoice
   workflows, also run the optional Rails integration test and inspect its PDF.
4. Commit and push the release changes to `main`, then wait for CI to pass.
5. Tag that reviewed commit and push the tag. For example:

   ```sh
   git tag -a v0.4.0 -m "Release 0.4.0"
   git push origin v0.4.0
   ```

   **Pushing the tag triggers publication to RubyGems.**

6. Watch the Release workflow, verify `gem install fiscalrail -v VERSION` works,
   and create a GitHub release with the changelog notes.

If the workflow fails before publishing, fix the underlying issue and rerun when
appropriate. If a version is already published, do not attempt to replace its
artifact; publish a new version for code changes.

The workflow uses RubyGems' official credential action, followed by `gem push`.
It does not require Bundler's `rake release` task or permission to push Git tags.
