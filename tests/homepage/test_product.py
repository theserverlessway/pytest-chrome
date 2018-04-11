def test_title(homepage):
    homepage.find_element_by_link_text('Tool Suite').click()
    assert "The Serverless Way Tool Suite" in homepage.title
