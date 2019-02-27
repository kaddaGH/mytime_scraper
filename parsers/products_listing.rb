
body = Nokogiri.HTML(content)
products = body.css(".product-card__poster__link")
scrape_url_nbr_products = body.at_css(".nav-category__item--count").text.to_i

products.each_with_index do |product, i|
  pages << {
      page_type: 'product_details',
      method: 'GET',
      url: 'https://www.mytime.de'+product.attr("href") + "?search=#{page['vars']['search_term']}&rank=#{i + 1}",
      vars: {
          'input_type' => page['vars']['input_type'],
          'search_term' => page['vars']['search_term'],
          'SCRAPE_URL_NBR_PRODUCTS' => scrape_url_nbr_products,
          'rank' => i + 1,
          'page' => page['vars']['page']
      }

  }


end