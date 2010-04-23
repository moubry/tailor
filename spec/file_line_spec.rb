require File.dirname(__FILE__) + '/spec_helper.rb'
require 'tailor/file_line'

include Tailor

describe Tailor::FileLine do
  context "should return the number of leading spaces in a line" do
    it "when the line is not indented" do
      line = FileLine.new "def do_something"
      line.indented_spaces.should == 0
    end

    it "when the line is indented 1 space" do
      line = FileLine.new " def do_something"
      line.indented_spaces.should == 1
    end

    it "when the line is indented 1 space and a hard tab" do
      line = FileLine.new " \tdef do_something"
      line.indented_spaces.should == 1
    end
  end

  context "should check hard tabs" do
    it "when the line is indented 1 hard tab" do
      line = FileLine.new "\tdef do_something"
      line.hard_tabbed?.should be_true
    end

    it "when the line is indented with a space and 1 hard tab" do
      line = FileLine.new " \tdef do_something"
      line.hard_tabbed?.should be_true
    end

    it "when the line is indented with a space" do
      line = FileLine.new " def do_something"
      line.hard_tabbed?.should be_false
    end

    it "when the line is not indented" do
      line = FileLine.new "def do_something"
      line.hard_tabbed?.should be_false
    end
  end

  context "should check for camel case when" do
    it "is a method and the method name is camel case" do
      line = FileLine.new "def doSomething"
      line.camel_case_method?.should be_true
    end

    it "is a method and the method name is snake case" do
      line = FileLine.new "def do_something"
      line.camel_case_method?.should be_false
    end

    it "is a class and the class name is camel case" do
      line = FileLine.new "class AClass"
      line.camel_case_class?.should be_true
    end

    it "is a class and the class name is snake case" do
      line = FileLine.new "class A_Class"
      line.camel_case_class?.should be_false
    end
  end

  it "should detect the number of trailing whitespace(s)" do
    line = FileLine.new "  puts 'This is a line.'  \n"
    line.trailing_whitespace_count.should == 2
  end

  # TODO: These methods should probably all be called by line.check_comma_spacing
  #   or something.  As it stands, these tests are going to start to get confusing,
  #   plus having one entry point for checking commas probably makes the most sense.
  context "spacing after a comma" do
    it "should detect no space after a comma" do
      line = FileLine.new "  def do_something this,that"
      line.no_space_after_comma?.should be_true
    end

    it "should skip code that has 1 space after a comma" do
      line = FileLine.new "  def do_something this, that"
      line.no_space_after_comma?.should be_false
    end

    it "should detect 2 spaces after a comma" do
      line = FileLine.new "  def do_something this,  that"
      line.two_or_more_spaces_after_comma?.should be_true
    end

    it "should skip code that has 1 space after a comma" do
      line = FileLine.new "  def do_something this, that"
      line.two_or_more_spaces_after_comma?.should be_false
    end
  end

  context "comments" do
    it "should detect a regular full line comment" do
      line = FileLine.new "  # This is a comment."
      line.line_comment?.should be_true
    end

    it "should skip code that's not a full line comment" do
      line = FileLine.new "  puts 'this is some code.'"
      line.line_comment?.should be_false
    end
  end
end