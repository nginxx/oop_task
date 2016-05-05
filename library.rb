require 'json'
require 'active_support/inflector'
require_relative 'author'
require_relative 'book'
require_relative 'reader'
require_relative 'order'
# Class for managing orders/readers/books/authors
class Library
  attr_accessor :books, :orders, :readers, :authors

  def initialize(*args)
    args.map do |source|
      items = []
      file = File.open("storage/#{source}.json", 'a+')
      file.map do |item|
        item = JSON.parse(item)
        items << item
      end
      instance_variable_set("@#{source}".to_sym, items)
    end
  end

  def save_item(item_object)
    attributes = {}
    file_name = item_object.class.to_s.downcase.pluralize
    file = File.open("storage/#{file_name}.json", 'a')
    item_object.instance_variables.map do |attr|
      attributes[attr.to_s.delete('@')] = item_object.instance_variable_get(attr)
    end
    file.puts(attributes.to_json)
  end

  def popular_book
  end
end

library = Library.new('books', 'orders', 'readers', 'authors')
author = Author.new('Ivan', 'Ivan biography')
book = Book.new('King', author.name)
reader = Reader.new('Sergei', 'email@email.com', 'Kiev', 'Uliyanova str.', '152')
order = Order.new(book.title, reader.name, Time.now)
library.save_item(book)
library.save_item(author)
library.save_item(reader)
library.save_item(order)

puts library.books



