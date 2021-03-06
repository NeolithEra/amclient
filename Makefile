.DEFAULT_GOAL := help

.PHONY: clean package package-deps package-source package-upload package-wheel

package-deps:                                   ## Upgrade dependencies for packaging
	python3 -m pip install --upgrade twine wheel

package-source:                                 ## Package the source code
	python3 setup.py sdist

package-wheel: package-deps                     ## Package a Python wheel
	python3 setup.py bdist_wheel --universal

package-check: package-source package-wheel     ## Check the distribution is valid
	twine check dist/*

package-upload: package-deps package-check      ## Upload package
	twine upload dist/* --repository-url https://upload.pypi.org/legacy/

package: package-upload

clean:  ## Clean the package directory
	rm -rf amclient.egg-info/
	rm -rf build/
	rm -rf dist/

help:  ## Print this help message.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
