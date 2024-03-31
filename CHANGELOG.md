Changelog
=========
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Unreleased
==========
### Added

### Changed

### Removed

### Fixed

### Security

---
[2.0.0]
- Add `where` option to `all` function
- Suffix is excluded by default. Suffix is only generated explicitly now with suffix: true.
- Generators have been added to make generating schema and "context" modules within Phoenix applications easier.
- Small refactoring making it slightly simpler to read through the `resource` macro
- Some documentation fixes

[1.3.3]
-------
### Fixed
- Incorrect functions generated when providing both `suffix: false` and other  options to the `resource` macro

---

[1.3.2]
-------
### Fixed
- Incorrect function name generation when providing both `suffix: false` and other options to the `resource` macro

---

[1.3.1]
-------
### Changed
- Allow keyword lists where currently only maps are supported

### Fixed
- Fixed some bad tests to have better assertions

---

[1.3.0]
-------
### Added
- `changeset` convenience function added

---

[1.2.0] - 2019-09-17
--------------------
### Added
- Now generates `get_by`, and `get_by!` functions
- `suffix: false` option
