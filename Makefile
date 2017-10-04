#    Copyright 2017 Cargill Incorporated
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

test: test-app test-templates test-render-templates ## run all local tests

test-templates: FORCE ## Unit test templates
	./test-templates

test-render-templates: FORCE ## Render all template examples
	./test-render-templates

test-app: FORCE ## Run Pipewrench application tests
	python setup.py test

install: FORCE ## Install Pipewrench locally
	python setup.py install

env: venv ## Create a virtual environment
	virtualenv venv

clean: ## Remove all files
	$(RM) -r dist
	$(RM) -r pipewrench.egg-info
	$(RM) -r build
	$(RM) -r examples/*/output

clean-render-templates: ## Clean rendered templates from test
	for example in $$(ls examples); do \
	    $(RM) examples/$${example}/output; \
	done

pylint: 
	pylint pipewrench/merge.py

build: pylint test 

FORCE: ## Do nothing, always

.PHONY: test

.PHONY: test-templates

.PHONY: test-render-templates

.PHONY: install

.PHONY: env

.PHONY: clean

.PHONY: pylint

.PHONY: build

