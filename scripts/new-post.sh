#!/bin/bash

# Script to create a new blog post or linkpost
# Usage: ./new-post.sh "post-title" OR ./new-post.sh https://example.com/article

# Check if argument is provided
if [ -z "$1" ]; then
    echo "Usage: ./new-post.sh \"post-title\" OR ./new-post.sh https://example.com/article"
    echo "Example: ./new-post.sh \"My New Blog Post\""
    echo "Example: ./new-post.sh https://simonwillison.net/2025/Jul/14/ccusage/"
    exit 1
fi

# Function to extract title from HTML
extract_title() {
    local html="$1"
    # Try to extract title tag content
    echo "$html" | grep -o '<title[^>]*>[^<]*</title>' | sed 's/<title[^>]*>//;s/<\/title>//' | head -1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

# Function to extract author from HTML
extract_author() {
    local html="$1"
    # Try various meta tags for author
    local author=$(echo "$html" | grep -i 'name="author"' | grep -o 'content="[^"]*"' | sed 's/content="//;s/"$//' | head -1)
    if [ -z "$author" ]; then
        author=$(echo "$html" | grep -i 'property="article:author"' | grep -o 'content="[^"]*"' | sed 's/content="//;s/"$//' | head -1)
    fi
    if [ -z "$author" ]; then
        author=$(echo "$html" | grep -i 'class="author"' | sed 's/<[^>]*>//g' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | head -1)
    fi
    echo "$author"
}

# Check if the argument is a URL
if [[ "$1" =~ ^https?:// ]]; then
    URL="$1"
    IS_LINKPOST=true
    
    echo "Fetching page metadata from: $URL"
    
    # Fetch the page content
    HTML_CONTENT=$(curl -s -L "$URL")
    
    # Extract title and author
    ORIGINAL_TITLE=$(extract_title "$HTML_CONTENT")
    ORIGINAL_AUTHOR=$(extract_author "$HTML_CONTENT")
    
    if [ -z "$ORIGINAL_TITLE" ]; then
        echo "Warning: Could not extract title from URL"
        ORIGINAL_TITLE="Untitled"
    fi
    
    # Create a title for our post
    TITLE="${ORIGINAL_TITLE}"
    
    echo "Found title: $ORIGINAL_TITLE"
    if [ -n "$ORIGINAL_AUTHOR" ]; then
        echo "Found author: $ORIGINAL_AUTHOR"
    fi
else
    # Regular blog post
    TITLE="$1"
    IS_LINKPOST=false
fi

# Create slug
SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//')
DATE=$(date +%Y-%m-%d)
DATETIME=$(date +%Y-%m-%dT%H:%M:%S%z)

# Define the file path with absolute path
FILEPATH="$HOME/repos/albertosadde.com/content/blog/${SLUG}.md"

# Check if file already exists
if [ -f "$FILEPATH" ]; then
    echo "Error: File already exists at $FILEPATH"
    exit 1
fi

# Create the blog post with frontmatter
if [ "$IS_LINKPOST" = true ]; then
    cat > "$FILEPATH" << EOF
---
title: "${TITLE}"
subtitle: ""
description: ""
stage: draft
date: ${DATETIME}
lastmod: ${DATETIME}
tags: []
ShowToc: false
TocOpen: false
draft: true
hidemeta: false
comments: true
canonicalURL: https://www.albertosadde.com/blog/${SLUG}
disableShareButtons: false
searchHidden: false
ShowReadingTime: true
cover:
  image: ""
original_url: "${URL}"
original_author: "${ORIGINAL_AUTHOR}"
original_title: "${ORIGINAL_TITLE}"
quote: ""
---

[${ORIGINAL_TITLE}](${URL})${ORIGINAL_AUTHOR:+ by ${ORIGINAL_AUTHOR}}

EOF
else
    cat > "$FILEPATH" << EOF
---
title: "${TITLE}"
subtitle: ""
description: ""
stage: draft
date: ${DATETIME}
lastmod: ${DATETIME}
tags: []
ShowToc: true
TocOpen: false
draft: true
hidemeta: false
comments: true
canonicalURL: https://www.albertosadde.com/blog/${SLUG}
disableShareButtons: false
searchHidden: false
ShowReadingTime: true
cover:
  image: ""
---

EOF
fi

echo "Created new blog post: $FILEPATH"

# Open in neovim
nvim "$FILEPATH"