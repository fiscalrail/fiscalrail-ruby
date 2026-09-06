# Releasing

The gem has not been published. Before the first release, create the intended
`fiscalrail/fiscalrail-ruby` remote and confirm ownership/availability of the
`fiscalrail` RubyGems name. The gemspec links target that intended repository.

1. Run `bundle exec rake generate` against the published contract and review the
   generated diff. Update handwritten resources and tests for changed operations.
2. Run `bundle exec rake test check_generated build`; ensure the GitHub Actions
   Ruby 3.3, 3.4 and 4.0 matrix passes. Run the optional Rails integration test and
   inspect its rendered PDF for releases affecting invoice workflows.
3. Update `lib/fiscalrail/version.rb` and `CHANGELOG.md`. Replace the README's
   unpublished installation note with `gem "fiscalrail"` for the first release.
4. Commit the release changes, including generated files, and build again. Check
   the gem installs and `require "fiscalrail"` works outside the source checkout.
5. Tag the reviewed commit `vVERSION` and push it to the intended remote.
6. Publish the built artifact using an authorized RubyGems account with MFA:
   `gem push fiscalrail-VERSION.gem`.
7. Create release notes from the changelog and verify installation from RubyGems.

Publishing is a separate maintainer action. CI builds and checks the artifact;
it does not publish gems or require publishing credentials.
