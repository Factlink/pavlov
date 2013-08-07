## Steps for releasing Pavlov

- Ensure all test pass.
- Bump version number in `version.rb`
- Update `CHANGELOG.md`

- Commit these changes.

Build the gem:

```
gem build pavlov.gemspec
gem push pavlov-0.1.x.gem 
```

Create tag:

```
git tag -a v0.1.x -m 'Version 0.1.x' <last-commit>
git push --tags
```

On Github, update the release with the changelog information:

https://github.com/Factlink/pavlov/releases/edit/v0.1.x
