#!/bin/bash

books_directory="$HOME/documents/books"
recent_books_file="$HOME/.config/nvim/tmp/recent_books.txt"

inotifywait -m -e CREATE -e OPEN -r "$books_directory" |
while read -r path action file; do
    if [[ $file == *.pdf ]]; then
        echo "$path/$file" >>"$recent_books_file"
        # Remove duplicates and overwrite the recent_books_file
        sort -u -o "$recent_books_file" "$recent_books_file"
    fi
done
