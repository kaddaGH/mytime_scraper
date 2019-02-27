require 'uri'

pages << {
    page_type: 'products_listing',
    method: 'GET',
    url: "https://www.mytime.de/Getraenke/Wasser_und_Erfrischungsgetraenke/Energy_Drinks_210002705.html",
    vars: {
        'input_type' => 'taxonomy',
        'search_term' => '-',
        'page' => 1
    }


}

search_terms = ["Red Bull", "RedBull", "Energy Drink", "Energy Drinks"]
search_terms.each do |search_term|

  pages << {
      page_type: 'products_listing',
      method: 'GET',
      url: "https://www.mytime.de/search?query=#{URI.encode(search_term)}",
      vars: {
          'input_type' => 'search',
          'search_term' => search_term,
          'page' => 1
      }


  }

end