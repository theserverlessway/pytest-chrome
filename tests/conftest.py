import pytest
import os
import datetime


# Here you can add any Chrome options
@pytest.fixture
def chrome_options(chrome_options):
    chrome_options.add_argument('headless')
    chrome_options.add_argument('disable-gpu')
    chrome_options.add_argument('window-size=1200x600')
    return chrome_options


# Here you can set default options for Selenium
@pytest.fixture
def selenium(selenium):
    # Setting implicit wait to 0 Seconds so javascript has some time
    # to load and add objects. Increasing this further can make tests slower,
    # so be careful
    # selenium.implicitly_wait(0.5)
    return selenium


# This fixture will go to the base_url by default and can then be used for further steps
@pytest.fixture
def homepage(selenium, base_url):
    print(base_url)
    selenium.get(base_url)
    return selenium


# This Screenshot fixture will create a screenshots folder if it doesn't exist
# and save any screenshots to it with a timestamp and an optional name
# Example: screenshot(homepage, name='homepage')
@pytest.fixture
def screenshot():
    def shot(selenium, name=''):
      directory = 'screenshots'
      if not os.path.exists(directory):
        os.makedirs(directory)
      identifier = datetime.datetime.now().isoformat()
      if name:
        identifier = f'{identifier}-{name}'
      filename = f'{directory}/{identifier}.png'
      print(f'Storing Screenshot to {filename}')
      selenium.get_screenshot_as_file(filename)
    return shot