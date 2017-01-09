#!/usr/bin/ruby
require 'mechanize'
require 'prawn'
=begin
running from terminal to download any pdf from issuu.com, given
- magazine name
- page count
- document-id
=end

prompt = "> "

puts "What is the name of the magazine you'd like to download from issuu.com? ps: this will be the name of your pdf file\n"
print prompt
magazine_name = gets.chomp


puts "How many pages does it have?\n ie 104\n"
print prompt
page_number = gets.chomp

puts "document Id? \n to get the 'document-id' inspect page in chrome,\n search for document-id and paste here,\n ie 140601160255-3a4c0f75ec731801ef369f5000f03104\n"
print prompt
document_id = gets.chomp

for i in 1..page_number.to_i
  print "downloading\tpage n #{i}\n"
  agent = Mechanize.new
  link = "http://image.issuu.com/#{document_id.to_s}/jpg/page_#{i.to_s}.jpg"
  agent.get(link).save "page_#{i.to_s}.jpg"
  print "downloaded\tpage n #{i}\n"
end

print "images from 1 to #{page_number.to_s} downloaded as jpg\n"

########to combine all images into a pdf

Prawn::Document.generate("#{magazine_name}.pdf", :page_layout => :portrait) do |pdf|

  for i in 1..page_number.to_i
      pdf.image "page_#{i.to_s}.jpg", :at => [0,750], :width => 530
      pdf.start_new_page
  end#end of loop
end

print "images from 1 to #{page_number.to_s} combined into pdf \n"

########to delete all images, once pdf as been created, to clean up a bit
for i in 1..page_number.to_i
  File.delete("page_#{i.to_s}.jpg")
end#end of prawn

print "images from 1 to #{page_number.to_s} deleted \n"
# print "your pdf #{magazine_name}.pdf is in: \n #{Dir.pwd}"


