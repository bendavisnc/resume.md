while true; do
  find . -iname "*.rb" | entr -d sh -c 'rspec' -- /_
done

