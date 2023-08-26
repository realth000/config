## Dart lint rules

1. Add `surf_lint_rules` as dependency to your `pubspec.yaml`:

``` bash
flutter pub add surt_lint_rules
```

2. add `include` in analysis_options.yaml:

``` yaml
include:
  package:surf_lint_rules/analysis_options.yaml

analyzer:
  exclude:
    - lib/**.g.dart
    - lib/**.freezed.dart
```

## Dart build_runnner `build.yaml`

Redirect generated files to separate folder called "generated" by copying `build.yaml` to the project root directory.

Further more, add the following lines to `.gitignore`:

``` gitignore

lib/**.g.dart
lib/**.freezed.dart

```

