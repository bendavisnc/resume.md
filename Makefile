
RESUME_HTML_DEV_PORT=8080
RESUME_TITLE=Sample Resume
RESUME_MARKDOWN=markdown/dorothy.md
RESUME_HTML_DOC_TEMPLATE=assets/resume_template.html
RESUME_OUTPUT=./out
RESUME_MORE_LESS=less/fonts-android.less

resume: prep $(RESUME_OUTPUT)/resume.pdf 

dev: prep watch

test:
	rspec --fail-fast --failure-exit-code 0

autotest:
	ls spec/* lib/* less/* $(RESUME_MARKDOWN) | entr rspec --fail-fast --failure-exit-code 0

watch:
	ls resume.rb less/* $(RESUME_MARKDOWN) | entr make $(RESUME_OUTPUT)/resume.html $(RESUME_OUTPUT)/resume.css;

$(RESUME_OUTPUT)/resume.pdf: $(RESUME_OUTPUT)/resume.html $(RESUME_OUTPUT)/resume.css 
	node pdf.js; 

$(RESUME_OUTPUT)/resume.html: $(RESUME_MARKDOWN)
	ruby lib/resume_cli.rb html "$(RESUME_MARKDOWN)" "$(RESUME_HTML_DOC_TEMPLATE)" "$(RESUME_TITLE)" > $(RESUME_OUTPUT)/resume.html; 

$(RESUME_OUTPUT)/resume.css: less/resume.less
	find  less/resume.less $(RESUME_MORE_LESS) -exec lessc {} \; > $@;

clean:
	rm -rf $(RESUME_OUTPUT); \
	rm -rf node_modules;

prep: clean
	mkdir $(RESUME_OUTPUT); \
	cp -r fonts $(RESUME_OUTPUT); \
	bundle install; \
	npm install -g less; \
	npm install -i puppeteer;





