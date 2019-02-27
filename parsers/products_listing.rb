
body = Nokogiri.HTML(content)
products = body.css(".product-card__poster__link")
scrape_url_nbr_products = body.at_css(".nav-category__item--count").text.to_i
next_page = body.css(".nav-category__pagination--next").attr("href").text rescue nil

products.each_with_index do |product, i|
  pages << {
      page_type: 'product_details',
      method: 'GET',
      url: 'https://www.mytime.de'+product.attr("href") + "?search=#{page['vars']['search_term']}&rank=#{i + 1}",
      vars: {
          'input_type' => page['vars']['input_type'],
          'search_term' => page['vars']['search_term'],
          'SCRAPE_URL_NBR_PRODUCTS' => scrape_url_nbr_products,
          'SCRAPE_URL_NBR_PRODUCTS_PG1' => products.length,
          'rank' => i + 1,
          'page' => page['vars']['page']
      }

  }


end


# get next page
if next_page
  next_page = next_page[/\d/].to_s

  pages << {
      page_type: 'products_listing',
      method: 'GET',
      url: page['url'].gsub(/page=\d+/,"page="+next_page) ,
      vars: {
          'input_type' => page['vars']['input_type'],
          'search_term' => page['vars']['search_term'],
          'SCRAPE_URL_NBR_PRODUCTS' => scrape_url_nbr_products,
          'SCRAPE_URL_NBR_PRODUCTS_PG1' => page['vars']['SCRAPE_URL_NBR_PRODUCTS_PG1'],
          'page' => next_page
      }


  }

end