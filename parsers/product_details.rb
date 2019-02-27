
body = Nokogiri.HTML(content)


id = content[/(?<="id":")(.+?)(?=",)/]
ean = body.css("meta[@property='product:ean']").attr("content")
title = body.at("h1").text.gsub(/[\n\s]+/,' ').strip rescue ''

availability = body.css("meta[@property='product:availability']").attr("content").text.strip

availability = (availability=="instock")?"1":""
category = body.css("meta[@property='product:category']").attr("content")
brand = body.css("meta[@property='product:brand']").attr("content")


description = body.css("meta[@property='og:description']").attr("content")

image_url = body.css(".gallery__slider__img").attr("src")

price = body.css("meta[@property='product:price:amount']").attr("content")
rating = body.css(".starbar__star--active").length
review = body.at(".starbar__counter").to_i

item_size = nil
uom = nil
in_pack = nil

[title,description].each do |size_text|
  next unless size_text
  regexps = [
      /(\d*[\.,]?\d+)\s?([Ff][Ll]\.?\s?[Oo][Zz])/,
      /(\d*[\.,]?\d+)\s?([Oo][Zz])/,
      /(\d*[\.,]?\d+)\s?([Ff][Oo])/,
      /(\d*[\.,]?\d+)\s?([Ee][Aa])/,
      /(\d*[\.,]?\d+)\s?([Ff][Zz])/,
      /(\d*[\.,]?\d+)\s?(Fluid Ounces?)/,
      /(\d*[\.,]?\d+)\s?([Oo]unce)/,
      /(\d*[\.,]?\d+)\s?([Cc][Ll])/,
      /(\d*[\.,]?\d+)\s?([Mm][Ll])/,
      /(\d*[\.,]?\d+)\s?([Ll])/,
      /(\d*[\.,]?\d+)\s?([Gg])/,
      /(\d*[\.,]?\d+)\s?([Ll]itre)/,
      /(\d*[\.,]?\d+)\s?([Ss]ervings)/,
      /(\d*[\.,]?\d+)\s?([Pp]acket\(?s?\)?)/,
      /(\d*[\.,]?\d+)\s?([Cc]apsules)/,
      /(\d*[\.,]?\d+)\s?([Tt]ablets)/,
      /(\d*[\.,]?\d+)\s?([Tt]ubes)/,
      /(\d*[\.,]?\d+)\s?([Cc]hews)/,
      /(\d*[\.,]?\d+)\s?([Mm]illiliter)/i,
  ]
  regexps.find {|regexp| size_text =~ regexp}
  item_size = $1
  uom = $2

  break item_size, uom if item_size && uom
end

[title,description].each do |size_text|
  match = [
      /(\d+)\s?[xX]/,
      /Pack of (\d+)/,
      /Box of (\d+)/,
      /Case of (\d+)/,
      /(\d+)\s?[Cc]ount/,
      /(\d+)\s?[Cc][Tt]/,
      /(\d+)[\s-]?Pack($|[^e])/,
      /(\d+)[\s-]pack($|[^e])/,
      /(\d+)[\s-]?[Pp]ak($|[^e])/,
      /(\d+)[\s-]?Tray/,
      /(\d+)\s?[Pp][Kk]/,
      /(\d+)\s?([Ss]tuks)/i,
      /(\d+)\s?([Pp]ak)/i,
      /(\d+)\s?([Pp]ack)/i,
      /[Pp]ack\s*of\s*(\d+)/,
  ].find {|regexp| size_text =~ regexp}
  in_pack = $1

  break in_pack if in_pack
end


in_pack ||= '1'


product_details = {
    # - - - - - - - - - - -
    RETAILER_ID: '122',
    RETAILER_NAME: 'mytime',
    GEOGRAPHY_NAME: 'DE',
    # - - - - - - - - - - -
    SCRAPE_INPUT_TYPE: page['vars']['input_type'],
    SCRAPE_INPUT_SEARCH_TERM: page['vars']['search_term'],
    SCRAPE_INPUT_CATEGORY: page['vars']['input_type'] == 'taxonomy' ? category : '-',
    SCRAPE_URL_NBR_PRODUCTS: page['vars']['SCRAPE_URL_NBR_PRODUCTS'],
    # - - - - - - - - - - -
    SCRAPE_URL_NBR_PROD_PG1: page['vars']['SCRAPE_URL_NBR_PRODUCTS_PG1'],
    # - - - - - - - - - - -
    PRODUCT_BRAND: brand,
    PRODUCT_RANK: page['vars']['rank'],
    PRODUCT_PAGE: page['vars']['page'],
    PRODUCT_ID: id,
    UPC: "",
    EAN: ean,
    PRODUCT_NAME: title,
    PRODUCT_DESCRIPTION: description,
    PRODUCT_MAIN_IMAGE_URL: image_url,
    PRODUCT_ITEM_SIZE: (item_size rescue ''),
    PRODUCT_ITEM_SIZE_UOM: (uom rescue ''),
    PRODUCT_ITEM_QTY_IN_PACK: (in_pack rescue ''),
    PRODUCT_STAR_RATING: rating,
    PRODUCT_NBR_OF_REVIEWS: review,
    SALES_PRICE: price,
    IS_AVAILABLE: availability,
    PROMOTION_TEXT: page['vars']['promo_text'],
    EXTRACTED_ON: Time.now.to_s,

}
product_details['_collection'] = 'products'


outputs << product_details
