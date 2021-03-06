require 'json'
require_relative 'author'
require_relative 'book'
require_relative 'reader'
require_relative 'order'
# Class for managing orders/readers/books/authors
class Library
  attr_accessor :books, :orders, :readers, :authors

  def initialize
    @books = []
    @orders = []
    @readers = []
    @authors = []
  end

  def add_book(object)
    validate_object(object, Book)
    @books << object_parser(object)
  end

  def add_author(object)
    validate_object(object, Author)
    @authors << object_parser(object)
  end

  def add_reader(object)
    validate_object(object, Reader)
    @readers << object_parser(object)
  end

  def add_order(object)
    validate_object(object, Order)
    @orders << object_parser(object)
  end

  def save_to_db(items, filename)
    file = File.open("storage/#{filename}.json", 'a+')
    items.map { |item| file.puts(item.to_json) }
    file.close
  end

  def popular_book
    sorted_books = sort_items('book')
    puts 'The most popular book is ' + sorted_books.last[0]
  end

  def active_reader
    sorted_readers = sort_items('reader')
    puts 'The most active reader is ' + sorted_readers.last[0]
  end

  def count_books_readers
    count = sort_items('book').last(3).flatten
                .uniq { |order| order['reader'] }.drop(1).size
    puts count.to_s + ' people ordered 3 popular books'
  end

  private

  def object_parser(object)
    attributes = {}
    object.instance_variables.each do |attr|
      attributes[attr.to_s.delete('@')] = object.instance_variable_get(attr)
    end
    attributes
  end

  def validate_object(object, classname)
    unless object.is_a? classname
      raise ArgumentError, "Needed #{classname} object, #{object.class} given"
    end
  end

  def retrieve_db_data(filename)
    file = File.open("storage/#{filename}.json", 'r')
    file.map { |item| JSON.parse(item) }
  end

  def sort_items(item)
    items = retrieve_db_data('orders').group_by { |order| order[item] }
    items.sort_by { |_, val| val.length }
  end
end

library = Library.new

author_1 = Author.new('Author_1', 'Author_1 biography')
author_2 = Author.new('Author_2', 'Author_2 biography')

book_1 = Book.new('Book_1', author_1.name)
book_2 = Book.new('Book_2', author_2.name)
book_3 = Book.new('Book_3', author_2.name)
book_4 = Book.new('Book_4', author_2.name)

reader_1 = Reader.new('Reader_1', 'email@email_1', 'City_1', 'Street_1', 1)
reader_2 = Reader.new('Reader_2', 'email@email_2', 'City_2', 'Street_2', 2)

order_1 = Order.new(book_4.title, reader_1.name, Time.now)
order_2 = Order.new(book_1.title, reader_1.name, Time.now)
order_3 = Order.new(book_3.title, reader_2.name, Time.now)
order_4 = Order.new(book_2.title, reader_2.name, Time.now)
order_5 = Order.new(book_1.title, reader_2.name, Time.now)
order_6 = Order.new(book_1.title, reader_2.name, Time.now)

library.add_author(author_1)
library.add_author(author_2)

library.add_reader(reader_1)
library.add_reader(reader_2)

library.add_book(book_1)
library.add_book(book_2)
library.add_book(book_3)
library.add_book(book_4)

library.add_order(order_1)
library.add_order(order_2)
library.add_order(order_3)
library.add_order(order_4)
library.add_order(order_5)
library.add_order(order_6)

library.save_to_db(library.books, 'books')
library.save_to_db(library.authors, 'authors')
library.save_to_db(library.readers, 'readers')
library.save_to_db(library.orders, 'orders')

library.popular_book
library.active_reader
library.count_books_readers
