require "spec_helper"

RSpec.describe Styler, "style" do
  it "with just one class" do
    subject = described_class.new do
      style :btn, ["blue"]
    end

    expect(subject.btn.to_s).to eq "blue"
  end

  it "with two classes" do
    subject = described_class.new do
      style :btn, ["blue", "bg_blue"]
    end

    expect(subject.btn.to_s).to eq "blue bg_blue"
    expect(subject.btn).to eq subject.btn
  end

  it "two styles classes" do
    subject = described_class.new do
      style :btn, ["blue", "bg_blue"]
      style :title, ["red"]
    end

    expect(subject.btn.to_s).to eq "blue bg_blue"
    expect(subject.title.to_s).to eq "red"
  end

  it "styles with other styles classes" do
    subject = described_class.new do
      style :blue, ["blue", "bg_blue"]
      style :btn, [:pa3, :ma3]
      style :big_btn, [blue, btn]
    end

    expect(subject.blue.to_s).to eq "blue bg_blue"
    expect(subject.btn.to_s).to eq "pa3 ma3"
    expect(subject.big_btn.to_s).to eq "blue bg_blue pa3 ma3"
  end

  it "with re-defined style" do
    subject = described_class.new do
      style :danger, ["blue"]
      style :danger, ["red"]
    end

    expect(subject.danger.to_s).to eq "red"
  end

  it "simple substraction" do
    subject = described_class.new do
      style :default, ["pa3", "blue"]
      style :danger, [default - "blue", "red"]
    end

    expect(subject.default.to_s).to eq "pa3 blue"
    expect(subject.danger.to_s).to eq "pa3 red"
  end

  it "double substraction" do
    subject = described_class.new do
      style :default, ["pa3", "blue", "bg_blue"]
      style :danger, [default - "blue" - "bg_blue", "red", "bg_red"]
    end

    expect(subject.default.to_s).to eq "pa3 blue bg_blue"
    expect(subject.danger.to_s).to eq "pa3 red bg_red"
  end

  it "passing arguments" do
    subject = described_class.new do
      style :default_color do |project|
        if project[:color] == "blue"
          ["bg_blue"]
        else
          ["bg_red"]
        end
      end
    end

    project = { color: "blue" }
    expect(subject.default_color(project).to_s).to eq "bg_blue"
  end

  it "using styles that need arguments but already defined" do
    project = { color: "blue" }

    subject = described_class.new do
      style :default_color do |project|
        if project[:color] == "blue"
          ["bg_blue"]
        else
          ["bg_red"]
        end
      end

      style :title, [default_color(project), "pa3"]
    end

    expect(subject.title(project).to_s).to eq "bg_blue pa3"
  end

  it "using styles that need arguments" do
    subject = described_class.new do
      style :default_color do |project|
        if project[:color] == "blue"
          ["bg_blue"]
        else
          ["bg_red"]
        end
      end

      style :title do |project|
        [default_color(project), "pa3"]
      end
    end

    project = { color: "blue" }
    expect(subject.title(project).to_s).to eq "bg_blue pa3"
  end
end
