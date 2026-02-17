# Changelog

All notable changes to this project will be documented in this file.

## [1.1.0](https://github.com/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration/compare/v1.0.0...v1.1.0) (2026-02-17)

### Features

* migrate to provider-specific storage integration resources ([5af91f5](https://github.com/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration/commit/5af91f56314f2119ddf389ef86c4f23f65f42b8d))
* restructure to single-module layout and upgrade to Snowflake provider v1.0.0 ([70f5728](https://github.com/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration/commit/70f5728a44d322b81601917deb039b06addae302))
* restructure to single-module repository layout ([07ece6f](https://github.com/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration/commit/07ece6f70e45b6126cff0edb3000aa7201c10e91))
* **storage-integration:** add explicit storage_provider attributes ([ecf5a91](https://github.com/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration/commit/ecf5a9106aa9174fe52198cb8cb24075697342db))

### Bug Fixes

* **outputs:** mark storage integration outputs as sensitive ([a4bf8d1](https://github.com/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration/commit/a4bf8d1af8b092acc4b5a400024f0958d82449d8))
* **outputs:** update storage integration outputs to use describe_output ([00d53b1](https://github.com/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration/commit/00d53b15565a7ed426bac358b1c7a4e3f446c4b0))
* **storage-integration:** remove redundant storage_provider attributes ([7c544a5](https://github.com/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration/commit/7c544a5f9a9619c6b5a2d009f98718a101c9982c))
* **variables:** validate azure_tenant_id as non-empty string ([c71a597](https://github.com/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration/commit/c71a59765294c5e34df10bb04055211b5ff252f1))

## [unreleased]

### 🚀 Features

- Restructure to single-module repository layout
- Restructure to single-module layout and upgrade to Snowflake provider v1.0.0
- Migrate to provider-specific storage integration resources
- *(storage-integration)* Add explicit storage_provider attributes

### 🐛 Bug Fixes

- *(storage-integration)* Remove redundant storage_provider attributes
- *(variables)* Validate azure_tenant_id as non-empty string
- *(outputs)* Update storage integration outputs to use describe_output
- *(outputs)* Mark storage integration outputs as sensitive

### 📚 Documentation

- Update CHANGELOG.md [skip ci]
- Update CHANGELOG.md [skip ci]
- Update CHANGELOG.md [skip ci]
- Update CHANGELOG.md [skip ci]
- Update CHANGELOG.md [skip ci]
- Remove redundant storage integration outputs and update documentation
- Update CHANGELOG.md [skip ci]
- Update CHANGELOG.md [skip ci]

### 🎨 Styling

- *(examples)* Align provider config and enable preview features
- *(examples)* Align snowflake provider config formatting
## [1.0.0] - 2026-02-07

### 🐛 Bug Fixes

- *(ci)* Resolve semantic-release missing plugin error

### 💼 Other

- *(ci)* Add missing conventional-changelog plugin to semantic-release"

### 📚 Documentation

- Update CHANGELOG.md [skip ci]
- Update CHANGELOG.md [skip ci]
- Update CHANGELOG.md [skip ci]
- Update CHANGELOG.md [skip ci]
- Update CHANGELOG.md [skip ci]
- Update CHANGELOG.md [skip ci]
- Update CHANGELOG.md [skip ci]

### 🎨 Styling

- Align Snowflake provider configuration and enable preview features

### ⚙️ Miscellaneous Tasks

- Implement snowflake storage integration module
- Update documentation and CI for storage integration module
- Update CI pipeline and module for multi-cloud storage integration support
- Update Snowflake CI pipeline and storage integration module
- Downgrade semantic-release-action and update snowflake storage integration
- *(release)* Trigger initial release
- *(release)* Version 1.0.0 [skip ci]
