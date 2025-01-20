#!/bin/bash

# Get tag name
tag=$1

# sample command
sample_command="sample: npm run generate-changelog -- v1.0.0"

# validate tag name
if [ -z "$tag" ]; then
  echo "Error: Tag name is required"
  echo $sample_command
  exit 1
fi

# semver regex
semver_regex="^v[0-9]+\.[0-9]+\.[0-9]+$"

# validate tag name with semver regex
if [[ ! $tag =~ $semver_regex ]]; then
  echo "Error: Invalid tag name. "
  echo $sample_command
  exit 1
fi

# get the latest tag in semantic version format.
latest_tag=$(git tag --sort=-v:refname | grep -E $semver_regex | head -n 1)

# create output directory
output_dir="blog/changelogs"
mkdir -p $output_dir

# get the range of commits
if [ -z "$latest_tag" ]; then
  echo "Warning: Not found any tag in semantic version format."
  echo "Generating changelog from the beginning"
  range=""
else
  echo "Latest tag: $latest_tag"
  echo "Generating changelog from $latest_tag to HEAD"
  range="$latest_tag..HEAD"
fi

# create changelog file
npm exec git-cliff -- --tag $tag --output $output_dir/CHANGELOG-$tag.md $range
