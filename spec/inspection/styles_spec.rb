require "spec_helper"

RSpec.describe Styler, "#styles" do
  it "with just the default collection" do
    subject = described_class.new do
      style :btn, [:pa3, :blue]
    end

    expect(subject.styles).to match_array [subject.btn]
  end

  it "with style with arguments" do
    subject = described_class.new do
      style :btn do |color|
        [:pa3, color]
      end
    end

    expect(subject.styles).to match_array [subject.btn]
  end

  it "with one collection" do
    subject = described_class.new do
      style :btn, [:pa3, :blue]

      collection :buttons do
        style :btn, [:pa3, :red]
      end
    end

    expect(subject.styles).to match_array [subject.btn]
  end

  it "with styles only on collection" do
    subject = described_class.new do
      collection :buttons do
        style :btn, [:pa3, :red]
      end
    end

    expect(subject.styles).to match_array []
  end
end
