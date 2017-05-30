# Change log

This document represents a high-level overview of changes made to this project.
It will not list every miniscule change, but will allow you to view - at a
glance - what to expact from upgrading to a new version.

## [unpublished]

### Added

- Support for community URLs containing Steam ID3.

### Changed

### Fixed

### Security

### Deprecated

### Removed


## [0.2.0] - 2017-03-07

### Added

- Support for brackets in SteamID 3 format, e.g. `[U:1:123456]`


## [0.1.2] - 2017-01-15

### Added

### Changed

### Fixed

- Fixed handling of account IDs starting with 765.


## [0.1.1] - 2017-01-02

### Fixed

- Implements missing SteamID::SteamID.from_string method.


## [0.1.0] - 2017-01-02

### Added

- Module to allow conversion of SteamIDs into account IDs suitable for e.g.
  Hive 2 API calls.

  Supported are:
  - Steam ID
  - Steam ID 3
  - Steam ID 64
  - Community URL
  - Profile URL
