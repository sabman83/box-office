require 'pdf-reader'
require 'pry-byebug'

def get_value items, str
  value = 0
  items.each do |item|
    regex = item + '[\s]+([-\d\.]+)' # matching the value following the text, could be negative
    regex = Regexp.new regex
    matches = regex.match(str)
    value += matches[1].to_f if !(matches.nil?)
  end
  value
end

pj_content = ""
File.open("data/quicken/PJ.11.26.pdf", "rb") do |io|
  reader = PDF::Reader.new(io)
  reader.pages.each do |p|
    pj_content += p.text
  end
end

mr_content = ""
File.open("data/quicken/MR11.26.pdf", "rb") do |io|
  reader = PDF::Reader.new(io)
  reader.pages.each do |p|
    mr_content += p.text
  end
end

File.open("data/quicken/PJ.txt", "w") do |f|
  f.write(pj_content)
end


alcohol_value = get_value(["Beer","Drinks - Alcoholic","Wine"], mr_content)

concession_value = get_value(["Candy", "Popcorn","Sweets"], mr_content)

discounts_value = get_value(["Discounts"], mr_content)
promotions_value = get_value(["Promotions"], mr_content)

kitchen_sales_value = get_value(["Entrees", "Kids Meals",  "Modifications - Charge", "Pizza",  "Sandwiches",
                 "Sides A La Carte", "Starters", "Surcharges", "Other - Food"], mr_content)

beverages_value = get_value(["Drinks – Non-Alcoholic","Hot Drinks"], mr_content)

puts "2	Marketing	Alcohol Sales	#{alcohol_value}
\n 3	Marketing	Concessions Sales	#{concession_value}
\n 4	Marketing	Discounts		#{discounts_value}
\n 5	Marketing	Promotions	#{promotions_value}
\n 6	Marketing	Kitchen/Food Sales	#{kitchen_sales_value}
\n 7	Marketing	Beverages	#{beverages_value}
"

BOSUNDRY[\s]+Box Office Sundry[\s]+ Box Office & Kitchen .*([-\d\.]+)
BOSUNDRY[\s]+Box Office Sundry[\s]+ Internet Ticketing .*([-\d\.]+)
BOADVANCE[\s]+Advance Sales  [\s]+ ([-\d\.]+)
