# Steam-ID

This gem provides ways to convert between the various versions of Steam IDs
found in the wild.

**Important** if you are using Steam web API bindings to e.g. resolve vanity
URLs, then either:
- Ensure you use the last **published** version of this gem and of
  `steam-condenser` as per this gem's dependencies, albeit at the cost of not
  being compatible with Ruby >= 2.7.
- Or use `master` of this gem along with commit `3ee580b@3ee580b` of
  `https://github.com/koraktor/steam-condenser-ruby.git` for Ruby >= 2.7
  compatibility.

As soon as `steam-condenser` releases a new version with the required changes,
we can release a version of `steam-id` with a dependency on that version of
`steam-condenser`.

## License

The gem is available as open source under the terms of the [Apache-2.0 License](http://opensource.org/licenses/Apache-2.0).

