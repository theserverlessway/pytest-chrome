# PyTest Chrome headless Integration test suite

This repository contains a py.test and Chrome Headless setup for running your integration tests. The tests are written in Python using Selenium and Headless Chrome.

A Dockerfile is integrated as well to allow anyone with Docker installed to run the tests easily without the setup hassle.

## Running the tests

The included Makefile allows you to run the whole test suite with `make test`. It uses docker-compose to run the build and will rebuild the container on every run (with caching by default). You can run `make build-no-cache` to completely rebuild the container.

### Selecting the base url

You can set the base url the system tests against with the `--base-url` cli argument:

```
py.test tests --base-url https://google.com
```

The default is set in `pytest.ini`

### Developing tests

Running `make dev` will start a shell inside the Docker container with everything set up for you to run the tests.

### Running an individual file or test

Either inside the development container or with docker compose you can select to run only specific files or tests

The following will run a single file inside the container or with docker-compose from the host
```
pytest tests/homepage/test_landing.py
docker-compose run integration pytest tests/homepage/test_landing.py
```

The -k option of pytest allows you to use string matching to select only specific test cases. The following will run any tests that contain the word `cookie` in the method name.

```
pytest tests -k cookie
docker-compose run integration pytest tests -k cookie
```

You can also combine both and select a test case only for a specific file

```
pytest tests/homepage/test_landing.py -k cookie
docker-compose run integration pytest tests/homepage/test_landing.py -k cookie
```

### Debugging

For debugging purposes you can either use log statements in your tests or screenshots.

#### Logging

By default pytest only shows log output for failed tests. If you want to see the log output regardles use `-s` for your tests

```
pytest -s tests/homepage/test_landing.py
```

The output will be mixed together with Pytest output, so sometimes it can be a bit hard to read.

#### Screenshots

The test suite contains a Screenshot fixture you can include in your tests. You simply add the `screenshot` argument to a test method and it will be available:

```
def test_cookie_question(homepage, screenshot):
```

You can then call the screenshot function with a selenium object and a potential name. This will save the screenshot with a timestamp and identifier in the screenshots directory (which is gitignored).

```
screenshot(homepage, name='homepage')
```

## Documentation

Check out the unofficial [Selenium Python Documentation](http://selenium-python.readthedocs.io) for available commands to interact with pages. The [official documentation](https://seleniumhq.github.io/selenium/docs/api/py/api.html#common) can provide more details but is a bit sparse on examples

The [Pytest Documentation](https://docs.pytest.org/en/latest/) can give you more insights into pytest.

For more information on the pytest-selenium check out [their documentation](http://pytest-selenium.readthedocs.io/)


## Common problems

* Implicit Waits: By default python selenium does not implicitly wait for any objects to be added by javascript, which means that if you want to find an object on the website and its not there but has to be added by Javascript the test will fail. This is to make sure tests run fast and selenium isn't constantly waiting on elements to be added to the page. You can overwrite this by either setting the implicit wait default in the `conftest.py` file or to set it in tests you need it.
