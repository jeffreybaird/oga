require 'spec_helper'

describe Oga::Lexer do
  context 'elements' do
    example 'lex an opening element' do
      lex('<p>').should == [
        [:T_ELEM_OPEN, nil, 1, 1],
        [:T_ELEM_NAME, 'p', 1, 2]
      ]
    end

    example 'lex an opening an closing element' do
      lex('<p></p>').should == [
        [:T_ELEM_OPEN, nil, 1, 1],
        [:T_ELEM_NAME, 'p', 1, 2],
        [:T_ELEM_CLOSE, nil, 1, 4]
      ]
    end

    example 'lex a paragraph element with text inside it' do
      lex('<p>Hello</p>').should == [
        [:T_ELEM_OPEN, nil, 1, 1],
        [:T_ELEM_NAME, 'p', 1, 2],
        [:T_TEXT, 'Hello', 1, 4],
        [:T_ELEM_CLOSE, nil, 1, 9]
      ]
    end

    example 'lex a paragraph element with attributes' do
      lex('<p class="foo">Hello</p>').should == [
        [:T_ELEM_OPEN, nil, 1, 1],
        [:T_ELEM_NAME, 'p', 1, 2],
        [:T_ATTR, 'class', 1, 4],
        [:T_STRING, 'foo', 1, 10],
        [:T_TEXT, 'Hello', 1, 16],
        [:T_ELEM_CLOSE, nil, 1, 21]
      ]
    end
  end

  context 'nested elements' do
    example 'lex a nested element' do
      lex('<p><a></a></p>').should == [
        [:T_ELEM_OPEN, nil, 1, 1],
        [:T_ELEM_NAME, 'p', 1, 2],
        [:T_ELEM_OPEN, nil, 1, 4],
        [:T_ELEM_NAME, 'a', 1, 5],
        [:T_ELEM_CLOSE, nil, 1, 7],
        [:T_ELEM_CLOSE, nil, 1, 11]
      ]
    end

    example 'lex nested elements and text nodes' do
      lex('<p>Foo<a>bar</a>baz</p>').should == [
        [:T_ELEM_OPEN, nil, 1, 1],
        [:T_ELEM_NAME, 'p', 1, 2],
        [:T_TEXT, 'Foo', 1, 4],
        [:T_ELEM_OPEN, nil, 1, 7],
        [:T_ELEM_NAME, 'a', 1, 8],
        [:T_TEXT, 'bar', 1, 10],
        [:T_ELEM_CLOSE, nil, 1, 13],
        [:T_TEXT, 'baz', 1, 17],
        [:T_ELEM_CLOSE, nil, 1, 20]
      ]
    end
  end

  context 'void elements' do
    example 'lex a void element' do
      lex('<br />').should == [
        [:T_ELEM_OPEN, nil, 1, 1],
        [:T_ELEM_NAME, 'br', 1, 2],
        [:T_ELEM_CLOSE, nil, 1, 6]
      ]
    end

    example 'lex a void element with an attribute' do
      lex('<br class="foo" />').should == [
        [:T_ELEM_OPEN, nil, 1, 1],
        [:T_ELEM_NAME, 'br', 1, 2],
        [:T_ATTR, 'class', 1, 5],
        [:T_STRING, 'foo', 1, 11],
        [:T_ELEM_CLOSE, nil, 1, 18]
      ]
    end
  end

  context 'elements with namespaces' do
    example 'lex an element with namespaces' do
      lex('<foo:p></p>').should == [
        [:T_ELEM_OPEN, nil, 1, 1],
        [:T_ELEM_NS, 'foo', 1, 2],
        [:T_ELEM_NAME, 'p', 1, 6],
        [:T_ELEM_CLOSE, nil, 1, 8]
      ]
    end
  end
end
