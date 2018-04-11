def test_title(homepage):
    assert "The Serverless Way" in homepage.title


def test_links(homepage):
    product_links = homepage.find_elements_by_link_text('About Serverless')
    assert len(product_links) == 2
    product_links[0].click()
    assert "Introduction to Serverless" in homepage.title
