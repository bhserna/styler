require "spec_helper"

RSpec.describe Styler, "#collections" do
  it "with just the default collection" do
    subject = described_class.new do
      style :btn, ["pa3", "blue"]
    end

    expect(subject.collections).to match_array []
  end

  it "with one collection" do
    subject = described_class.new do
      collection :buttons do
        style :btn, ["pa3", "blue"]
      end
    end

    expect(subject.collections).to match_array [subject.buttons]
  end

  it "with two collections" do
    subject = described_class.new do
      collection :headers do
        style :h1, ["pa3"]
      end

      collection :buttons do
        style :btn, ["pa3", "blue"]
      end
    end

    expect(subject.collections).to match_array [subject.buttons, subject.headers]
  end

  it "with one nested collection" do
    subject = described_class.new do
      collection :headers do
        style :h1, ["pa3"]

        collection :buttons do
          style :btn, ["pa3", "blue"]
        end
      end
    end

    expect(subject.collections).to match_array [subject.headers]
  end

  it "with two nested collection" do
    subject = described_class.new do
      collection :headers do
        collection :titles do
          style :h1, ["pa3"]
        end

        collection :buttons do
          style :btn, ["pa3", "blue"]
        end
      end
    end

    expect(subject.collections).to match_array [subject.headers]
  end

  it "with collection wiht arguments" do
    subject = described_class.new do
      collection :headers do
      end

      collection :buttons do |color|
        style :btn, ["pa3", color]
      end
    end

    expect(subject.collections).to match_array [subject.headers, subject.buttons]
  end
end
