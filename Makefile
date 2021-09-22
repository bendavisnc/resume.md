
RESUME_TITLE=Sample Resume
RESUME_MARKDOWN=markdown/dorothy.md
RESUME_HTML_DOC_TEMPLATE=assets/resume_template.html
RESUME_OUTPUT=./out
RESUME_STYLE=less/fonts-android.less assets/fontsquirrel_roboto.css

resume: prep $(RESUME_OUTPUT)/resume.pdf 

dev: prep autotest

test:
	rspec --fail-fast --failure-exit-code 0

autotest:
	ls spec/* lib/* less/* $(RESUME_MARKDOWN) | entr rspec --fail-fast --failure-exit-code 0

run: resume

autorun:
	ls spec/* lib/* less/* $(RESUME_MARKDOWN) | entr make run

$(RESUME_OUTPUT)/resume.pdf: $(RESUME_OUTPUT)/resume.css $(RESUME_OUTPUT)/resume.html 
	echo "Creating pdf!"
	ruby lib/resume_cli.rb pdf "$(RESUME_MARKDOWN)" "$(RESUME_HTML_DOC_TEMPLATE)" "$(RESUME_TITLE)" > $(RESUME_OUTPUT)/resume.pdf; 

$(RESUME_OUTPUT)/resume.html: $(RESUME_MARKDOWN)
	echo "Creating html!"
	ruby lib/resume_cli.rb html "$(RESUME_MARKDOWN)" "$(RESUME_HTML_DOC_TEMPLATE)" "$(RESUME_TITLE)" > $(RESUME_OUTPUT)/resume.html; 

$(RESUME_OUTPUT)/resume.css: less/resume.less
	echo "Creating css!"
	find  less/resume.less $(RESUME_STYLE) -exec lessc {} \; > $@;

clean:
	rm -rf $(RESUME_OUTPUT); \
	rm -rf node_modules;

prep: clean
	mkdir $(RESUME_OUTPUT); \
	bundle install; \
	npm install -g less; \