# while true; do
#   find . -iname "*.rb" | entr -d sh -c 'standardrb --fix "$1" && ruby lib/resume/html.rb' > dev.html -- /_
# done


# while true; do
#   find . -iname "*.rb" | entr -d sh -c 'standardrb --fix "$1" && ruby lib/resume/css.rb' -- /_
# done


# ruby lib/resume/css.rb
# ruby lib/resume/html.rb
ruby lib/resume/pdf.rb
