Changelog
=========

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

[1.3.3]
### Fixed
- Incorrect functions generated when providing both `suffix: false` and other  options to the `resource` macro

[1.3.2]
------------
### Fixed
- Incorrect function name generation when providing both `suffix: false` and other options to the `resource` macro

[1.3.1]
------------

### Added

### Changed
- Allow keyword lists where currently only maps are supported

### Removed

### Fixed
- Fixed some bad tests to have better assertions

### Security


[1.3.0]
------------

### Added
- `changeset` convenience function added

### Changed

### Removed

### Fixed

### Security

[1.2.0] - 2019-09-17
--------------------
### Added
- Now generates `get_by`, and `get_by!` functions
- `suffix: false` option
