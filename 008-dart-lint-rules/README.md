# Dart lint rules

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
```
