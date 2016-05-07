require 'json'
require 'active_support/core_ext/kernel/reporting'
require_relative '../author'
require_relative '../book'
require_relative '../reader'
require_relative '../order'
require_relative '../library'

library = Library.new

RSpec.shared_examples 'Check add_methods' do |object, object2, method|
  it 'Check given object type.' do
    expect { library.send(method.to_sym, object) }.to raise_error(ArgumentError)
  end

  it 'Check add_methods return value.' do
    expect(library.send(method.to_sym, object2).class).to eq(Array)
  end
end

RSpec.shared_examples 'Check statistics methods' do |method|
  it 'Check statistics methods return value.' do
    expect(STDOUT).to receive(:puts).with(include('most'))
    library.send(method.to_sym)
  end
end

RSpec.describe Library do
  book = Book.allocate
  author = Author.allocate
  include_examples 'Check add_methods', book, author, 'add_author'
  include_examples 'Check add_methods', book, Reader.allocate, 'add_reader'
  include_examples 'Check add_methods', book, Order.allocate, 'add_order'
  include_examples 'Check add_methods', author, Book.allocate, 'add_book'
  include_examples 'Check statistics methods', 'active_reader'
  include_examples 'Check statistics methods', 'popular_book'
  include_examples 'Check statistics methods', 'count_books_readers'
end
